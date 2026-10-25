import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../app/theme/app_theme.dart';
import '../../data/db/app_database.dart';
import '../../data/repositories/account_repository.dart';
import '../../data/repositories/settings_repository.dart';
import '../../data/repositories/subscription_repository.dart';
import '../../domain/enums.dart';
import '../../domain/markets.dart';
import '../../domain/money.dart';
import '../../domain/subscription_math.dart';
import '../../shared/widgets/form_sheet.dart';
import '../../shared/widgets/pickers.dart';
import '../../shared/widgets/platform_logo.dart';
import '../../shared/widgets/toast.dart';
import '../banking/bank_account_form.dart';
import 'plan_picker.dart';

/// Store a subscription form starts with. Existing rows keep "not recorded"
/// (null) until the user picks a store, so editing an old row never stamps a
/// guess on it; new subscriptions start from the preset plan or the usual
/// store in Settings.
PurchaseChannel? initialPurchaseChannel({required bool isExisting, String? stored, PurchaseChannel? preset, required PurchaseChannel usual}) =>
    isExisting ? PurchaseChannel.tryParse(stored) : (preset ?? usual);

/// Re-plans local renewal reminders after any subscription change. Fails soft
/// on platforms without notification support.
Future<void> rescheduleReminders(WidgetRef ref) async {
  try {
    final settings = ref.read(settingsProvider).value ?? const <String, dynamic>{};
    final subs = await ref.read(subscriptionRepositoryProvider).watchAll().first;
    await ref.read(notificationServiceProvider).rescheduleRenewals(subs, daysBefore: settings.renewalReminderDays, enabled: settings.notificationsEnabled);
  } catch (_) {}
}

/// Create / edit a subscription. Returns the saved id. [presetPlan] pre-fills
/// plan name, price, currency, cycle and channel from the plan catalog.
Future<String?> showSubscriptionForm(BuildContext context, WidgetRef ref, {SubscriptionView? existing, Platform? presetPlatform, PlanPick? presetPlan}) async {
  final s = existing?.sub;
  final settings = ref.read(settingsProvider).value ?? const <String, dynamic>{};
  // Load the plan catalog before the sheet opens: the sheet's builder does
  // not rebuild when a FutureProvider resolves later.
  try {
    await ref.read(planCatalogProvider.future);
  } catch (_) {
    // Plans are optional reference data.
  }
  Platform? platform = existing?.platform ?? presetPlatform;
  final service = TextEditingController(text: s?.serviceName ?? platform?.name ?? '');
  final plan = TextEditingController(text: s?.plan ?? presetPlan?.plan.name ?? '');
  final presetMoney = presetPlan?.quote.price.money;
  final amount = TextEditingController(text: s != null ? Money(s.priceMinor, s.currency).major.toStringAsFixed(Money(s.priceMinor, s.currency).fractionDigits) : presetMoney?.major.toStringAsFixed(presetMoney.fractionDigits) ?? '');
  final cycleDays = TextEditingController(text: s?.cycleDays?.toString() ?? '');
  final renewalUrl = TextEditingController(text: s?.renewalUrl ?? '');
  final notes = TextEditingController(text: s?.notes ?? '');
  final tags = TextEditingController(text: s == null ? '' : (await ref.read(tagRepositoryProvider).watchTagsFor(EntityType.subscription, s.id).first).map((t) => t.name).join(', '));
  var currency = s?.currency ?? presetMoney?.currency ?? settings.defaultCurrency;
  var cycle = s != null ? enumFromName(BillingCycle.values, s.billingCycle, BillingCycle.monthly) : (presetPlan?.plan.cycle ?? BillingCycle.monthly);
  var channel = initialPurchaseChannel(isExisting: s != null, stored: s?.purchaseChannel, preset: presetPlan?.channel, usual: settings.purchaseChannel);
  final market = settings.market;
  void applyPick(PlanPick pick) {
    plan.text = pick.plan.name;
    final m = pick.quote.price.money;
    amount.text = m.major.toStringAsFixed(m.fractionDigits);
    currency = m.currency;
    cycle = pick.plan.cycle;
    channel = pick.channel;
  }
  DateTime? startDate = s?.startDate;
  DateTime? nextDate = s?.nextBillingDate;
  DateTime? cancellationDate = s?.cancellationDate;
  var status = enumFromName(SubscriptionStatus.values, s?.status, SubscriptionStatus.active);
  String? paymentMethodId = s?.paymentMethodId;
  String? accountId = s?.accountId;
  var classification = enumFromName(Classification.values, s?.classification, Classification.personal);
  var reminders = s?.remindersEnabled ?? true;
  final formKey = GlobalKey<FormState>();
  final tagSuggestions = (ref.read(tagsProvider).value ?? []).map((t) => t.name).toList();

  if (!context.mounted) return null;
  return showFormSheet<String>(context, title: existing == null ? 'Add subscription' : 'Edit subscription', maxWidth: 600, builder: (ctx, close) {
    return StatefulBuilder(builder: (ctx, setState) {
      final methods = ref.watch(paymentMethodsProvider).value ?? const <PaymentMethod>[];
      final found = ref.read(planCatalogProvider).value?.plansFor(platform?.id);
      final plans = (found != null && found.plans.isNotEmpty) ? found : null;
      final accounts = (ref.watch(accountsProvider).value ?? const <AccountView>[]).where((a) => platform == null || a.platform.id == platform!.id).toList();
      int? parsedDays() => int.tryParse(cycleDays.text.trim());
      return Form(
        key: formKey,
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          FormSectionTitle('Service'),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            if (platform != null) Padding(padding: const EdgeInsets.only(right: 10, top: 2), child: PlatformLogo(platform: platform!, size: 40)),
            Expanded(child: AppTextField(controller: service, label: 'Service name', autofocus: existing == null && platform == null, validator: (v) => requiredValidator(v, 'Service name'))),
            const SizedBox(width: 8),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: OutlinedButton.icon(
                onPressed: () async {
                  final p = await showPlatformPicker(ctx, ref, title: 'Which service is this subscription for?');
                  if (p == null) return;
                  setState(() {
                    platform = p;
                    if (service.text.trim().isEmpty || service.text.trim() == existing?.platform?.name) service.text = p.name;
                    accountId = null;
                  });
                },
                icon: const Icon(Icons.search, size: 16),
                label: Text(platform == null ? 'Pick platform' : 'Change'),
              ),
            ),
            if (platform != null) IconButton(tooltip: 'Unlink platform', icon: const Icon(Icons.clear, size: 16), onPressed: () => setState(() { platform = null; accountId = null; })),
          ]),
          if (accounts.isNotEmpty)
            AppDropdown<String>(label: 'Account', value: accountId, allowNull: true, nullLabel: 'Not linked', items: [for (final a in accounts) (a.account.id, '${a.account.accountName}${a.email == null ? '' : ' · ${a.email!.address}'}')], onChanged: (v) => setState(() => accountId = v)),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(child: AppTextField(controller: plan, label: 'Plan', hint: 'Premium, Pro, Family…')),
            if (plans != null) ...[
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: FilledButton.tonalIcon(
                  onPressed: () async {
                    final pick = await showPlanPicker(ctx, ref, plans: plans, channel: channel ?? settings.purchaseChannel, market: market);
                    if (pick != null) setState(() => applyPick(pick));
                  },
                  icon: const Icon(Icons.list_alt_outlined, size: 16),
                  label: Text('Choose a plan (${market.code})'),
                ),
              ),
            ],
          ]),
          FormSectionTitle('Billing'),
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Billed through', style: ctx.text.labelLarge),
              const SizedBox(height: 6),
              ChannelSelector(value: channel, onChanged: (v) => setState(() => channel = v)),
              const SizedBox(height: 4),
              Text(
                channel == null
                    ? 'Not recorded yet. Pick the store this subscription is billed through.'
                    : plans == null
                        ? 'Store prices often differ from the web price for the same plan.'
                        : 'Switching the store re-quotes the plan when you choose one.',
                style: TextStyle(color: ctx.colors.textMuted, fontSize: 12),
              ),
            ]),
          ),
          MoneyField(amountController: amount, currency: currency, onCurrencyChanged: (v) => setState(() => currency = v)),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(child: AppDropdown<BillingCycle>(label: 'Billing cycle', value: cycle, items: [for (final c in BillingCycle.values) (c, c.label)], onChanged: (v) => setState(() => cycle = v ?? cycle))),
            if (cycle == BillingCycle.custom) ...[
              const SizedBox(width: 10),
              Expanded(child: AppTextField(controller: cycleDays, label: 'Every N days', keyboardType: TextInputType.number, validator: (v) => (int.tryParse(v?.trim() ?? '') ?? 0) > 0 ? null : 'Enter days')),
            ],
          ]),
          Row(children: [
            Expanded(child: DateField(label: 'Start date', value: startDate, onChanged: (d) => setState(() {
              startDate = d;
              if (d != null && nextDate == null && cycle != BillingCycle.oneTime) nextDate = SubscriptionMath.nextDate(d, cycle, parsedDays());
            }))),
            const SizedBox(width: 10),
            Expanded(child: DateField(label: 'Next billing date', value: nextDate, onChanged: (d) => setState(() => nextDate = d))),
          ]),
          if (nextDate == null && cycle != BillingCycle.oneTime)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () => setState(() => nextDate = SubscriptionMath.nextDate(startDate ?? DateTime.now(), cycle, parsedDays())),
                  icon: const Icon(Icons.auto_fix_high, size: 16),
                  label: Text('Suggest next date (${startDate == null ? 'today' : 'start'} + one ${cycle.label.toLowerCase()} period)'),
                ),
              ),
            ),
          Row(children: [
            Expanded(child: AppDropdown<SubscriptionStatus>(label: 'Status', value: status, items: [for (final st in SubscriptionStatus.values) (st, st.label)], onChanged: (v) => setState(() => status = v ?? status))),
            if (status == SubscriptionStatus.cancelled || status == SubscriptionStatus.expired) ...[
              const SizedBox(width: 10),
              Expanded(child: DateField(label: 'Cancellation date', value: cancellationDate, onChanged: (d) => setState(() => cancellationDate = d))),
            ],
          ]),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(child: AppDropdown<String>(label: 'Payment method', value: paymentMethodId, allowNull: true, nullLabel: 'Not set', items: [for (final m in methods) (m.id, m.isDefault ? '${m.label} (default)' : m.label)], onChanged: (v) => setState(() => paymentMethodId = v))),
            const SizedBox(width: 8),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: IconButton.outlined(
                tooltip: 'Add a payment method',
                icon: const Icon(Icons.add),
                onPressed: () async {
                  final id = await showPaymentMethodForm(ctx, ref);
                  if (id != null) setState(() => paymentMethodId = id);
                },
              ),
            ),
          ]),
          ClassificationToggle(value: classification, onChanged: (v) => setState(() => classification = v)),
          AppTextField(controller: renewalUrl, label: 'Renewal / manage URL', hint: 'https://…', validator: urlValidator, keyboardType: TextInputType.url, prefixIcon: Icons.link),
          SwitchListTile(contentPadding: EdgeInsets.zero, title: const Text('Renewal reminders'), subtitle: Text('Local notification before the next billing date. The notification names the service only.', style: TextStyle(color: ctx.colors.textMuted, fontSize: 12)), value: reminders, onChanged: (v) => setState(() => reminders = v)),
          TagsField(controller: tags, suggestions: tagSuggestions),
          AppTextField(controller: notes, label: 'Notes', maxLines: 3),
          FormActions(
            onCancel: close,
            onSave: () async {
              if (!formKey.currentState!.validate()) return;
              final price = MoneyField.parse(amount.text, currency);
              if (price == null) {
                showToast(ctx, 'Enter a valid amount', error: true);
                return;
              }
              try {
                final saved = await ref.read(subscriptionRepositoryProvider).upsert(
                      id: s?.id,
                      platformId: platform?.id,
                      serviceName: service.text,
                      accountId: accountId,
                      plan: plan.text,
                      price: price,
                      cycle: cycle,
                      cycleDays: parsedDays(),
                      startDate: startDate,
                      nextBillingDate: nextDate,
                      cancellationDate: cancellationDate,
                      status: status,
                      paymentMethodId: paymentMethodId,
                      classification: classification,
                      renewalUrl: renewalUrl.text,
                      remindersEnabled: reminders,
                      notes: notes.text,
                      purchaseChannel: channel,
                    );
                await ref.read(tagRepositoryProvider).setTags(EntityType.subscription, saved.id, TagsField.parse(tags.text));
                await rescheduleReminders(ref);
                close(saved.id);
              } catch (err) {
                if (ctx.mounted) showToast(ctx, friendlyError(err), error: true);
              }
            },
          ),
        ]),
      );
    });
  });
}

/// Relative label for a billing date ("today", "in 3 days", "4 days ago").
String relativeDate(DateTime d, {DateTime? now}) {
  final n = now ?? DateTime.now();
  final days = DateTime(d.year, d.month, d.day).difference(DateTime(n.year, n.month, n.day)).inDays;
  if (days == 0) return 'today';
  if (days == 1) return 'tomorrow';
  if (days == -1) return 'yesterday';
  if (days < 0) return '${-days} days ago';
  return 'in $days days';
}
