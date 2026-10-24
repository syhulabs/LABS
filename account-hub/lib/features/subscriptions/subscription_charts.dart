import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../app/theme/app_theme.dart';
import '../../data/repositories/subscription_repository.dart';
import '../../domain/enums.dart';
import '../../domain/money.dart';
import '../../domain/subscription_math.dart';
import '../../shared/widgets/app_card.dart';

/// Expected spend per calendar month for the next [months], in [currency]
/// only. Walks each recurring subscription's billing dates forward from its
/// next billing date. Returns (per-month totals, count of excluded subs).
(List<Money>, int) projectMonthly(List<SubscriptionView> subs, {required String currency, required DateTime now, int months = 12}) {
  final totals = List<int>.filled(months, 0);
  var excluded = 0;
  final start = DateTime(now.year, now.month, 1);
  final end = DateTime(now.year, now.month + months, 1);
  for (final s in subs) {
    if (!s.status.isRecurringCost || s.cycle == BillingCycle.oneTime) continue;
    if (s.sub.currency != currency) {
      excluded++;
      continue;
    }
    var d = s.sub.nextBillingDate ?? start;
    d = SubscriptionMath.rollForward(d, s.cycle, s.sub.cycleDays, now: now);
    var guard = 0;
    while (d.isBefore(end) && guard++ < 400) {
      final idx = (d.year - start.year) * 12 + (d.month - start.month);
      if (idx >= 0 && idx < months) totals[idx] += s.sub.priceMinor;
      d = SubscriptionMath.nextDate(d, s.cycle, s.sub.cycleDays);
    }
  }
  return ([for (final t in totals) Money(t, currency)], excluded);
}

/// Bar chart: projected spend for the next 12 months.
class MonthlySpendChart extends StatelessWidget {
  const MonthlySpendChart({super.key, required this.subs, required this.currency, this.now});
  final List<SubscriptionView> subs;
  final String currency;
  final DateTime? now;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final n = now ?? DateTime.now();
    final (totals, excluded) = projectMonthly(subs, currency: currency, now: n);
    if (totals.every((m) => m.minor == 0)) return const SizedBox.shrink();
    final maxMinor = totals.map((m) => m.minor).reduce((a, b) => a > b ? a : b);
    final maxY = maxMinor / 100 * 1.2;
    return AppCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Projected spend · next 12 months ($currency)', style: context.text.titleSmall),
        if (excluded > 0) Padding(padding: const EdgeInsets.only(top: 2), child: Text('$excluded subscription${excluded == 1 ? '' : 's'} in other currencies not included.', style: context.text.bodySmall?.copyWith(color: c.textMuted))),
        const SizedBox(height: 14),
        SizedBox(
          height: 180,
          child: BarChart(
            BarChartData(
              maxY: maxY <= 0 ? 1 : maxY,
              minY: 0,
              alignment: BarChartAlignment.spaceAround,
              gridData: FlGridData(show: true, drawVerticalLine: false, getDrawingHorizontalLine: (_) => FlLine(color: c.border, strokeWidth: 1)),
              borderData: FlBorderData(show: false),
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  getTooltipColor: (_) => c.surfaceHover,
                  getTooltipItem: (group, _, rod, _) => BarTooltipItem(Money((rod.toY * 100).round(), currency).format(), TextStyle(color: c.text, fontWeight: FontWeight.w600)),
                ),
              ),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(),
                rightTitles: const AxisTitles(),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 48,
                    getTitlesWidget: (v, meta) => Text(Money((v * 100).round(), currency).format(compact: true), style: TextStyle(color: c.textMuted, fontSize: 10)),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 22,
                    getTitlesWidget: (v, meta) {
                      final m = DateTime(n.year, n.month + v.toInt(), 1);
                      return Padding(padding: const EdgeInsets.only(top: 4), child: Text(DateFormat.MMM().format(m), style: TextStyle(color: c.textMuted, fontSize: 10)));
                    },
                  ),
                ),
              ),
              barGroups: [
                for (var i = 0; i < totals.length; i++)
                  BarChartGroupData(x: i, barRods: [
                    BarChartRodData(
                      toY: totals[i].major.toDouble(),
                      width: 14,
                      borderRadius: BorderRadius.circular(4),
                      gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [c.accentBlue, c.accent]),
                    ),
                  ]),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}

/// Donut: monthly-equivalent cost split personal vs business.
class ClassificationDonut extends StatelessWidget {
  const ClassificationDonut({super.key, required this.subs, required this.currency});
  final List<SubscriptionView> subs;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final byClass = SubscriptionMath.monthlyByClassification(subs.where((s) => s.sub.currency == currency).map((s) => s.like));
    final personal = byClass[Classification.personal]![currency]?.minor ?? 0;
    final business = byClass[Classification.business]![currency]?.minor ?? 0;
    final total = personal + business;
    if (total == 0) return const SizedBox.shrink();
    String pct(int v) => '${(v * 100 / total).round()}%';
    return AppCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Monthly cost by use ($currency)', style: context.text.titleSmall),
        const SizedBox(height: 14),
        Row(children: [
          SizedBox(
            width: 140,
            height: 140,
            child: PieChart(
              PieChartData(
                sectionsSpace: 3,
                centerSpaceRadius: 36,
                sections: [
                  if (personal > 0) PieChartSectionData(value: personal.toDouble(), color: c.accentBlue, radius: 30, title: pct(personal), titleStyle: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                  if (business > 0) PieChartSectionData(value: business.toDouble(), color: c.accentPink, radius: 30, title: pct(business), titleStyle: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
            _Legend(color: c.accentBlue, label: 'Personal', value: Money(personal, currency).format()),
            const SizedBox(height: 8),
            _Legend(color: c.accentPink, label: 'Business', value: Money(business, currency).format()),
            const SizedBox(height: 8),
            Text('per month, ${Money(total, currency).format()} total', style: context.text.bodySmall?.copyWith(color: c.textMuted)),
          ])),
        ]),
      ]),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.color, required this.label, required this.value});
  final Color color;
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => Row(children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Text(label, style: context.text.bodyMedium),
        const Spacer(),
        Text(value, style: context.text.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
      ]);
}
