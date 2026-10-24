import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../app/providers.dart';
import '../../app/routes.dart';
import '../../app/theme/app_theme.dart';
import '../../core/launch.dart';
import '../../data/db/app_database.dart';
import '../../data/repositories/subscription_repository.dart';
import '../../domain/enums.dart';
import '../../domain/subscription_math.dart';
import '../../shared/widgets/app_card.dart';
import '../../shared/widgets/confirm_dialog.dart';
import '../../shared/widgets/form_sheet.dart';
import '../../shared/widgets/page_scaffold.dart';
import '../../shared/widgets/platform_logo.dart';
import '../../shared/widgets/relations_panel.dart';
import '../../shared/widgets/section_header.dart';
import '../../shared/widgets/status_chip.dart';
import '../../shared/widgets/toast.dart';
import 'subscription_form.dart';

final _subscriptionByIdProvider = StreamProvider.family<SubscriptionView?, String>((ref, id) => ref.watch(subscriptionRepositoryProvider).watchById(id));

class SubscriptionDetailScreen extends ConsumerWidget {
  const SubscriptionDetailScreen({super.key, required this.subscriptionId});
  final String subscriptionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    void back() => context.canPop() ? context.pop() : context.go(Routes.subscriptions);
    final view = ref.watch(_subscriptionByIdProvider(subscriptionId)).value;
    if (view == null) {
      return Scaffold(appBar: AppBar(backgroundColor: c.background, leading: BackButton(onPressed: back)), body: const Center(child: Text('Subscription not found')));
    }
    final s = view.sub;
    final repo = ref.read(subscriptionRepositoryProvider);
    final history = ref.watch(subscriptionHistoryProvider(s.id)).value ?? const <SubscriptionEvent>[];
    final account = s.accountId == null ? null : (ref.watch(accountsProvider).value ?? []).where((a) => a.account.id == s.accountId).firstOrNull;
    final monthly = SubscriptionMath.monthlyCost(view.like);
    final annual = SubscriptionMath.annualCost(view.like);
    final now = DateTime.now();
    final df = DateFormat.yMMMd();
    final archived = s.archivedAt != null;

    final facts = <(String, String?)>[
      ('Price', '${view.price.format()} · ${view.cycle.label.toLowerCase()}${view.cycle == BillingCycle.custom && s.cycleDays != null ? ' (${s.cycleDays} days)' : ''}'),
      ('Monthly equivalent', monthly?.format()),
      ('Annual cost', annual?.format()),
      ('Start date', s.startDate == null ? null : df.format(s.startDate!)),
      ('Next billing', s.nextBillingDate == null ? null : '${df.format(s.nextBillingDate!)} (${relativeDate(s.nextBillingDate!, now: now)})'),
      ('Cancellation date', s.cancellationDate == null ? null : df.format(s.cancellationDate!)),
      ('Reminders', s.remindersEnabled ? 'On' : 'Off'),
    ];

    return Scaffold(
      appBar: AppBar(backgroundColor: c.background, title: Text(s.serviceName), leading: BackButton(onPressed: back)),
      body: PageScaffold(
        title: s.serviceName,
        header: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          view.platform == null ? MonogramAvatar(text: s.serviceName, seed: s.id, size: 72, icon: Icons.autorenew) : PlatformLogo(platform: view.platform!, size: 72, radius: 20),
          const SizedBox(width: 18),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(s.serviceName, style: context.text.headlineMedium),
            const SizedBox(height: 4),
            Text([if (s.plan != null) s.plan!, '${view.price.format()} ${view.cycle.label.toLowerCase()}'].join(' · '), style: context.text.bodyMedium?.copyWith(color: c.textMuted)),
            const SizedBox(height: 8),
            Wrap(spacing: 6, runSpacing: 6, children: [
              StatusChip(view.status.label, color: statusColor(context, s.status), dense: false),
              ClassificationChip(s.classification),
              if (archived) StatusChip('Archived', color: c.textMuted, dense: false),
            ]),
          ])),
        ]),
        children: [
          Wrap(spacing: 10, runSpacing: 10, children: [
            FilledButton.icon(onPressed: () => showSubscriptionForm(context, ref, existing: view), icon: const Icon(Icons.edit_outlined, size: 18), label: const Text('Edit')),
            if (view.status.isRecurringCost)
              OutlinedButton.icon(
                onPressed: () async {
                  await repo.markRenewed(s.id);
                  await rescheduleReminders(ref);
                  if (context.mounted) showToast(context, 'Marked renewed; next billing date advanced');
                },
                icon: const Icon(Icons.done_all, size: 18),
                label: const Text('Mark renewed'),
              ),
            if (view.status == SubscriptionStatus.active || view.status == SubscriptionStatus.trial) OutlinedButton.icon(onPressed: () => repo.setStatus(s.id, SubscriptionStatus.paused), icon: const Icon(Icons.pause, size: 18), label: const Text('Pause')),
            if (view.status == SubscriptionStatus.paused) OutlinedButton.icon(onPressed: () => repo.setStatus(s.id, SubscriptionStatus.active), icon: const Icon(Icons.play_arrow, size: 18), label: const Text('Resume')),
            if (view.status == SubscriptionStatus.cancelled || view.status == SubscriptionStatus.expired) OutlinedButton.icon(onPressed: () => repo.setStatus(s.id, SubscriptionStatus.active), icon: const Icon(Icons.restart_alt, size: 18), label: const Text('Reactivate')),
            if (view.status != SubscriptionStatus.cancelled && view.status != SubscriptionStatus.lifetime)
              OutlinedButton.icon(
                onPressed: () async {
                  if (!await confirmDestructive(context, title: 'Cancel subscription?', message: 'Marks "${s.serviceName}" as cancelled and stops reminders. History is kept.', confirmLabel: 'Mark cancelled', danger: false)) return;
                  await repo.setStatus(s.id, SubscriptionStatus.cancelled);
                  await rescheduleReminders(ref);
                },
                icon: const Icon(Icons.cancel_outlined, size: 18),
                label: const Text('Cancel'),
              ),
            if ((s.renewalUrl ?? view.platform?.website) != null) OutlinedButton.icon(onPressed: () => openUrl(context, s.renewalUrl ?? view.platform?.website), icon: const Icon(Icons.open_in_new, size: 18), label: const Text('Open renewal page')),
            if (!archived)
              OutlinedButton.icon(onPressed: () async { await repo.setArchived(s.id, true); await rescheduleReminders(ref); }, icon: const Icon(Icons.archive_outlined, size: 18), label: const Text('Archive'))
            else
              OutlinedButton.icon(onPressed: () => repo.setArchived(s.id, false), icon: const Icon(Icons.unarchive_outlined, size: 18), label: const Text('Restore')),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(foregroundColor: c.danger),
              onPressed: () async {
                if (!await confirmDestructive(context, title: 'Delete subscription?', message: 'Removes "${s.serviceName}" and its history permanently.')) return;
                await repo.delete(s.id);
                await rescheduleReminders(ref);
                if (context.mounted) back();
              },
              icon: const Icon(Icons.delete_outline, size: 18),
              label: const Text('Delete'),
            ),
          ]),
          const SizedBox(height: 24),
          const SectionHeader(title: 'Details'),
          AppCard(
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              for (final f in facts.where((f) => f.$2 != null))
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    SizedBox(width: 160, child: Text(f.$1, style: context.text.bodySmall?.copyWith(color: c.textMuted))),
                    Expanded(child: SelectableText(f.$2!)),
                  ]),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(children: [
                  SizedBox(width: 160, child: Text('Payment method', style: context.text.bodySmall?.copyWith(color: c.textMuted))),
                  Expanded(
                    child: view.paymentMethod == null
                        ? Text('Not set', style: TextStyle(color: c.textMuted))
                        : Align(alignment: Alignment.centerLeft, child: ActionChip(avatar: const Icon(Icons.payments_outlined, size: 14), label: Text(view.paymentMethod!.label), onPressed: () => context.go('${Routes.banking}?tab=methods'))),
                  ),
                ]),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(children: [
                  SizedBox(width: 160, child: Text('Account', style: context.text.bodySmall?.copyWith(color: c.textMuted))),
                  Expanded(
                    child: account == null
                        ? Text('Not linked', style: TextStyle(color: c.textMuted))
                        : Align(alignment: Alignment.centerLeft, child: ActionChip(avatar: const Icon(Icons.person_outline, size: 14), label: Text('${account.platform.name} · ${account.account.accountName}'), onPressed: () => context.push(Routes.account(account.account.id)))),
                  ),
                ]),
              ),
              if (view.platform != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(children: [
                    SizedBox(width: 160, child: Text('Platform', style: context.text.bodySmall?.copyWith(color: c.textMuted))),
                    Expanded(child: Align(alignment: Alignment.centerLeft, child: ActionChip(avatar: const Icon(Icons.apps, size: 14), label: Text(view.platform!.name), onPressed: () => context.push(Routes.platform(view.platform!.id))))),
                  ]),
                ),
            ]),
          ),
          if (s.notes != null) ...[
            const SizedBox(height: 18),
            const SectionHeader(title: 'Notes'),
            AppCard(child: SelectableText(s.notes!)),
          ],
          const SizedBox(height: 18),
          SectionHeader(
            title: 'History',
            subtitle: '${history.length} event${history.length == 1 ? '' : 's'}',
            actions: [
              TextButton.icon(
                icon: const Icon(Icons.note_add_outlined, size: 16),
                label: const Text('Add note'),
                onPressed: () async {
                  final ctrl = TextEditingController();
                  await showFormSheet<void>(context, title: 'Add note to history', maxWidth: 440, builder: (ctx, close) {
                    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                      AppTextField(controller: ctrl, label: 'Note', maxLines: 3, autofocus: true),
                      FormActions(onCancel: close, onSave: () async {
                        if (ctrl.text.trim().isEmpty) return;
                        await repo.addNote(s.id, ctrl.text);
                        close();
                      }),
                    ]);
                  });
                },
              ),
            ],
          ),
          AppCard(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: history.isEmpty
                ? Padding(padding: const EdgeInsets.all(12), child: Text('No history yet.', style: TextStyle(color: c.textMuted)))
                : Column(children: [
                    for (final e in history)
                      ListTile(
                        dense: true,
                        leading: Icon(_iconFor(e.kind), size: 18, color: _colorFor(context, e.kind)),
                        title: Text(e.details ?? _labelFor(e.kind)),
                        subtitle: Text('${_labelFor(e.kind)} · ${DateFormat.yMMMd().add_jm().format(e.at)}'),
                      ),
                  ]),
          ),
          const SizedBox(height: 18),
          RelationsPanel(type: EntityType.subscription, id: s.id),
        ],
      ),
    );
  }

  static IconData _iconFor(String kind) => switch (kind) {
        'created' => Icons.add_circle_outline,
        'renewed' => Icons.done_all,
        'priceChanged' => Icons.price_change_outlined,
        'statusChanged' => Icons.swap_horiz,
        'planChanged' => Icons.layers_outlined,
        'note' => Icons.sticky_note_2_outlined,
        _ => Icons.history,
      };

  static String _labelFor(String kind) => switch (kind) {
        'created' => 'Created',
        'renewed' => 'Renewed',
        'priceChanged' => 'Price changed',
        'statusChanged' => 'Status changed',
        'planChanged' => 'Plan changed',
        'note' => 'Note',
        _ => kind,
      };

  static Color _colorFor(BuildContext context, String kind) => switch (kind) {
        'renewed' => context.colors.success,
        'priceChanged' => context.colors.warning,
        'statusChanged' => context.colors.accentBlue,
        _ => context.colors.textMuted,
      };
}
