import 'package:flutter_test/flutter_test.dart';
import 'package:syhu_account_hub/core/ids.dart';
import 'package:syhu_account_hub/domain/enums.dart';
import 'package:syhu_account_hub/domain/money.dart';
import 'package:syhu_account_hub/domain/subscription_math.dart';

SubscriptionLike sub(String id, num major, String cur, BillingCycle cycle, {SubscriptionStatus status = SubscriptionStatus.active, DateTime? next, int? days, Classification cls = Classification.personal}) =>
    SubscriptionLike(id: id, price: Money.fromMajor(major, cur), cycle: cycle, cycleDays: days, status: status, nextBillingDate: next, classification: cls);

void main() {
  group('Money', () {
    test('stores minor units and formats with symbol', () {
      final m = Money.fromMajor(119, 'INR');
      expect(m.minor, 11900);
      expect(m.format(), '₹119.00');
      expect(Money.fromMajor(20, 'USD').format(), r'$20.00');
      expect(Money.fromMajor(1500, 'JPY').minor, 1500);
      expect(Money.fromMajor(1500, 'JPY').format(), '¥1,500');
    });

    test('refuses to add different currencies', () {
      expect(() => Money.fromMajor(1, 'INR') + Money.fromMajor(1, 'USD'), throwsArgumentError);
    });

    test('MoneyTotals keeps currencies separate', () {
      final t = MoneyTotals()
        ..add(Money.fromMajor(100, 'INR'))
        ..add(Money.fromMajor(50, 'INR'))
        ..add(Money.fromMajor(10, 'USD'));
      expect(t.isMixed, isTrue);
      expect(t['INR'], Money.fromMajor(150, 'INR'));
      expect(t['USD'], Money.fromMajor(10, 'USD'));
      expect(t.format(), '₹150.00 + \$10.00');
      expect(MoneyTotals().format(), '—');
    });
  });

  group('SubscriptionMath', () {
    test('monthly and annual equivalents per cycle', () {
      expect(SubscriptionMath.monthlyCost(sub('a', 1200, 'INR', BillingCycle.yearly)), Money.fromMajor(100, 'INR'));
      expect(SubscriptionMath.annualCost(sub('b', 100, 'INR', BillingCycle.monthly)), Money.fromMajor(1200, 'INR'));
      expect(SubscriptionMath.annualCost(sub('c', 10, 'USD', BillingCycle.weekly)), Money.fromMajor(520, 'USD'));
      expect(SubscriptionMath.annualCost(sub('d', 300, 'INR', BillingCycle.quarterly)), Money.fromMajor(1200, 'INR'));
      expect(SubscriptionMath.annualCost(sub('e', 600, 'INR', BillingCycle.halfYearly)), Money.fromMajor(1200, 'INR'));
      expect(SubscriptionMath.annualCost(sub('f', 100, 'INR', BillingCycle.oneTime, status: SubscriptionStatus.lifetime)), isNull);
      final custom = SubscriptionMath.annualCost(sub('g', 10, 'INR', BillingCycle.custom, days: 30));
      expect(custom!.minor, closeTo(10 * 100 * 365.25 / 30, 1));
      expect(SubscriptionMath.annualCost(sub('h', 10, 'INR', BillingCycle.custom)), isNull, reason: 'custom cycle without days is undefined');
    });

    test('totals exclude paused, cancelled, expired and lifetime', () {
      final subs = [
        sub('1', 100, 'INR', BillingCycle.monthly),
        sub('2', 100, 'INR', BillingCycle.monthly, status: SubscriptionStatus.trial),
        sub('3', 100, 'INR', BillingCycle.monthly, status: SubscriptionStatus.paused),
        sub('4', 100, 'INR', BillingCycle.monthly, status: SubscriptionStatus.cancelled),
        sub('5', 100, 'INR', BillingCycle.monthly, status: SubscriptionStatus.expired),
        sub('6', 999, 'INR', BillingCycle.oneTime, status: SubscriptionStatus.lifetime),
        sub('7', 12, 'USD', BillingCycle.yearly),
      ];
      final monthly = SubscriptionMath.monthlyTotals(subs);
      expect(monthly['INR'], Money.fromMajor(200, 'INR'));
      expect(monthly['USD'], Money.fromMajor(1, 'USD'));
      final annual = SubscriptionMath.annualTotals(subs);
      expect(annual['INR'], Money.fromMajor(2400, 'INR'));
      expect(annual['USD'], Money.fromMajor(12, 'USD'));
    });

    test('monthly by classification', () {
      final r = SubscriptionMath.monthlyByClassification([
        sub('1', 100, 'INR', BillingCycle.monthly),
        sub('2', 300, 'INR', BillingCycle.monthly, cls: Classification.business),
      ]);
      expect(r[Classification.personal]!['INR'], Money.fromMajor(100, 'INR'));
      expect(r[Classification.business]!['INR'], Money.fromMajor(300, 'INR'));
    });

    test('upcoming renewals within horizon, sorted, excluding past/inactive', () {
      final now = DateTime(2026, 10, 24, 15);
      final list = SubscriptionMath.upcoming([
        sub('soon', 1, 'INR', BillingCycle.monthly, next: DateTime(2026, 10, 27)),
        sub('today', 1, 'INR', BillingCycle.monthly, next: DateTime(2026, 10, 24)),
        sub('far', 1, 'INR', BillingCycle.monthly, next: DateTime(2026, 12, 30)),
        sub('past', 1, 'INR', BillingCycle.monthly, next: DateTime(2026, 10, 1)),
        sub('paused', 1, 'INR', BillingCycle.monthly, next: DateTime(2026, 10, 25), status: SubscriptionStatus.paused),
      ], now: now, days: 30);
      expect(list.map((s) => s.id), ['today', 'soon']);
    });

    test('next date math clamps month ends and rolls forward', () {
      expect(SubscriptionMath.nextDate(DateTime(2026, 1, 31), BillingCycle.monthly, null), DateTime(2026, 2, 28));
      expect(SubscriptionMath.nextDate(DateTime(2028, 1, 31), BillingCycle.monthly, null), DateTime(2028, 2, 29));
      expect(SubscriptionMath.nextDate(DateTime(2026, 11, 30), BillingCycle.quarterly, null), DateTime(2027, 2, 28));
      expect(SubscriptionMath.nextDate(DateTime(2026, 2, 29 - 1), BillingCycle.yearly, null), DateTime(2027, 2, 28));
      expect(SubscriptionMath.nextDate(DateTime(2026, 10, 1), BillingCycle.weekly, null), DateTime(2026, 10, 8));
      expect(SubscriptionMath.nextDate(DateTime(2026, 10, 1), BillingCycle.custom, 45), DateTime(2026, 11, 15));
      expect(SubscriptionMath.nextDate(DateTime(2026, 10, 1), BillingCycle.oneTime, null), DateTime(2026, 10, 1));
      final rolled = SubscriptionMath.rollForward(DateTime(2026, 1, 15), BillingCycle.monthly, null, now: DateTime(2026, 10, 24));
      expect(rolled, DateTime(2026, 11, 15));
      expect(SubscriptionMath.rollForward(DateTime(2026, 1, 15), BillingCycle.oneTime, null, now: DateTime(2026, 10, 24)), DateTime(2026, 1, 15));
    });
  });

  group('ids', () {
    test('email normalisation and custom platform ids', () {
      expect(normalizeEmail('  Studio@Example.COM '), 'studio@example.com');
      expect(customPlatformId('My Studio Site!'), startsWith('custom-my-studio-site-'));
      expect(customPlatformId('   '), startsWith('custom-platform-'));
      expect(newId(), isNot(newId()));
    });

    test('enumFromName falls back safely', () {
      expect(enumFromName(SubscriptionStatus.values, 'trial', SubscriptionStatus.active), SubscriptionStatus.trial);
      expect(enumFromName(SubscriptionStatus.values, 'bogus', SubscriptionStatus.active), SubscriptionStatus.active);
      expect(enumFromName(SubscriptionStatus.values, null, SubscriptionStatus.active), SubscriptionStatus.active);
    });
  });
}
