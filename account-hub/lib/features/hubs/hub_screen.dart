import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/routes.dart';
import '../../app/theme/app_theme.dart';
import '../../core/json_list.dart';
import '../../data/db/app_database.dart';
import '../../data/repositories/account_repository.dart';
import '../../data/repositories/subscription_repository.dart';
import '../../shared/widgets/account_tile.dart';
import '../../shared/widgets/app_card.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/page_scaffold.dart';
import '../../shared/widgets/pickers.dart';
import '../../shared/widgets/platform_logo.dart';
import '../../shared/widgets/section_header.dart';
import '../../shared/widgets/stat_card.dart';
import '../../shared/widgets/toast.dart';
import '../accounts/account_form.dart';
import 'hub_configs.dart';

/// Generic hub for a category (AI, Social, Gaming…), an ecosystem (Google,
/// Apple, Microsoft) or a classification (Personal, Business). Shows the
/// user's platforms and accounts in scope and suggests catalog entries when
/// empty. Suggestions are never auto-added.
class HubScreen extends ConsumerStatefulWidget {
  const HubScreen({super.key, required this.config});
  final HubConfig config;
  @override
  ConsumerState<HubScreen> createState() => _HubScreenState();
}

class _HubScreenState extends ConsumerState<HubScreen> {
  String _q = '';

  bool _inScope(Platform p) {
    final cfg = widget.config;
    if (cfg.vendor != null) return p.vendor == cfg.vendor;
    if (cfg.categories.isNotEmpty) return cfg.matchesCategory(decodeStringList(p.categories));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final cfg = widget.config;
    final c = context.colors;
    final allPlatforms = ref.watch(allPlatformsProvider).value ?? const <Platform>[];
    final accountsAll = ref.watch(accountsProvider).value ?? const <AccountView>[];
    final subsAll = ref.watch(subscriptionsProvider).value ?? const <SubscriptionView>[];
    final emailsAll = ref.watch(emailsProvider).value ?? const <EmailIdentity>[];
    final projectsAll = ref.watch(projectsProvider).value ?? const <Project>[];
    final channels = ref.watch(channelsProvider).value ?? const [];

    final accounts = accountsAll.where((a) {
      if (cfg.classification != null) return a.account.classification == cfg.classification!.name;
      return _inScope(a.platform);
    }).where((a) => _q.isEmpty || a.platform.name.toLowerCase().contains(_q.toLowerCase()) || a.account.accountName.toLowerCase().contains(_q.toLowerCase()) || (a.email?.address.toLowerCase().contains(_q.toLowerCase()) ?? false)).toList();

    final myPlatforms = allPlatforms.where((p) => p.inMyWorld && (cfg.classification == null ? _inScope(p) : accounts.any((a) => a.platform.id == p.id))).toList();
    final subs = subsAll.where((s) => cfg.classification != null ? s.sub.classification == cfg.classification!.name : (s.platform != null && _inScope(s.platform!))).toList();
    final emails = cfg.classification == null ? const <EmailIdentity>[] : emailsAll.where((e) => e.classification == cfg.classification!.name).toList();
    final projects = cfg.classification == null ? const <Project>[] : projectsAll.where((p) => p.classification == cfg.classification!.name).toList();
    final spotlight = allPlatforms.where((p) => cfg.spotlight.contains(p.id) && !p.inMyWorld).toList()..sort((a, b) => cfg.spotlight.indexOf(a.id).compareTo(cfg.spotlight.indexOf(b.id)));
    final byPlatform = <String, List<AccountView>>{};
    for (final a in accounts) {
      byPlatform.putIfAbsent(a.platform.id, () => []).add(a);
    }
    final exploreCategory = cfg.categories.isEmpty ? null : cfg.categories.first;

    return PageScaffold(
      title: cfg.title,
      subtitle: cfg.subtitle,
      actions: [
        if (cfg.vendor != null || cfg.categories.isNotEmpty)
          OutlinedButton.icon(onPressed: () => context.go(exploreCategory == null ? Routes.explore : '${Routes.explore}?category=$exploreCategory'), icon: const Icon(Icons.explore_outlined, size: 18), label: const Text('Browse catalog')),
        FilledButton.icon(
          onPressed: () async {
            Platform? p;
            if (cfg.classification == null) {
              p = await showPlatformPicker(context, ref, category: exploreCategory, title: 'Add ${cfg.title} account');
              if (p == null) return;
            }
            if (!context.mounted) return;
            await showAccountForm(context, ref, platform: p, presetClassification: cfg.classification);
          },
          icon: const Icon(Icons.add, size: 18),
          label: const Text('Add account'),
        ),
      ],
      children: [
        ResponsiveGrid(minTileWidth: 170, children: [
          StatCard(label: 'Platforms', value: '${myPlatforms.length}', icon: Icons.apps, color: cfg.color),
          StatCard(label: 'Accounts', value: '${accounts.length}', icon: Icons.people_outline, color: c.accentBlue),
          StatCard(label: 'Subscriptions', value: '${subs.length}', icon: Icons.autorenew, color: c.success, onTap: () => context.go(Routes.subscriptions)),
          if (cfg.vendor == 'google') StatCard(label: 'YouTube channels', value: '${channels.length}', icon: Icons.play_circle_outline, color: const Color(0xFFFF0033), onTap: () => context.go(Routes.youtube)),
          if (cfg.classification != null) StatCard(label: 'Email identities', value: '${emails.length}', icon: Icons.alternate_email, color: c.accentPink, onTap: () => context.go('${Routes.accounts}?tab=emails')),
          if (cfg.classification != null) StatCard(label: 'Projects', value: '${projects.length}', icon: Icons.folder_outlined, color: c.warning, onTap: () => context.go(Routes.studio)),
        ]),
        const SizedBox(height: 22),
        if (accounts.isEmpty && myPlatforms.isEmpty)
          AppCard(
            child: EmptyState(
              compact: true,
              icon: cfg.icon,
              title: 'Nothing in ${cfg.title} yet',
              message: cfg.classification != null ? 'Mark accounts, emails, subscriptions and projects as ${cfg.classification!.label.toLowerCase()} and they show up here.' : 'Add the platforms you use below, or browse the catalog.',
            ),
          ),
        if (spotlight.isNotEmpty && cfg.classification == null) ...[
          SectionHeader(title: 'Suggested platforms', subtitle: 'Tap Add to place one in My World. Nothing is added automatically.'),
          ResponsiveGrid(minTileWidth: 150, children: [
            for (final p in spotlight.take(12))
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
                      if (context.mounted) showToast(context, '${p.name} added to My World');
                    },
                    child: const Text('Add'),
                  ),
                ]),
              ),
          ]),
          const SizedBox(height: 22),
        ],
        if (myPlatforms.isNotEmpty || accounts.isNotEmpty) ...[
          SectionHeader(
            title: 'Your platforms & accounts',
            actions: [
              SizedBox(width: 220, child: TextField(decoration: const InputDecoration(hintText: 'Filter…', prefixIcon: Icon(Icons.search, size: 16)), onChanged: (v) => setState(() => _q = v))),
            ],
          ),
          for (final p in myPlatforms.where((p) => _q.isEmpty || p.name.toLowerCase().contains(_q.toLowerCase()) || (byPlatform[p.id]?.isNotEmpty ?? false)))
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: AppCard(
                padding: const EdgeInsets.all(12),
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  Row(children: [
                    PlatformLogo(platform: p, size: 36),
                    const SizedBox(width: 10),
                    Expanded(child: InkWell(onTap: () => context.push(Routes.platform(p.id)), child: Text(p.name, style: context.text.titleSmall))),
                    TextButton.icon(onPressed: () => showAccountForm(context, ref, platform: p, presetClassification: cfg.classification), icon: const Icon(Icons.add, size: 16), label: const Text('Account')),
                  ]),
                  if ((byPlatform[p.id] ?? const []).isNotEmpty) ...[
                    const SizedBox(height: 8),
                    for (final a in byPlatform[p.id]!) Padding(padding: const EdgeInsets.only(top: 6), child: AccountTile(view: a, showPlatform: false, dense: true)),
                  ] else
                    Padding(padding: const EdgeInsets.only(top: 6, left: 4), child: Text('No accounts added yet', style: context.text.bodySmall?.copyWith(color: c.textMuted))),
                ]),
              ),
            ),
          // Accounts whose platform is not (any more) in the My World grid.
          for (final a in accounts.where((a) => !myPlatforms.any((p) => p.id == a.platform.id))) Padding(padding: const EdgeInsets.only(bottom: 8), child: AccountTile(view: a)),
        ],
        if (cfg.classification != null && (emails.isNotEmpty || subs.isNotEmpty || projects.isNotEmpty)) ...[
          const SizedBox(height: 10),
          if (emails.isNotEmpty) ...[
            SectionHeader(title: '${cfg.classification!.label} emails', onViewAll: () => context.go('${Routes.accounts}?tab=emails')),
            Wrap(spacing: 8, runSpacing: 8, children: [for (final e in emails) ActionChip(avatar: const Icon(Icons.alternate_email, size: 14), label: Text(e.address), onPressed: () => context.push(Routes.email(e.id)))]),
            const SizedBox(height: 18),
          ],
          if (subs.isNotEmpty) ...[
            SectionHeader(title: '${cfg.classification!.label} subscriptions', onViewAll: () => context.go(Routes.subscriptions)),
            AppCard(padding: const EdgeInsets.symmetric(vertical: 4), child: Column(children: [for (final s in subs) ListTile(title: Text(s.sub.serviceName), subtitle: Text('${s.price.format()} · ${s.cycle.label}'), trailing: const Icon(Icons.chevron_right), onTap: () => context.push(Routes.subscription(s.sub.id)))])),
            const SizedBox(height: 18),
          ],
          if (projects.isNotEmpty) ...[
            SectionHeader(title: '${cfg.classification!.label} projects', onViewAll: () => context.go(Routes.studio)),
            Wrap(spacing: 8, runSpacing: 8, children: [for (final p in projects) ActionChip(avatar: const Icon(Icons.folder_outlined, size: 14), label: Text(p.name), onPressed: () => context.push(Routes.project(p.id)))]),
          ],
        ],
        if (cfg.tips.isNotEmpty) ...[
          const SizedBox(height: 20),
          for (final t in cfg.tips) Padding(padding: const EdgeInsets.only(bottom: 4), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(Icons.lightbulb_outline, size: 14, color: c.textMuted), const SizedBox(width: 6), Expanded(child: Text(t, style: context.text.bodySmall?.copyWith(color: c.textMuted)))])),
        ],
      ],
    );
  }
}
