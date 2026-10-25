import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../app/providers.dart';
import '../../app/theme/app_theme.dart';
import '../../core/launch.dart';
import '../../data/catalog/plan_models.dart';
import '../../data/repositories/settings_repository.dart';
import '../../domain/markets.dart';
import '../../shared/widgets/form_sheet.dart';
import '../../shared/widgets/status_chip.dart';

/// What the user picked in [showPlanPicker]: the plan, the quote shown for it
/// and the channel they chose to buy through.
class PlanPick {
  const PlanPick(this.plan, this.quote, this.channel);
  final ServicePlan plan;
  final PlanQuote quote;
  final PurchaseChannel channel;
}

/// Three-way Web / App Store / Google Play selector used wherever a price
/// depends on the store.
class ChannelSelector extends StatelessWidget {
  const ChannelSelector({super.key, required this.value, required this.onChanged, this.dense = false});
  final PurchaseChannel value;
  final ValueChanged<PurchaseChannel> onChanged;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<PurchaseChannel>(
      style: dense ? const ButtonStyle(visualDensity: VisualDensity.compact, padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 8))) : null,
      showSelectedIcon: false,
      segments: [
        for (final c in PurchaseChannel.values)
          ButtonSegment(
            value: c,
            label: Text(dense ? c.shortLabel : c.label),
            icon: Icon(switch (c) { PurchaseChannel.web => Icons.language, PurchaseChannel.ios => Icons.phone_iphone, PurchaseChannel.android => Icons.android }, size: 16),
          ),
      ],
      selected: {value},
      onSelectionChanged: (s) => onChanged(s.first),
    );
  }
}

/// One plan row with its quoted price and a caption when the quote fell back.
class PlanRow extends StatelessWidget {
  const PlanRow({super.key, required this.plan, required this.quote, required this.requested, this.onTap, this.dense = false});
  final ServicePlan plan;
  final PlanQuote quote;
  final PurchaseChannel requested;
  final VoidCallback? onTap;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final caption = quote.caption(requested);
    final verified = quote.price.verifiedAt;
    return ListTile(
      dense: dense,
      contentPadding: EdgeInsets.symmetric(horizontal: dense ? 4 : 12),
      title: Text(plan.name),
      subtitle: Text([
        plan.cycle.label,
        if (verified != null) 'verified ${DateFormat.yMMMd().format(verified)}',
      ].join(' · '), style: TextStyle(color: c.textMuted, fontSize: 12)),
      trailing: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.end, children: [
        Text(quote.price.money.format(), style: context.text.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
        if (caption != null)
          Padding(padding: const EdgeInsets.only(top: 2), child: StatusChip(quote.isDefault ? '${quote.price.money.currency} default' : '${quote.channel.shortLabel} price', color: quote.isDefault ? c.warning : c.accentBlue, icon: Icons.info_outline))
        else
          Padding(padding: const EdgeInsets.only(top: 2), child: StatusChip(quote.channel.shortLabel, color: c.success)),
      ]),
      onTap: onTap,
    );
  }
}

/// Lists the published plans of a service for the chosen market and channel.
/// Returns the chosen plan/quote/channel or null.
Future<PlanPick?> showPlanPicker(BuildContext context, WidgetRef ref, {required ServicePlans plans, required PurchaseChannel channel, Market? market}) {
  final settings = ref.read(settingsProvider).value ?? const <String, dynamic>{};
  final m = market ?? settings.market;
  var chosen = channel;
  return showFormSheet<PlanPick>(context, title: '${plans.name} plans', maxWidth: 560, builder: (ctx, close) {
    return StatefulBuilder(builder: (ctx, setState) {
      final c = ctx.colors;
      final local = plans.hasLocalPricing(m.code);
      return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(children: [
          Expanded(child: Text('${m.flag} ${m.name}', style: ctx.text.titleSmall)),
          ChannelSelector(value: chosen, onChanged: (v) => setState(() => chosen = v), dense: true),
        ]),
        const SizedBox(height: 6),
        Text(
          local
              ? 'Prices ${plans.name} publishes for ${m.name}. Store prices (App Store / Google Play) are shown when published; otherwise the web price is used.'
              : 'No ${m.name} price list on file for ${plans.name}; its default ${plans.plans.first.prices[ServicePlan.defaultKey]?.values.first.money.currency ?? 'USD'} prices are shown. Most services bill in USD where they have no local price.',
          style: ctx.text.bodySmall?.copyWith(color: c.textMuted),
        ),
        const SizedBox(height: 8),
        for (final p in plans.plans)
          if (p.quote(country: m.code, channel: chosen) case final q?) PlanRow(plan: p, quote: q, requested: chosen, onTap: () => close(PlanPick(p, q, chosen))),
        const SizedBox(height: 10),
        Row(children: [
          Expanded(child: Text('Published prices, not live. Taxes and promos vary; the checkout price wins.${plans.notes == null ? '' : ' ${plans.notes}'}', style: ctx.text.bodySmall?.copyWith(color: c.textMuted))),
          if (plans.pricingUrl != null) TextButton.icon(onPressed: () => openUrl(ctx, plans.pricingUrl), icon: const Icon(Icons.open_in_new, size: 14), label: const Text('Pricing page')),
        ]),
      ]);
    });
  });
}
