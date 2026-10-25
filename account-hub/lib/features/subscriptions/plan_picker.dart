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

/// What the user picked in [showPlanPicker]: the plan, the quote shown for it
/// and the channel they chose to buy through.
class PlanPick {
  const PlanPick(this.plan, this.quote, this.channel);
  final ServicePlan plan;
  final PlanQuote quote;
  final PurchaseChannel channel;
}

IconData channelIcon(PurchaseChannel c) => switch (c) {
      PurchaseChannel.web => Icons.language,
      PurchaseChannel.ios => Icons.phone_iphone,
      PurchaseChannel.android => Icons.android,
    };

/// Three-way Web / App Store / Google Play selector used wherever a price
/// depends on the store. A null [value] shows no selection ("not recorded").
class ChannelSelector extends StatelessWidget {
  const ChannelSelector({super.key, required this.value, required this.onChanged, this.dense = false});
  final PurchaseChannel? value;
  final ValueChanged<PurchaseChannel> onChanged;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<PurchaseChannel>(
      style: dense ? const ButtonStyle(visualDensity: VisualDensity.compact, padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 8))) : null,
      showSelectedIcon: false,
      emptySelectionAllowed: true,
      segments: [
        for (final c in PurchaseChannel.values) ButtonSegment(value: c, label: Text(dense ? c.shortLabel : c.label), icon: Icon(channelIcon(c), size: 16)),
      ],
      selected: {?value},
      onSelectionChanged: (s) {
        // Tapping the selected segment would clear it; keep the current value.
        if (s.isNotEmpty) onChanged(s.first);
      },
    );
  }
}

/// One plan row: price on the right, cycle/store/date underneath and, when the
/// quote fell back to another store or the default price, why.
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
    final meta = [
      plan.cycle.label,
      quote.channel.shortLabel,
      if (verified != null) '${quote.price.isObserved ? 'seen in store' : 'verified'} ${DateFormat.yMMMd().format(verified)}',
    ].join(' · ');
    return ListTile(
      dense: dense,
      isThreeLine: caption != null,
      contentPadding: EdgeInsets.symmetric(horizontal: dense ? 4 : 12),
      title: Text(plan.name),
      subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
        Text(meta, style: TextStyle(color: c.textMuted, fontSize: 12)),
        if (caption != null)
          Text(caption, style: TextStyle(color: quote.isDefault ? c.warning : c.accentBlue, fontSize: 12)),
      ]),
      trailing: Text(quote.price.money.format(), style: context.text.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
      onTap: onTap,
    );
  }
}

/// One-line summary of what local prices exist for [m], shared by the plan
/// sheet and the platform page.
String localPricingSummary(ServicePlans plans, Market m) {
  final local = plans.localChannels(m.code);
  if (local.isEmpty) {
    return 'No ${m.name} price list on file · default ${plans.defaultCurrency ?? 'USD'} prices shown';
  }
  final stores = [for (final c in PurchaseChannel.values) if (local.contains(c)) c.shortLabel].join(', ');
  return '${m.name} prices on file for $stores';
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
      final rows = <Widget>[
        for (final p in plans.plans)
          if (p.quote(country: m.code, channel: chosen) case final q?) PlanRow(plan: p, quote: q, requested: chosen, onTap: () => close(PlanPick(p, q, chosen))),
      ];
      return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text('${m.flag} ${m.name}', style: ctx.text.titleSmall),
        const SizedBox(height: 8),
        Align(alignment: Alignment.centerLeft, child: ChannelSelector(value: chosen, onChanged: (v) => setState(() => chosen = v), dense: true)),
        const SizedBox(height: 8),
        Text('${localPricingSummary(plans, m)}. Other stores fall back to a labelled price.', style: ctx.text.bodySmall?.copyWith(color: c.textMuted)),
        const SizedBox(height: 8),
        if (rows.isEmpty)
          Padding(padding: const EdgeInsets.symmetric(vertical: 16), child: Text('No published price for ${m.name} on file. Enter the price shown at checkout instead.', style: TextStyle(color: c.textMuted)))
        else
          ...rows,
        const SizedBox(height: 10),
        Text('Published prices, not live. Taxes and promos vary; the checkout price wins.${plans.notes == null ? '' : ' ${plans.notes}'}', style: ctx.text.bodySmall?.copyWith(color: c.textMuted)),
        if (plans.pricingUrl != null)
          Align(alignment: Alignment.centerLeft, child: TextButton.icon(onPressed: () => openUrl(ctx, plans.pricingUrl), icon: const Icon(Icons.open_in_new, size: 14), label: const Text('Pricing page'))),
      ]);
    });
  });
}
