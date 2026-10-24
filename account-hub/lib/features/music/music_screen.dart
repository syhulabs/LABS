import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/routes.dart';
import '../../app/theme/app_theme.dart';
import '../../core/json_list.dart';
import '../../data/db/app_database.dart';
import '../../data/repositories/account_repository.dart';
import '../../domain/enums.dart';
import '../../shared/widgets/account_tile.dart';
import '../../shared/widgets/app_card.dart';
import '../../shared/widgets/confirm_dialog.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/page_scaffold.dart';
import '../../shared/widgets/pickers.dart';
import '../../shared/widgets/platform_logo.dart';
import '../../shared/widgets/section_header.dart';
import '../../shared/widgets/stat_card.dart';
import '../../shared/widgets/toast.dart';
import '../accounts/account_form.dart';
import '../studio/organization_form.dart';
import '../studio/studio_screen.dart';
import 'artist_form.dart';
import 'music_providers.dart';

/// Music, Artist & Record Label: artist identities, labels and the streaming,
/// distribution and studio platforms behind them.
class MusicScreen extends ConsumerStatefulWidget {
  const MusicScreen({super.key});
  @override
  ConsumerState<MusicScreen> createState() => _MusicScreenState();
}

class _MusicScreenState extends ConsumerState<MusicScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabs = TabController(length: 3, vsync: this);
  String _q = '';

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  bool _isMusicPlatform(Platform p) => decodeStringList(p.categories).any(musicCategories.contains);

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final artists = ref.watch(artistsProvider).value ?? const <Artist>[];
    final orgs = ref.watch(organizationsProvider).value ?? const <Organization>[];
    final labels = orgs.where((o) => o.kind == OrganizationKind.recordLabel.name).toList();
    final accounts = (ref.watch(accountsProvider).value ?? const <AccountView>[]).where((a) => _isMusicPlatform(a.platform)).toList();
    final distribution = accounts.where((a) => decodeStringList(a.platform.categories).contains('music_distribution')).length;
    final streaming = accounts.where((a) => decodeStringList(a.platform.categories).any((x) => x == 'streaming' || x == 'artist')).length;
    return PageScaffold(
      title: 'Music, Artist & Label',
      subtitle: 'Artist identities, record labels, distributors and streaming profiles.',
      actions: [
        OutlinedButton.icon(onPressed: () => showOrganizationForm(context, ref, presetKind: OrganizationKind.recordLabel, lockKind: true), icon: const Icon(Icons.album_outlined, size: 18), label: const Text('Add label')),
        FilledButton.icon(onPressed: () => showArtistForm(context, ref), icon: const Icon(Icons.add, size: 18), label: const Text('Add artist')),
      ],
      children: [
        ResponsiveGrid(minTileWidth: 170, children: [
          StatCard(label: 'Artists', value: '${artists.length}', icon: Icons.mic_none, color: const Color(0xFF1DB954)),
          StatCard(label: 'Record labels', value: '${labels.length}', icon: Icons.album_outlined, color: c.accent),
          StatCard(label: 'Distribution accounts', value: '$distribution', icon: Icons.send_outlined, color: c.accentBlue),
          StatCard(label: 'Streaming / artist profiles', value: '$streaming', icon: Icons.graphic_eq, color: c.accentPink),
        ]),
        const SizedBox(height: 18),
        TabBar(controller: _tabs, isScrollable: true, tabAlignment: TabAlignment.start, tabs: const [Tab(text: 'Artists'), Tab(text: 'Labels'), Tab(text: 'Platforms')]),
        const SizedBox(height: 16),
        AnimatedBuilder(
          animation: _tabs,
          builder: (_, _) => switch (_tabs.index) {
            0 => _artistsTab(artists, labels),
            1 => _labelsTab(labels),
            _ => _platformsTab(accounts),
          },
        ),
      ],
    );
  }

  Widget _artistsTab(List<Artist> artists, List<Organization> labels) {
    final c = context.colors;
    final emails = ref.watch(emailsProvider).value ?? const <EmailIdentity>[];
    if (artists.isEmpty) {
      return AppCard(
        child: EmptyState(
          icon: Icons.mic_none,
          title: 'No artist identities yet',
          message: 'Add each artist name you release under. Attach it to a label, an email, YouTube channels and release projects.',
          actionLabel: 'Add artist',
          onAction: () => showArtistForm(context, ref),
        ),
      );
    }
    final repo = ref.read(projectRepositoryProvider);
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      for (final a in artists)
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: AppCard(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            onTap: () => context.push(Routes.artist(a.id)),
            child: Row(children: [
              MonogramAvatar(text: a.name, seed: a.id, size: 40, icon: Icons.mic_none),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(a.name, style: context.text.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(
                  [
                    if (a.genre != null) a.genre!,
                    labels.where((l) => l.id == a.labelId).firstOrNull?.name ?? 'Independent',
                    if (a.primaryEmailId != null) emails.where((e) => e.id == a.primaryEmailId).firstOrNull?.address ?? '',
                  ].where((s) => s.isNotEmpty).join(' · '),
                  style: context.text.bodySmall?.copyWith(color: c.textMuted),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ])),
              PopupMenuButton<String>(
                tooltip: 'Actions',
                onSelected: (v) async {
                  switch (v) {
                    case 'edit':
                      await showArtistForm(context, ref, existing: a);
                    case 'archive':
                      await repo.setArtistArchived(a.id, true);
                      if (mounted) showToast(context, 'Artist archived');
                    case 'delete':
                      if (await confirmDestructive(context, title: 'Delete artist?', message: 'Removes "${a.name}". Projects and channels are kept but detached.')) {
                        await repo.deleteArtist(a.id);
                      }
                  }
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'edit', child: ListTile(dense: true, leading: Icon(Icons.edit_outlined, size: 18), title: Text('Edit'))),
                  PopupMenuItem(value: 'archive', child: ListTile(dense: true, leading: Icon(Icons.archive_outlined, size: 18), title: Text('Archive'))),
                  PopupMenuItem(value: 'delete', child: ListTile(dense: true, leading: Icon(Icons.delete_outline, size: 18), title: Text('Delete'))),
                ],
              ),
            ]),
          ),
        ),
    ]);
  }

  Widget _labelsTab(List<Organization> labels) {
    if (labels.isEmpty) {
      return AppCard(
        child: EmptyState(
          icon: Icons.album_outlined,
          title: 'No record labels yet',
          message: 'Add your label identity (even a one-person label). Artists, releases, distributor accounts and bank accounts can attach to it.',
          actionLabel: 'Add label',
          onAction: () => showOrganizationForm(context, ref, presetKind: OrganizationKind.recordLabel, lockKind: true),
        ),
      );
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      for (final l in labels) Padding(padding: const EdgeInsets.only(bottom: 8), child: OrganizationTile(organization: l)),
    ]);
  }

  Widget _platformsTab(List<AccountView> accounts) {
    final c = context.colors;
    final all = ref.watch(allPlatformsProvider).value ?? const <Platform>[];
    final q = _q.trim().toLowerCase();
    final filtered = accounts.where((a) => q.isEmpty || a.platform.name.toLowerCase().contains(q) || a.account.accountName.toLowerCase().contains(q) || (a.email?.address.toLowerCase().contains(q) ?? false)).toList();
    final byPlatform = <String, List<AccountView>>{};
    for (final a in filtered) {
      byPlatform.putIfAbsent(a.platform.id, () => []).add(a);
    }
    final platformsInUse = {for (final a in filtered) a.platform.id: a.platform}.values.toList()..sort((x, y) => x.name.compareTo(y.name));
    final spotlight = all.where((p) => musicSpotlight.contains(p.id) && !p.inMyWorld).toList()..sort((x, y) => musicSpotlight.indexOf(x.id).compareTo(musicSpotlight.indexOf(y.id)));
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      SectionHeader(
        title: 'Your music platforms',
        subtitle: 'Streaming profiles, distributors, studio tools',
        actions: [
          SizedBox(width: 200, child: TextField(decoration: const InputDecoration(hintText: 'Filter…', prefixIcon: Icon(Icons.search, size: 16)), onChanged: (v) => setState(() => _q = v))),
          const SizedBox(width: 8),
          FilledButton.icon(
            onPressed: () async {
              final p = await showPlatformPicker(context, ref, category: 'artist', title: 'Add music account');
              if (p == null || !mounted) return;
              await showAccountForm(context, ref, platform: p);
            },
            icon: const Icon(Icons.add, size: 16),
            label: const Text('Add account'),
          ),
        ],
      ),
      if (accounts.isEmpty)
        AppCard(child: EmptyState(compact: true, icon: Icons.graphic_eq, title: 'No music platform accounts yet', message: 'Add your Spotify for Artists, distributor and studio accounts, or pick a suggestion below.'))
      else if (filtered.isEmpty)
        const EmptyState(compact: true, icon: Icons.filter_alt_off, title: 'No accounts match', message: 'Try another filter.')
      else
        for (final p in platformsInUse)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: AppCard(
              padding: const EdgeInsets.all(12),
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Row(children: [
                  PlatformLogo(platform: p, size: 36),
                  const SizedBox(width: 10),
                  Expanded(child: InkWell(onTap: () => context.push(Routes.platform(p.id)), child: Text(p.name, style: context.text.titleSmall))),
                  TextButton.icon(onPressed: () => showAccountForm(context, ref, platform: p), icon: const Icon(Icons.add, size: 16), label: const Text('Account')),
                ]),
                const SizedBox(height: 8),
                for (final a in byPlatform[p.id]!) Padding(padding: const EdgeInsets.only(top: 6), child: AccountTile(view: a, showPlatform: false, dense: true)),
              ]),
            ),
          ),
      if (spotlight.isNotEmpty) ...[
        const SizedBox(height: 10),
        const SectionHeader(title: 'Suggested platforms', subtitle: 'Tap Add to place one in My World. Nothing is added automatically.'),
        ResponsiveGrid(minTileWidth: 150, children: [
          for (final p in spotlight)
            AppCard(
              padding: const EdgeInsets.all(12),
              onTap: () => context.push(Routes.platform(p.id)),
              child: Column(children: [
                PlatformLogo(platform: p, size: 40),
                const SizedBox(height: 8),
                Text(p.name, style: context.text.labelLarge, maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center),
                const SizedBox(height: 6),
                FilledButton.tonal(
                  style: FilledButton.styleFrom(visualDensity: VisualDensity.compact),
                  onPressed: () async {
                    await ref.read(platformRepositoryProvider).setInMyWorld(p.id, true);
                    if (mounted) showToast(context, '${p.name} added to My World');
                  },
                  child: const Text('Add'),
                ),
              ]),
            ),
        ]),
      ],
      const SizedBox(height: 12),
      Text('Royalty collection (ASCAP, BMI, IPRS, SoundExchange) and lyric services are in the catalog too: search Explore.', style: context.text.bodySmall?.copyWith(color: c.textMuted)),
    ]);
  }
}
