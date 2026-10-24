import 'enums.dart';
import 'money.dart';

/// A plain-Dart view of a subscription, decoupled from the database row so the
/// calculations can be unit-tested without drift.
class SubscriptionLike {
  const SubscriptionLike({
    required this.id,
    required this.price,
    required this.cycle,
    required this.status,
    this.cycleDays,
    this.nextBillingDate,
    this.classification = Classification.personal,
  });

  final String id;
  final Money price;
  final BillingCycle cycle;
  final int? cycleDays;
  final SubscriptionStatus status;
  final DateTime? nextBillingDate;
  final Classification classification;
}

/// Pure subscription calculations.
class SubscriptionMath {
  const SubscriptionMath._();

  /// Number of billing periods per year for the given cycle.
  static double? periodsPerYear(BillingCycle cycle, int? cycleDays) {
    if (cycle == BillingCycle.custom) {
      if (cycleDays == null || cycleDays <= 0) return null;
      return 365.25 / cycleDays;
    }
    return cycle.periodsPerYear;
  }

  /// Annualised cost; `null` for one-time or undefined cycles.
  static Money? annualCost(SubscriptionLike s) {
    final p = periodsPerYear(s.cycle, s.cycleDays);
    if (p == null) return null;
    return s.price.scaled(p);
  }

  /// Monthly-equivalent cost (annual / 12); `null` for one-time.
  static Money? monthlyCost(SubscriptionLike s) {
    final annual = annualCost(s);
    return annual?.scaled(1 / 12);
  }

  /// Totals grouped by currency over subscriptions that are a recurring cost
  /// (active or trial). Lifetime/one-time entries are excluded.
  static MoneyTotals monthlyTotals(Iterable<SubscriptionLike> subs) {
    final t = MoneyTotals();
    for (final s in subs) {
      if (!s.status.isRecurringCost) continue;
      final m = monthlyCost(s);
      if (m != null) t.add(m);
    }
    return t;
  }

  static MoneyTotals annualTotals(Iterable<SubscriptionLike> subs) {
    final t = MoneyTotals();
    for (final s in subs) {
      if (!s.status.isRecurringCost) continue;
      final a = annualCost(s);
      if (a != null) t.add(a);
    }
    return t;
  }

  /// Subscriptions renewing within [days] from [now], soonest first.
  static List<SubscriptionLike> upcoming(
    Iterable<SubscriptionLike> subs, {
    required DateTime now,
    int days = 30,
  }) {
    final horizon = now.add(Duration(days: days));
    final list = subs.where((s) {
      final d = s.nextBillingDate;
      return s.status.isRecurringCost &&
          d != null &&
          !d.isBefore(DateTime(now.year, now.month, now.day)) &&
          !d.isAfter(horizon);
    }).toList()
      ..sort((a, b) => a.nextBillingDate!.compareTo(b.nextBillingDate!));
    return list;
  }

  /// Advances [from] by one billing period. Month arithmetic clamps the day so
  /// 31 Jan + 1 month = 28/29 Feb.
  static DateTime nextDate(DateTime from, BillingCycle cycle, int? cycleDays) {
    switch (cycle) {
      case BillingCycle.weekly:
        return from.add(const Duration(days: 7));
      case BillingCycle.monthly:
        return addMonths(from, 1);
      case BillingCycle.quarterly:
        return addMonths(from, 3);
      case BillingCycle.halfYearly:
        return addMonths(from, 6);
      case BillingCycle.yearly:
        return addMonths(from, 12);
      case BillingCycle.custom:
        return from.add(Duration(days: cycleDays ?? 30));
      case BillingCycle.oneTime:
        return from;
    }
  }

  /// Rolls [next] forward until it is on/after today, for subscriptions whose
  /// stored next billing date has already passed.
  static DateTime rollForward(DateTime next, BillingCycle cycle, int? cycleDays,
      {required DateTime now}) {
    if (cycle == BillingCycle.oneTime) return next;
    final today = DateTime(now.year, now.month, now.day);
    var d = next;
    var guard = 0;
    while (d.isBefore(today) && guard++ < 10000) {
      d = nextDate(d, cycle, cycleDays);
    }
    return d;
  }

  static DateTime addMonths(DateTime d, int months) {
    final totalMonths = d.year * 12 + (d.month - 1) + months;
    final year = totalMonths ~/ 12;
    final month = totalMonths % 12 + 1;
    final lastDay = DateTime(year, month + 1, 0).day;
    final day = d.day > lastDay ? lastDay : d.day;
    return DateTime(year, month, day, d.hour, d.minute);
  }

  /// Monthly-equivalent spend per classification, by currency.
  static Map<Classification, MoneyTotals> monthlyByClassification(
      Iterable<SubscriptionLike> subs) {
    final out = {for (final c in Classification.values) c: MoneyTotals()};
    for (final s in subs) {
      if (!s.status.isRecurringCost) continue;
      final m = monthlyCost(s);
      if (m != null) out[s.classification]!.add(m);
    }
    return out;
  }
}
