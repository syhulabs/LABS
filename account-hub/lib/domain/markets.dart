import 'money.dart';

/// A country the app can be "set to". Plan prices, the default currency and
/// the store (App Store / Google Play) pricing all follow the chosen market.
class Market {
  const Market(this.code, this.name, this.currency, this.flag);

  /// ISO-3166 alpha-2, upper case. Also the key used in plans.json.
  final String code;
  final String name;

  /// ISO-4217 currency the market bills in.
  final String currency;
  final String flag;

  String get label => '$flag $name';
  String get labelWithCurrency => '$flag $name · $currency';

  @override
  String toString() => code;
}

/// One market per supported currency (EUR is represented by Germany). Order
/// mirrors [supportedCurrencies] so pickers feel consistent.
const markets = <Market>[
  Market('IN', 'India', 'INR', '🇮🇳'),
  Market('US', 'United States', 'USD', '🇺🇸'),
  Market('DE', 'Germany (Euro)', 'EUR', '🇩🇪'),
  Market('GB', 'United Kingdom', 'GBP', '🇬🇧'),
  Market('MY', 'Malaysia', 'MYR', '🇲🇾'),
  Market('ID', 'Indonesia', 'IDR', '🇮🇩'),
  Market('PH', 'Philippines', 'PHP', '🇵🇭'),
  Market('SG', 'Singapore', 'SGD', '🇸🇬'),
  Market('TH', 'Thailand', 'THB', '🇹🇭'),
  Market('VN', 'Vietnam', 'VND', '🇻🇳'),
  Market('AE', 'United Arab Emirates', 'AED', '🇦🇪'),
  Market('SA', 'Saudi Arabia', 'SAR', '🇸🇦'),
  Market('QA', 'Qatar', 'QAR', '🇶🇦'),
  Market('JP', 'Japan', 'JPY', '🇯🇵'),
  Market('KR', 'South Korea', 'KRW', '🇰🇷'),
  Market('CN', 'China', 'CNY', '🇨🇳'),
  Market('HK', 'Hong Kong', 'HKD', '🇭🇰'),
  Market('AU', 'Australia', 'AUD', '🇦🇺'),
  Market('NZ', 'New Zealand', 'NZD', '🇳🇿'),
  Market('CA', 'Canada', 'CAD', '🇨🇦'),
  Market('CH', 'Switzerland', 'CHF', '🇨🇭'),
  Market('SE', 'Sweden', 'SEK', '🇸🇪'),
  Market('NO', 'Norway', 'NOK', '🇳🇴'),
  Market('DK', 'Denmark', 'DKK', '🇩🇰'),
  Market('PL', 'Poland', 'PLN', '🇵🇱'),
  Market('TR', 'Türkiye', 'TRY', '🇹🇷'),
  Market('BR', 'Brazil', 'BRL', '🇧🇷'),
  Market('MX', 'Mexico', 'MXN', '🇲🇽'),
  Market('ZA', 'South Africa', 'ZAR', '🇿🇦'),
];

const defaultMarket = Market('IN', 'India', 'INR', '🇮🇳');

Market? marketByCode(String? code) {
  if (code == null) return null;
  final c = code.toUpperCase();
  for (final m in markets) {
    if (m.code == c) return m;
  }
  return null;
}

/// First market billing in [currency]; falls back to [defaultMarket].
Market marketForCurrency(String currency) {
  final c = currency.toUpperCase();
  for (final m in markets) {
    if (m.currency == c) return m;
  }
  return defaultMarket;
}

/// Where a subscription is bought. Stores often charge more than the web price
/// in the same country, so a quote is always keyed by (country, channel).
enum PurchaseChannel {
  web,
  ios,
  android;

  String get label => switch (this) {
        PurchaseChannel.web => 'Web / direct',
        PurchaseChannel.ios => 'App Store (iOS)',
        PurchaseChannel.android => 'Google Play (Android)',
      };

  String get shortLabel => switch (this) {
        PurchaseChannel.web => 'Web',
        PurchaseChannel.ios => 'iOS',
        PurchaseChannel.android => 'Android',
      };

  /// Key used in plans.json.
  String get key => name;

  static PurchaseChannel? tryParse(String? v) {
    if (v == null) return null;
    for (final c in values) {
      if (c.name == v.toLowerCase()) return c;
    }
    return null;
  }
}
