import 'package:intl/intl.dart';

/// An amount in the minor unit of a currency (paise, cents...). Immutable.
///
/// Amounts in different currencies are never added together implicitly; see
/// [MoneyTotals].
class Money implements Comparable<Money> {
  const Money(this.minor, this.currency);

  final int minor;
  final String currency;

  static const _zeroDecimalCurrencies = {'JPY', 'KRW', 'VND', 'CLP', 'ISK'};

  int get fractionDigits => _zeroDecimalCurrencies.contains(currency) ? 0 : 2;

  double get major => minor / (fractionDigits == 0 ? 1 : 100);

  static Money fromMajor(num value, String currency) {
    final digits = _zeroDecimalCurrencies.contains(currency) ? 0 : 2;
    return Money((value * (digits == 0 ? 1 : 100)).round(), currency);
  }

  Money operator +(Money other) {
    if (other.currency != currency) {
      throw ArgumentError('Cannot add $currency and ${other.currency}');
    }
    return Money(minor + other.minor, currency);
  }

  Money scaled(double factor) => Money((minor * factor).round(), currency);

  String format({bool compact = false}) {
    final symbol = currencySymbol(currency);
    final fmt = compact
        ? NumberFormat.compactCurrency(symbol: symbol, decimalDigits: 0)
        : NumberFormat.currency(symbol: symbol, decimalDigits: fractionDigits);
    return fmt.format(major);
  }

  static String currencySymbol(String code) => switch (code) {
        'INR' => '₹',
        'USD' => r'$',
        'EUR' => '€',
        'GBP' => '£',
        'JPY' => '¥',
        'AUD' => r'A$',
        'CAD' => r'C$',
        'SGD' => r'S$',
        'AED' => 'AED ',
        _ => '$code ',
      };

  @override
  int compareTo(Money other) => minor.compareTo(other.minor);

  @override
  bool operator ==(Object other) =>
      other is Money && other.minor == minor && other.currency == currency;

  @override
  int get hashCode => Object.hash(minor, currency);

  @override
  String toString() => '$currency $minor';
}

/// Per-currency totals. Never collapses currencies into a single number.
class MoneyTotals {
  MoneyTotals([Map<String, Money>? initial])
      : _byCurrency = {...?initial};

  final Map<String, Money> _byCurrency;

  void add(Money m) {
    final existing = _byCurrency[m.currency];
    _byCurrency[m.currency] = existing == null ? m : existing + m;
  }

  bool get isEmpty => _byCurrency.isEmpty;
  bool get isMixed => _byCurrency.length > 1;
  List<Money> get values => _byCurrency.values.toList()
    ..sort((a, b) => a.currency.compareTo(b.currency));
  Money? operator [](String currency) => _byCurrency[currency];

  /// e.g. "₹2,340.00 + $12.00"
  String format({bool compact = false}) =>
      isEmpty ? '—' : values.map((m) => m.format(compact: compact)).join(' + ');
}

const supportedCurrencies = <String>[
  'INR', 'USD', 'EUR', 'GBP', 'JPY', 'AUD', 'CAD', 'SGD', 'AED',
];
