import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../app/providers.dart';
import '../../app/routes.dart';
import '../../app/theme/app_theme.dart';
import '../../data/db/app_database.dart';
import '../../data/repositories/account_repository.dart';
import '../../data/repositories/settings_repository.dart';
import '../../data/repositories/stats_repository.dart';
import '../../data/repositories/subscription_repository.dart';
import '../../domain/subscription_math.dart';
import '../../shared/widgets/account_tile.dart';
import '../../shared/widgets/app_card.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/form_sheet.dart';
import '../../shared/widgets/page_scaffold.dart';
import '../../shared/widgets/pickers.dart';
import '../../shared/widgets/platform_logo.dart';
import '../../shared/widgets/section_header.dart';
import '../../shared/widgets/stat_card.dart';
import '../../shared/widgets/toast.dart';
import '../accounts/account_form.dart';

/// Customisable dashboard. Every number comes from local data; an empty
/// database shows zeros and friendly empty states, never sample data.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider).value ?? const <String, dynamic>{};
    final stats = ref.watch(statsProvider).value ?? DashboardStats.empty;
    final order = settings.dashboardOrder;
    final hidden = settings.dashboardHidden;
    final sections = <Widget>[];
    for (final s in order) {
      if (hidden.contains(s)) continue;
      sections.add(switch (s) {
        DashboardSection.welcome => _Welcome(name: settings.displayName),
        DashboardSection.stats => _Stats(stats: stats),
        DashboardSection.myWorld => const _MyWorldStrip(),
        DashboardSection.upcoming => const _Upcoming(),
        DashboardSection.recent => const _Recent(),
        DashboardSection.favorites => const _Favorites(),
        DashboardSection.security => _Security(stats: stats),
        DashboardSection.quickActions => const _QuickActions(),
      });
      sections.add(const SizedBox(height: 22));
    }
    return PageScaffold(
      title: 'Home',
      header: const SizedBox.shrink(),
      actions: const [],
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(onPressed: () => _customize(context, ref, order, hidden), icon: const Icon(Icons.tune, size: 16), label: const Text('Customize dashboard')),
        ),
        const SizedBox(height: 6),
        ...sections,
      ],
    );
  }

  Future<void> _customize(BuildContext context, WidgetRef ref, List<DashboardSection> order, Set<DashboardSection> hidden) async {
    var items = List.of(order);
    var hiddenSet = {...hidden};
    await showFormSheet<void>(context, title: 'Customize dashboard', maxWidth: 480, builder: (ctx, close) {
      return StatefulBuilder(builder: (ctx, setState) {
        return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text('Drag to reorder, toggle to hide.', style: ctx.text.bodySmall?.copyWith(color: ctx.colors.textMuted)),
          const SizedBox(height: 8),
          SizedBox(
            height: 380,
            child: ReorderableListView(
              buildDefaultDragHandles: true,
              onReorderItem: (o, n) => setState(() => items.insert(n, items.removeAt(o))),
              children: [
                for (final s in items)
                  SwitchListTile(
                    key: ValueKey(s),
                    title: Text(s.label),
                    secondary: const Icon(Icons.drag_indicator),
                    value: !hiddenSet.contains(s),
                    onChanged: (v) => setState(() => v ? hiddenSet.remove(s) : hiddenSet.add(s)),
                  ),
              ],
            ),
          ),
          FormActions(
            onCancel: close,
            destructiveLabel: 'Reset',
            onDestructive: () async {
              final repo = ref.read(settingsRepositoryProvider);
              await repo.remove(SettingsRepository.kDashboardOrder);
              await repo.remove(SettingsRepository.kDashboardHidden);
              close();
            },
            onSave: () async {
              final repo = ref.read(settingsRepositoryProvider);
              await repo.set(SettingsRepository.kDashboardOrder, items.map((e) => e.name).toList());
              await repo.set(SettingsRepository.kDashboardHidden, hiddenSet.map((e) => e.name).toList());
              close();
            },
          ),
        ]);
      });
    });
  }
}

class _Welcome extends StatelessWidget {
  const _Welcome({this.name});
  final String? name;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final now = DateTime.now();
    final hour = now.hour;
    final greeting = hour < 5 ? 'Good night' : hour < 12 ? 'Good morning' : hour < 17 ? 'Good afternoon' : 'Good evening';
    final who = (name == null || name!.trim().isEmpty) ? '' : ', ${name!.trim()}';
    return Container(
      padding: EdgeInsets.all(context.isCompact ? 20 : 28),
      decoration: BoxDecoration(gradient: c.heroGradient, borderRadius: BorderRadius.circular(AppTheme.radius + 4)),
      child: Row(children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('$greeting$who', style: context.text.titleMedium?.copyWith(color: Colors.white.withValues(alpha: 0.85))),
          const SizedBox(height: 4),
          Text('SYHU Account Hub', style: context.text.headlineMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          Text('Your digital world, organized. Local-first and private.', style: context.text.bodyMedium?.copyWith(color: Colors.white.withValues(alpha: 0.8))),
        ])),
        if (!context.isCompact)
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(DateFormat('EEE, d MMM yyyy').format(now), style: context.text.bodyMedium?.copyWith(color: Colors.white.withValues(alpha: 0.85))),
            Text(DateFormat('h:mm a').format(now), style: context.text.headlineSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
          ]),
      ]),
    );
  }
}

class _Stats extends StatelessWidget {
  const _Stats({required this.stats});
  final DashboardStats stats;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final monthly = stats.monthlyCost;
    final annual = stats.annualCost;
    return ResponsiveGrid(minTileWidth: 180, children: [
      StatCard(label: 'Email identities', value: '${stats.emailCount}', icon: Icons.alternate_email, color: c.accentBlue, onTap: () => context.go('${Routes.accounts}?tab=emails')),
      StatCard(label: 'Services in My World', value: '${stats.platformCount}', icon: Icons.public, color: c.accent, onTap: () => context.go(Routes.myWorld)),
      StatCard(label: 'Accounts & profiles', value: '${stats.accountCount}', icon: Icons.people_outline, color: c.accentPink, onTap: () => context.go(Routes.accounts)),
      StatCard(label: 'YouTube channels', value: '${stats.channelCount}', icon: Icons.play_circle_outline, color: const Color(0xFFFF0033), onTap: () => context.go(Routes.youtube)),
      StatCard(label: 'Active subscriptions', value: '${stats.activeSubscriptions}', icon: Icons.autorenew, color: c.success, caption: stats.pausedSubscriptions > 0 ? '${stats.pausedSubscriptions} paused' : null, onTap: () => context.go(Routes.subscriptions)),
      StatCard(label: 'Upcoming renewals', value: '${stats.upcomingRenewals}', icon: Icons.event_repeat, color: c.warning, caption: 'next 30 days', onTap: () => context.go(Routes.subscriptions)),
      StatCard(label: 'Monthly cost', value: monthly == null || monthly.isEmpty ? '—' : monthly.format(compact: monthly.isMixed), icon: Icons.calendar_month, color: const Color(0xFFF97316), caption: monthly != null && monthly.isMixed ? 'separate per currency' : null, onTap: () => context.go(Routes.subscriptions)),
      StatCard(label: 'Annual cost', value: annual == null || annual.isEmpty ? '—' : annual.format(compact: annual.isMixed), icon: Icons.calendar_today, color: const Color(0xFF14B8A6), onTap: () => context.go(Routes.subscriptions)),
    ]);
  }
}

class _MyWorldStrip extends ConsumerWidget {
  const _MyWorldStrip();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final platforms = ref.watch(myWorldProvider).value ?? const <Platform>[];
    final accounts = ref.watch(accountsProvider).value ?? const <AccountView>[];
    final counts = <String, int>{};
    for (final a in accounts) {
      counts[a.platform.id] = (counts[a.platform.id] ?? 0) + 1;
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      SectionHeader(title: 'My World', subtitle: platforms.isEmpty ? null : '${platforms.length} platforms you chose', onViewAll: () => context.go(Routes.myWorld)),
      if (platforms.isEmpty)
        AppCard(child: EmptyState(compact: true, icon: Icons.public, title: 'My World is empty', message: 'Add the platforms you use from Explore. Only what you pick shows up here.', actionLabel: 'Open Explore', onAction: () => context.go(Routes.explore)))
      else
        ResponsiveGrid(minTileWidth: 120, children: [
          for (final p in platforms.take(16))
            AppCard(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
              onTap: () => context.push(Routes.platform(p.id)),
              child: Column(children: [
                PlatformLogo(platform: p, size: 44),
                const SizedBox(height: 8),
                Text(p.name, style: context.text.bodySmall?.copyWith(fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center),
                Text('${counts[p.id] ?? 0} account${(counts[p.id] ?? 0) == 1 ? '' : 's'}', style: context.text.labelSmall?.copyWith(color: context.colors.textMuted)),
              ]),
            ),
        ]),
    ]);
  }
}

class _Upcoming extends ConsumerWidget {
  const _Upcoming();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final subs = ref.watch(subscriptionsProvider).value ?? const <SubscriptionView>[];
    final upcomingIds = SubscriptionMath.upcoming(subs.map((s) => s.like), now: DateTime.now(), days: 30).map((s) => s.id).toList();
    final upcoming = [for (final id in upcomingIds) subs.firstWhere((s) => s.sub.id == id)];
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      SectionHeader(title: 'Upcoming renewals', subtitle: 'Next 30 days', onViewAll: () => context.go(Routes.subscriptions)),
      if (upcoming.isEmpty)
        AppCard(child: Row(children: [Icon(Icons.event_available, color: c.success), const SizedBox(width: 12), Expanded(child: Text(subs.isEmpty ? 'No subscriptions tracked yet. Add them under Subscriptions to get renewal reminders.' : 'Nothing renews in the next 30 days.', style: TextStyle(color: c.textMuted)))]))
      else
        AppCard(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(children: [
            for (final s in upcoming.take(6))
              ListTile(
                leading: s.platform == null ? MonogramAvatar(text: s.sub.serviceName, seed: s.sub.id, size: 36) : PlatformLogo(platform: s.platform!, size: 36),
                title: Text(s.sub.serviceName),
                subtitle: Text(s.sub.plan ?? s.cycle.label),
                trailing: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Text(s.price.format(), style: context.text.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
                  Text(_relative(s.sub.nextBillingDate!), style: context.text.bodySmall?.copyWith(color: c.warning)),
                ]),
                onTap: () => context.push(Routes.subscription(s.sub.id)),
              ),
          ]),
        ),
    ]);
  }

  static String _relative(DateTime d) {
    final today = DateTime.now();
    final days = DateTime(d.year, d.month, d.day).difference(DateTime(today.year, today.month, today.day)).inDays;
    if (days <= 0) return 'today';
    if (days == 1) return 'tomorrow';
    return 'in $days days';
  }
}

class _Recent extends ConsumerWidget {
  const _Recent();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recent = ref.watch(recentAccountsProvider).value ?? const <AccountView>[];
    if (recent.isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      SectionHeader(title: 'Recently accessed', onViewAll: () => context.go(Routes.accounts)),
      ResponsiveGrid(minTileWidth: 300, children: [for (final a in recent.take(6)) AccountTile(view: a, dense: true)]),
    ]);
  }
}

class _Favorites extends ConsumerWidget {
  const _Favorites();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final all = ref.watch(allPlatformsProvider).value ?? const <Platform>[];
    final favs = all.where((p) => p.isFavorite).toList();
    if (favs.isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      const SectionHeader(title: 'Favorite platforms'),
      SizedBox(
        height: 96,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: favs.length,
          separatorBuilder: (_, _) => const SizedBox(width: 10),
          itemBuilder: (_, i) => SizedBox(
            width: 110,
            child: AppCard(
              padding: const EdgeInsets.all(10),
              onTap: () => context.push(Routes.platform(favs[i].id)),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [PlatformLogo(platform: favs[i], size: 38), const SizedBox(height: 6), Text(favs[i].name, style: context.text.labelMedium, maxLines: 1, overflow: TextOverflow.ellipsis)]),
            ),
          ),
        ),
      ),
    ]);
  }
}

class _Security extends ConsumerWidget {
  const _Security({required this.stats});
  final DashboardStats stats;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final lock = ref.watch(appLockProvider);
    final settings = ref.watch(settingsProvider).value ?? const <String, dynamic>{};
    final lastBackup = settings[SettingsRepository.kLastBackupAt] as String?;
    final checks = <(bool, String, String, String)>[
      (lock.enabled, 'App Lock', lock.enabled ? 'Enabled' : 'Off: enable in Settings → Security', 'security'),
      (lastBackup != null, 'Backup', lastBackup != null ? 'Last backup ${DateFormat.yMMMd().format(DateTime.parse(lastBackup))}' : 'No backup yet', 'backup'),
      (true, 'Vault', '${stats.vaultItems} encrypted item${stats.vaultItems == 1 ? '' : 's'}', 'vault'),
    ];
    final score = checks.where((c) => c.$1).length;
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      const SectionHeader(title: 'Security overview'),
      AppCard(
        child: Row(children: [
          SizedBox(
            width: 72, height: 72,
            child: Stack(fit: StackFit.expand, children: [
              CircularProgressIndicator(value: score / checks.length, strokeWidth: 7, backgroundColor: c.surfaceAlt, color: score == checks.length ? c.success : c.warning),
              Center(child: Text('$score/${checks.length}', style: context.text.titleMedium)),
            ]),
          ),
          const SizedBox(width: 20),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            for (final ch in checks)
              InkWell(
                onTap: () => context.go(ch.$4 == 'vault' ? Routes.vault : '${Routes.settings}?section=${ch.$4}'),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Row(children: [
                    Icon(ch.$1 ? Icons.check_circle : Icons.radio_button_unchecked, size: 16, color: ch.$1 ? c.success : c.textMuted),
                    const SizedBox(width: 8),
                    Text(ch.$2, style: context.text.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(width: 8),
                    Expanded(child: Text(ch.$3, style: context.text.bodySmall?.copyWith(color: c.textMuted), maxLines: 1, overflow: TextOverflow.ellipsis)),
                  ]),
                ),
              ),
          ])),
        ]),
      ),
    ]);
  }
}

class _QuickActions extends ConsumerWidget {
  const _QuickActions();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actions = <(IconData, String, Future<void> Function())>[
      (Icons.person_add_alt, 'Add account', () => showAccountForm(context, ref)),
      (Icons.alternate_email, 'Add email identity', () async { await showQuickEmailDialog(context, ref); }),
      (Icons.add_box_outlined, 'Add platform', () async {
        final p = await showPlatformPicker(context, ref);
        if (p != null) {
          await ref.read(platformRepositoryProvider).setInMyWorld(p.id, true);
          if (context.mounted) showToast(context, '${p.name} added to My World');
        }
      }),
      (Icons.autorenew, 'Add subscription', () async => context.go('${Routes.subscriptions}?new=1')),
      (Icons.play_circle_outline, 'Add YouTube channel', () async => context.go('${Routes.youtube}?new=1')),
      (Icons.lock_outline, 'Open Vault', () async => context.go(Routes.vault)),
      (Icons.backup_outlined, 'Back up now', () async => context.go('${Routes.settings}?section=backup')),
    ];
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      const SectionHeader(title: 'Quick actions'),
      Wrap(spacing: 10, runSpacing: 10, children: [
        for (final a in actions) ActionChip(avatar: Icon(a.$1, size: 16), label: Text(a.$2), onPressed: () => a.$3()),
      ]),
    ]);
  }
}
