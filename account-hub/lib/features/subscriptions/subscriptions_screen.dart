import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../app/providers.dart';
import '../../app/routes.dart';
import '../../app/theme/app_theme.dart';
import '../../core/launch.dart';
import '../../data/repositories/settings_repository.dart';
import '../../data/repositories/subscription_repository.dart';
import '../../domain/enums.dart';
import '../../domain/subscription_math.dart';
import '../../shared/widgets/app_card.dart';
import '../../shared/widgets/confirm_dialog.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/page_scaffold.dart';
import '../../shared/widgets/platform_logo.dart';
import '../../shared/widgets/section_header.dart';
import '../../shared/widgets/stat_card.dart';
import '../../shared/widgets/status_chip.dart';
import '../../shared/widgets/toast.dart';
import 'subscription_charts.dart';
import 'subscription_form.dart';

enum _GroupBy { none, service, method, status }

/// Subscription tracker: manual, no bank connection, currency-aware.
class SubscriptionsScreen extends ConsumerStatefulWidget {
  const SubscriptionsScreen({super.key});
  @override
  ConsumerState<SubscriptionsScreen> createState() => _SubscriptionsScreenState();
}

class _SubscriptionsScreenState extends ConsumerState<SubscriptionsScreen> {
  SubscriptionStatus? _status;
  Classification? _classification;
  _GroupBy _group = _GroupBy.none;
  bool _showArchived = false;
  String _q = '';
  bool _openedNew = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_openedNew) return;
    String? newParam;
    try {
      newParam = GoRouterState.of(context).uri.queryParameters['new'];
    } catch (_) {
      newParam = null; // Not under a router (e.g. widget tests).
    }
    if (newParam == '1') {
      _openedNew = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) showSubscriptionForm(context, ref);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final settings = ref.watch(settingsProvider).value ?? const <String, dynamic>{};
    final currency = settings.defaultCurrency;
    final live = ref.watch(subscriptionsProvider).value ?? const <SubscriptionView>[];
    final archived = _showArchived ? (ref.watch(_archivedSubscriptionsProvider).value ?? const <SubscriptionView>[]) : const <SubscriptionView>[];
    final likes = live.map((s) => s.like).toList();
    final now = DateTime.now();
    final monthly = SubscriptionMath.monthlyTotals(likes);
    final annual = SubscriptionMath.annualTotals(likes);
    final upcoming = SubscriptionMath.upcoming(likes, now: now, days: 30).length;
    final active = live.where((s) => s.status == SubscriptionStatus.active).length;
    final trial = live.where((s) => s.status == SubscriptionStatus.trial).length;
    final paused = live.where((s) => s.status == SubscriptionStatus.paused).length;

    final q = _q.trim().toLowerCase();
    final filtered = [...live, ...archived].where((s) {
      if (_status != null && s.status != _status) return false;
      if (_classification != null && s.classification != _classification) return false;
      if (q.isEmpty) return true;
      return s.sub.serviceName.toLowerCase().contains(q) || (s.sub.plan ?? '').toLowerCase().contains(q) || (s.paymentMethod?.label.toLowerCase().contains(q) ?? false);
    }).toList();

    return PageScaffold(
      title: 'Subscriptions',
      subtitle: 'Track renewals, expenses and status. Tracked manually: nothing connects to your bank.',
      actions: [
        OutlinedButton.icon(onPressed: () => setState(() => _showArchived = !_showArchived), icon: Icon(_showArchived ? Icons.visibility_off_outlined : Icons.archive_outlined, size: 18), label: Text(_showArchived ? 'Hide archived' : 'Show archived')),
        FilledButton.icon(onPressed: () => showSubscriptionForm(context, ref), icon: const Icon(Icons.add, size: 18), label: const Text('Add subscription')),
      ],
      children: [
        ResponsiveGrid(minTileWidth: 180, children: [
          StatCard(label: monthly.isMixed ? 'Monthly cost (per currency)' : 'Monthly cost', value: monthly.isEmpty ? '—' : (monthly.isMixed ? monthly.values.first.format() : monthly.format()), icon: Icons.calendar_month, color: const Color(0xFFF97316), caption: monthly.isMixed ? monthly.values.skip(1).map((m) => m.format()).join(' · ') : 'active + trial'),
          StatCard(label: annual.isMixed ? 'Annual cost (per currency)' : 'Annual cost', value: annual.isEmpty ? '—' : (annual.isMixed ? annual.values.first.format() : annual.format()), icon: Icons.calendar_today, color: const Color(0xFF14B8A6), caption: annual.isMixed ? annual.values.skip(1).map((m) => m.format()).join(' · ') : null),
          StatCard(label: 'Active', value: '$active', icon: Icons.check_circle_outline, color: c.success, onTap: () => setState(() => _status = SubscriptionStatus.active)),
          StatCard(label: 'Trials', value: '$trial', icon: Icons.hourglass_bottom, color: c.accentBlue, onTap: () => setState(() => _status = SubscriptionStatus.trial)),
          StatCard(label: 'Paused', value: '$paused', icon: Icons.pause_circle_outline, color: c.warning, onTap: () => setState(() => _status = SubscriptionStatus.paused)),
          StatCard(label: 'Renewing in 30 days', value: '$upcoming', icon: Icons.event_repeat, color: c.accentPink),
        ]),
        if (monthly.isMixed)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text('Totals are shown separately per currency; amounts are never converted or combined.', style: context.text.bodySmall?.copyWith(color: c.textMuted)),
          ),
        const SizedBox(height: 18),
        if (live.isNotEmpty)
          LayoutBuilder(builder: (context, constraints) {
            final bar = MonthlySpendChart(subs: live, currency: currency);
            final donut = ClassificationDonut(subs: live, currency: currency);
            if (constraints.maxWidth < 820) return Column(children: [bar, const SizedBox(height: 12), donut]);
            return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Expanded(flex: 3, child: bar), const SizedBox(width: 12), Expanded(flex: 2, child: donut)]);
          }),
        if (live.isNotEmpty) const SizedBox(height: 18),
        if (live.isEmpty && archived.isEmpty)
          AppCard(
            child: EmptyState(
              icon: Icons.autorenew,
              title: 'No subscriptions yet',
              message: 'Add what you pay for (Spotify, Adobe, Claude, hosting…). Costs are tracked per currency and renewals can remind you locally. No bank or card connection is needed.',
              actionLabel: 'Add subscription',
              onAction: () => showSubscriptionForm(context, ref),
            ),
          )
        else ...[
          SectionHeader(
            title: 'All subscriptions',
            subtitle: '${filtered.length} shown',
            actions: [SizedBox(width: 220, child: TextField(decoration: const InputDecoration(hintText: 'Search…', prefixIcon: Icon(Icons.search, size: 16)), onChanged: (v) => setState(() => _q = v)))],
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: [
              ChoiceChip(label: const Text('All'), selected: _status == null, onSelected: (_) => setState(() => _status = null)),
              const SizedBox(width: 6),
              for (final st in SubscriptionStatus.values) ...[
                ChoiceChip(label: Text(st.label), selected: _status == st, onSelected: (_) => setState(() => _status = _status == st ? null : st)),
                const SizedBox(width: 6),
              ],
            ]),
          ),
          const SizedBox(height: 8),
          Wrap(spacing: 12, runSpacing: 8, crossAxisAlignment: WrapCrossAlignment.center, children: [
            SegmentedButton<Classification?>(
              segments: const [
                ButtonSegment(value: null, label: Text('All')),
                ButtonSegment(value: Classification.personal, label: Text('Personal')),
                ButtonSegment(value: Classification.business, label: Text('Business')),
              ],
              selected: {_classification},
              onSelectionChanged: (s) => setState(() => _classification = s.first),
            ),
            Row(mainAxisSize: MainAxisSize.min, children: [
              Text('Group by', style: context.text.bodySmall?.copyWith(color: c.textMuted)),
              const SizedBox(width: 8),
              SegmentedButton<_GroupBy>(
                segments: const [
                  ButtonSegment(value: _GroupBy.none, label: Text('None')),
                  ButtonSegment(value: _GroupBy.service, label: Text('Service')),
                  ButtonSegment(value: _GroupBy.method, label: Text('Payment method')),
                  ButtonSegment(value: _GroupBy.status, label: Text('Status')),
                ],
                selected: {_group},
                onSelectionChanged: (s) => setState(() => _group = s.first),
              ),
            ]),
          ]),
          const SizedBox(height: 14),
          if (filtered.isEmpty)
            AppCard(child: EmptyState(compact: true, icon: Icons.filter_alt_off, title: 'No subscriptions match', message: 'Try another status, classification or search.'))
          else
            ..._grouped(filtered).entries.expand((e) => [
                  if (e.key != null) Padding(padding: const EdgeInsets.only(top: 10, bottom: 8), child: Row(children: [Text(e.key!, style: context.text.titleSmall), const SizedBox(width: 8), Text(_groupTotal(e.value), style: context.text.bodySmall?.copyWith(color: c.textMuted))])),
                  for (final s in e.value) Padding(padding: const EdgeInsets.only(bottom: 8), child: SubscriptionRow(view: s, now: now)),
                ]),
        ],
      ],
    );
  }

  Map<String?, List<SubscriptionView>> _grouped(List<SubscriptionView> list) {
    if (_group == _GroupBy.none) return {null: list};
    final out = <String?, List<SubscriptionView>>{};
    for (final s in list) {
      final key = switch (_group) {
        _GroupBy.service => s.platform?.name ?? s.sub.serviceName,
        _GroupBy.method => s.paymentMethod?.label ?? 'No payment method',
        _GroupBy.status => s.status.label,
        _GroupBy.none => null,
      };
      out.putIfAbsent(key, () => []).add(s);
    }
    final keys = out.keys.toList()..sort((a, b) => (a ?? '').compareTo(b ?? ''));
    return {for (final k in keys) k: out[k]!};
  }

  static String _groupTotal(List<SubscriptionView> list) {
    final t = SubscriptionMath.monthlyTotals(list.map((s) => s.like));
    return t.isEmpty ? '' : '${t.format()} / month';
  }
}

final _archivedSubscriptionsProvider = StreamProvider<List<SubscriptionView>>((ref) => ref.watch(subscriptionRepositoryProvider).watchAll(includeArchived: true).map((l) => l.where((s) => s.sub.archivedAt != null).toList()));

/// One subscription row with inline actions.
class SubscriptionRow extends ConsumerWidget {
  const SubscriptionRow({super.key, required this.view, required this.now});
  final SubscriptionView view;
  final DateTime now;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final s = view.sub;
    final repo = ref.read(subscriptionRepositoryProvider);
    final next = s.nextBillingDate;
    final daysLeft = next == null ? null : DateTime(next.year, next.month, next.day).difference(DateTime(now.year, now.month, now.day)).inDays;
    final soon = daysLeft != null && daysLeft <= 7 && view.status.isRecurringCost;
    final archived = s.archivedAt != null;
    final compact = context.isCompact;
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      onTap: () => context.push(Routes.subscription(s.id)),
      child: Row(children: [
        view.platform == null ? MonogramAvatar(text: s.serviceName, seed: s.id, size: 40, icon: Icons.autorenew) : PlatformLogo(platform: view.platform!, size: 40),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Flexible(child: Text(s.serviceName, style: context.text.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis)),
              if (s.plan != null) ...[const SizedBox(width: 6), Flexible(child: Text(s.plan!, style: context.text.bodySmall?.copyWith(color: c.textMuted), maxLines: 1, overflow: TextOverflow.ellipsis))],
            ]),
            const SizedBox(height: 2),
            Text(
              [
                '${view.price.format()} · ${view.cycle.label.toLowerCase()}',
                if (next != null && view.status.isRecurringCost) 'renews ${DateFormat.MMMd().format(next)} (${relativeDate(next, now: now)})',
                if (view.paymentMethod != null) view.paymentMethod!.label,
              ].join(' · '),
              style: context.text.bodySmall?.copyWith(color: soon ? c.warning : c.textMuted),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ]),
        ),
        const SizedBox(width: 8),
        if (!compact) ...[
          ClassificationChip(s.classification),
          const SizedBox(width: 6),
          StatusChip(archived ? 'Archived' : view.status.label, color: archived ? c.textMuted : statusColor(context, s.status)),
        ],
        PopupMenuButton<String>(
          tooltip: 'Actions',
          onSelected: (v) async {
            switch (v) {
              case 'renewed':
                await repo.markRenewed(s.id);
                await rescheduleReminders(ref);
                if (context.mounted) showToast(context, 'Marked renewed; next date advanced');
              case 'pause':
                await repo.setStatus(s.id, SubscriptionStatus.paused);
              case 'resume':
                await repo.setStatus(s.id, SubscriptionStatus.active);
              case 'cancel':
                if (await confirmDestructive(context, title: 'Cancel subscription?', message: 'Marks "${s.serviceName}" as cancelled. The record and its history are kept.', confirmLabel: 'Mark cancelled', danger: false)) {
                  await repo.setStatus(s.id, SubscriptionStatus.cancelled);
                  await rescheduleReminders(ref);
                }
              case 'edit':
                await showSubscriptionForm(context, ref, existing: view);
              case 'url':
                await openUrl(context, s.renewalUrl ?? view.platform?.website);
              case 'archive':
                await repo.setArchived(s.id, true);
                await rescheduleReminders(ref);
              case 'restore':
                await repo.setArchived(s.id, false);
              case 'delete':
                if (await confirmDestructive(context, title: 'Delete subscription?', message: 'Removes "${s.serviceName}" and its history permanently.')) {
                  await repo.delete(s.id);
                  await rescheduleReminders(ref);
                }
            }
          },
          itemBuilder: (_) => [
            if (view.status.isRecurringCost) const PopupMenuItem(value: 'renewed', child: ListTile(dense: true, leading: Icon(Icons.done_all, size: 18), title: Text('Mark renewed'))),
            if (view.status == SubscriptionStatus.active || view.status == SubscriptionStatus.trial) const PopupMenuItem(value: 'pause', child: ListTile(dense: true, leading: Icon(Icons.pause, size: 18), title: Text('Pause'))),
            if (view.status == SubscriptionStatus.paused || view.status == SubscriptionStatus.cancelled || view.status == SubscriptionStatus.expired) const PopupMenuItem(value: 'resume', child: ListTile(dense: true, leading: Icon(Icons.play_arrow, size: 18), title: Text('Resume / reactivate'))),
            if (view.status != SubscriptionStatus.cancelled && view.status != SubscriptionStatus.lifetime) const PopupMenuItem(value: 'cancel', child: ListTile(dense: true, leading: Icon(Icons.cancel_outlined, size: 18), title: Text('Cancel'))),
            const PopupMenuItem(value: 'edit', child: ListTile(dense: true, leading: Icon(Icons.edit_outlined, size: 18), title: Text('Edit'))),
            if ((s.renewalUrl ?? view.platform?.website) != null) const PopupMenuItem(value: 'url', child: ListTile(dense: true, leading: Icon(Icons.open_in_new, size: 18), title: Text('Open renewal page'))),
            if (!archived) const PopupMenuItem(value: 'archive', child: ListTile(dense: true, leading: Icon(Icons.archive_outlined, size: 18), title: Text('Archive')))
            else const PopupMenuItem(value: 'restore', child: ListTile(dense: true, leading: Icon(Icons.unarchive_outlined, size: 18), title: Text('Restore'))),
            const PopupMenuItem(value: 'delete', child: ListTile(dense: true, leading: Icon(Icons.delete_outline, size: 18), title: Text('Delete'))),
          ],
        ),
      ]),
    );
  }
}
