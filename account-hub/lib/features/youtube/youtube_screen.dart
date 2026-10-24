import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/routes.dart';
import '../../app/theme/app_theme.dart';
import '../../core/launch.dart';
import '../../data/db/app_database.dart';
import '../../data/repositories/youtube_repository.dart';
import '../../domain/enums.dart';
import '../../shared/widgets/app_card.dart';
import '../../shared/widgets/confirm_dialog.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/page_scaffold.dart';
import '../../shared/widgets/pickers.dart';
import '../../shared/widgets/platform_logo.dart';
import '../../shared/widgets/stat_card.dart';
import '../../shared/widgets/status_chip.dart';
import '../../shared/widgets/toast.dart';
import 'channel_form.dart';
import 'youtube_providers.dart';

const _ytRed = Color(0xFFFF0033);

/// YouTube channels grouped by owning Google identity, with managers.
class YoutubeScreen extends ConsumerStatefulWidget {
  const YoutubeScreen({super.key});
  @override
  ConsumerState<YoutubeScreen> createState() => _YoutubeScreenState();
}

class _YoutubeScreenState extends ConsumerState<YoutubeScreen> {
  String _q = '';
  String? _status;
  String? _ownerFilter; // email id, or '' for no owner
  bool _showArchived = false;
  bool _handledNew = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_handledNew || !mounted) return;
      _handledNew = true;
      try {
        if (GoRouterState.of(context).uri.queryParameters['new'] == '1') showChannelForm(context, ref);
      } catch (_) {
        // Not under a router (e.g. widget tests): nothing to do.
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final all = (_showArchived ? ref.watch(allChannelsProvider) : ref.watch(channelsProvider)).value ?? const <ChannelView>[];
    final artists = ref.watch(artistsProvider).value ?? const <Artist>[];
    final orgs = ref.watch(organizationsProvider).value ?? const <Organization>[];
    final emails = ref.watch(emailsProvider).value ?? const <EmailIdentity>[];
    final q = _q.trim().toLowerCase();
    final filtered = all.where((v) {
      if (_status != null && v.channel.status != _status) return false;
      if (_ownerFilter != null && (v.owner?.id ?? '') != _ownerFilter) return false;
      if (q.isEmpty) return true;
      return v.channel.name.toLowerCase().contains(q) ||
          (v.channel.handle ?? '').toLowerCase().contains(q) ||
          (v.channel.purpose ?? '').toLowerCase().contains(q) ||
          (v.owner?.address.toLowerCase().contains(q) ?? false);
    }).toList();
    final grouped = YoutubeRepository.groupByOwner(filtered);
    final ownerIds = all.map((v) => v.owner?.id).whereType<String>().toSet();
    final noOwner = all.where((v) => v.owner == null).length;
    final ownersInData = emails.where((e) => ownerIds.contains(e.id)).toList();

    return PageScaffold(
      title: 'YouTube',
      subtitle: 'Channels, their owning Google accounts and who else manages them.',
      actions: [
        OutlinedButton.icon(onPressed: () => showQuickEmailDialog(context, ref), icon: const Icon(Icons.alternate_email, size: 18), label: const Text('Add Google identity')),
        FilledButton.icon(onPressed: () => showChannelForm(context, ref), icon: const Icon(Icons.add, size: 18), label: const Text('Add channel')),
      ],
      children: [
        ResponsiveGrid(minTileWidth: 170, children: [
          StatCard(label: 'Channels', value: '${all.where((v) => v.channel.archivedAt == null).length}', icon: Icons.play_circle_outline, color: _ytRed),
          StatCard(label: 'Google identities owning channels', value: '${ownerIds.length}', icon: Icons.account_circle_outlined, color: c.accentBlue, onTap: () => context.go('${Routes.accounts}?tab=emails')),
          StatCard(label: 'Channels without owner', value: '$noOwner', icon: Icons.help_outline, color: noOwner > 0 ? c.warning : c.success),
          StatCard(label: 'Manager links', value: '${all.fold<int>(0, (n, v) => n + v.managers.length)}', icon: Icons.group_outlined, color: c.accent),
        ]),
        const SizedBox(height: 20),
        if (all.isEmpty)
          AppCard(
            child: EmptyState(
              icon: Icons.play_circle_outline,
              title: 'No YouTube channels yet',
              message: 'One Google account can own several channels (main, gaming, music…), and a channel can be managed by several identities. Add the Google identity first, then its channels.',
              actionLabel: 'Add channel',
              onAction: () => showChannelForm(context, ref),
              secondaryLabel: 'Add Google identity',
              onSecondary: () => showQuickEmailDialog(context, ref),
            ),
          )
        else ...[
          Wrap(spacing: 8, runSpacing: 8, crossAxisAlignment: WrapCrossAlignment.center, children: [
            SizedBox(width: 260, child: TextField(decoration: const InputDecoration(hintText: 'Search channels…', prefixIcon: Icon(Icons.search, size: 18)), onChanged: (v) => setState(() => _q = v))),
            SizedBox(
              width: 170,
              child: DropdownButtonFormField<String?>(
                initialValue: _status,
                decoration: const InputDecoration(labelText: 'Status'),
                dropdownColor: c.surfaceAlt,
                isExpanded: true,
                items: [const DropdownMenuItem(value: null, child: Text('Any status')), for (final s in AccountStatus.values) DropdownMenuItem(value: s.name, child: Text(s.label, overflow: TextOverflow.ellipsis))],
                onChanged: (v) => setState(() => _status = v),
              ),
            ),
            SizedBox(
              width: 240,
              child: DropdownButtonFormField<String?>(
                initialValue: _ownerFilter,
                decoration: const InputDecoration(labelText: 'Owner'),
                dropdownColor: c.surfaceAlt,
                isExpanded: true,
                items: [
                  const DropdownMenuItem(value: null, child: Text('Any owner')),
                  for (final e in ownersInData) DropdownMenuItem(value: e.id, child: Text(e.address, overflow: TextOverflow.ellipsis)),
                  if (noOwner > 0) const DropdownMenuItem(value: '', child: Text('No owner set')),
                ],
                onChanged: (v) => setState(() => _ownerFilter = v),
              ),
            ),
            FilterChip(label: const Text('Show archived'), selected: _showArchived, onSelected: (v) => setState(() => _showArchived = v)),
          ]),
          const SizedBox(height: 18),
          if (filtered.isEmpty)
            const EmptyState(compact: true, icon: Icons.filter_alt_off, title: 'No channels match', message: 'Try another search or clear the filters.')
          else
            for (final entry in grouped.entries) _OwnerGroup(owner: entry.key, channels: entry.value, artists: artists, orgs: orgs),
        ],
      ],
    );
  }
}

class _OwnerGroup extends ConsumerWidget {
  const _OwnerGroup({required this.owner, required this.channels, required this.artists, required this.orgs});
  final EmailIdentity? owner;
  final List<ChannelView> channels;
  final List<Artist> artists;
  final List<Organization> orgs;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: owner == null ? null : () => context.push(Routes.email(owner!.id)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
            child: Row(children: [
              owner == null
                  ? MonogramAvatar(text: '?', seed: 'no-owner', size: 36, icon: Icons.help_outline)
                  : MonogramAvatar(text: owner!.address, seed: owner!.id, size: 36, icon: Icons.account_circle_outlined),
              const SizedBox(width: 10),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(owner?.address ?? 'No owner set', style: context.text.titleSmall),
                Text('${channels.length} channel${channels.length == 1 ? '' : 's'}${owner?.displayName != null ? ' · ${owner!.displayName}' : ''}', style: context.text.bodySmall?.copyWith(color: c.textMuted)),
              ])),
              if (owner != null)
                TextButton.icon(onPressed: () => showChannelForm(context, ref, presetOwnerEmailId: owner!.id), icon: const Icon(Icons.add, size: 16), label: const Text('Channel')),
            ]),
          ),
        ),
        const SizedBox(height: 6),
        for (final v in channels) Padding(padding: const EdgeInsets.only(bottom: 8), child: ChannelTile(view: v, artists: artists, orgs: orgs)),
      ]),
    );
  }
}

class ChannelTile extends ConsumerWidget {
  const ChannelTile({super.key, required this.view, required this.artists, required this.orgs});
  final ChannelView view;
  final List<Artist> artists;
  final List<Organization> orgs;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final ch = view.channel;
    final artist = artists.where((a) => a.id == ch.artistId).firstOrNull;
    final org = orgs.where((o) => o.id == ch.organizationId).firstOrNull;
    final repo = ref.read(youtubeRepositoryProvider);
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      onTap: () => context.push(Routes.channel(ch.id)),
      child: Row(children: [
        MonogramAvatar(text: ch.name, seed: ch.id, size: 40, icon: Icons.play_arrow_rounded),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Flexible(child: Text(ch.name, style: context.text.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis)),
              if (ch.archivedAt != null) const Padding(padding: EdgeInsets.only(left: 6), child: StatusChip('Archived')),
            ]),
            const SizedBox(height: 2),
            Text(
              [if (ch.handle != null) ch.handle!, if (artist != null) artist.name, if (org != null) org.name, if (ch.purpose != null) ch.purpose!].join(' · '),
              style: context.text.bodySmall?.copyWith(color: c.textMuted),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ]),
        ),
        const SizedBox(width: 8),
        if (view.managers.isNotEmpty)
          Tooltip(
            message: view.managers.map((m) => '${m.$1.address} (${m.$2.label})').join('\n'),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              for (final m in view.managers.take(3)) Padding(padding: const EdgeInsets.only(right: 2), child: MonogramAvatar(text: m.$1.address, seed: m.$1.id, size: 22)),
              const SizedBox(width: 4),
              Text('${view.managers.length}', style: context.text.labelSmall?.copyWith(color: c.textMuted)),
              const SizedBox(width: 8),
            ]),
          ),
        if (!context.isCompact) ...[
          if (ch.channelType != null) ...[StatusChip(ch.channelType!, color: _ytRed), const SizedBox(width: 6)],
          StatusChip(statusLabel(ch.status), color: statusColor(context, ch.status)),
        ],
        PopupMenuButton<String>(
          tooltip: 'Actions',
          onSelected: (v) async {
            switch (v) {
              case 'open':
                await openUrl(context, channelLink(ch));
              case 'edit':
                await showChannelForm(context, ref, existing: view);
              case 'archive':
                await repo.setArchived(ch.id, true);
                if (context.mounted) showToast(context, 'Channel archived');
              case 'restore':
                await repo.setArchived(ch.id, false);
              case 'delete':
                if (await confirmDestructive(context, title: 'Delete channel?', message: 'This permanently removes "${ch.name}" and its manager links from the hub. Nothing changes on YouTube itself.')) {
                  await repo.delete(ch.id);
                }
            }
          },
          itemBuilder: (_) => [
            const PopupMenuItem(value: 'open', child: ListTile(dense: true, leading: Icon(Icons.open_in_new, size: 18), title: Text('Open channel'))),
            const PopupMenuItem(value: 'edit', child: ListTile(dense: true, leading: Icon(Icons.edit_outlined, size: 18), title: Text('Edit'))),
            if (ch.archivedAt == null)
              const PopupMenuItem(value: 'archive', child: ListTile(dense: true, leading: Icon(Icons.archive_outlined, size: 18), title: Text('Archive')))
            else
              const PopupMenuItem(value: 'restore', child: ListTile(dense: true, leading: Icon(Icons.unarchive_outlined, size: 18), title: Text('Restore'))),
            const PopupMenuItem(value: 'delete', child: ListTile(dense: true, leading: Icon(Icons.delete_outline, size: 18), title: Text('Delete'))),
          ],
        ),
      ]),
    );
  }
}
