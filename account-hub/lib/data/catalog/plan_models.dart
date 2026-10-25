import '../../domain/enums.dart';
import '../../domain/markets.dart';
import '../../domain/money.dart';

/// Models for assets/catalog/plans.json: published subscription plans with
/// prices keyed by country (ISO-3166 alpha-2 or "default") and purchase
/// channel (web / ios / android). Nothing here is ever guessed at runtime: a
/// missing (country, channel) simply falls back, and the fallback is reported
/// so the UI can say so.
class PlanPrice {
  const PlanPrice({required this.money, this.source, this.verifiedAt});

  final Money money;
  final String? source;
  final DateTime? verifiedAt;

  factory PlanPrice.fromJson(Map<String, dynamic> j) {
    final amount = j['amount'];
    if (amount is! num) throw FormatException('Plan price amount must be a number, got $amount');
    final currency = (j['currency'] as String?)?.toUpperCase();
    if (currency == null || currency.length != 3) throw FormatException('Plan price needs a 3-letter currency, got $currency');
    return PlanPrice(
      money: Money.fromMajor(amount, currency),
      source: j['source'] as String?,
      verifiedAt: DateTime.tryParse((j['verifiedAt'] as String?) ?? ''),
    );
  }

  Map<String, dynamic> toJson() => {
        'amount': money.major,
        'currency': money.currency,
        if (source != null) 'source': source,
        if (verifiedAt != null) 'verifiedAt': verifiedAt!.toIso8601String().substring(0, 10),
      };
}

/// How closely a quote matched what was asked for.
enum PlanQuoteMatch {
  /// Price for exactly the requested country and channel.
  exact,

  /// Requested country, but the requested channel had no price; another
  /// channel's price (normally web) is shown.
  countryOtherChannel,

  /// No price on file for the country at all; the service's default (USD)
  /// price is shown. Most services bill in USD when they have no local price.
  defaultPrice,
}

class PlanQuote {
  const PlanQuote({required this.price, required this.match, required this.channel, required this.countryKey});

  final PlanPrice price;
  final PlanQuoteMatch match;

  /// Channel whose price is shown (may differ from the one requested).
  final PurchaseChannel channel;

  /// ISO country code the price came from, or "default".
  final String countryKey;

  bool get isExact => match == PlanQuoteMatch.exact;
  bool get isDefault => match == PlanQuoteMatch.defaultPrice;

  /// Short caption explaining a non-exact quote; null when exact.
  String? caption(PurchaseChannel requested) => switch (match) {
        PlanQuoteMatch.exact => null,
        PlanQuoteMatch.countryOtherChannel => 'No ${requested.shortLabel} price on file · ${channel.shortLabel} price shown',
        PlanQuoteMatch.defaultPrice => 'No local price on file · default ${price.money.currency} price',
      };
}

class ServicePlan {
  const ServicePlan({required this.id, required this.name, required this.cycle, required this.prices});

  final String id;
  final String name;
  final BillingCycle cycle;

  /// country key -> channel -> price. Country keys are upper-case ISO codes
  /// or "default". A plan sold only in some countries has no "default" entry
  /// and is hidden elsewhere rather than shown with an invented price.
  final Map<String, Map<PurchaseChannel, PlanPrice>> prices;

  static const defaultKey = 'default';

  factory ServicePlan.fromJson(Map<String, dynamic> j) {
    final id = j['id'] as String?;
    final name = j['name'] as String?;
    if (id == null || id.trim().isEmpty) throw const FormatException('Plan without id');
    if (name == null || name.trim().isEmpty) throw FormatException('Plan $id without name');
    final cycleName = j['cycle'] as String? ?? 'monthly';
    final cycle = BillingCycle.values.where((c) => c.name == cycleName).firstOrNull;
    if (cycle == null) throw FormatException('Plan $id has unknown cycle "$cycleName"');
    final prices = <String, Map<PurchaseChannel, PlanPrice>>{};
    final rawPrices = (j['prices'] as Map?)?.cast<String, dynamic>() ?? const {};
    for (final entry in rawPrices.entries) {
      final key = entry.key == defaultKey ? defaultKey : entry.key.toUpperCase();
      if (key != defaultKey && key.length != 2) throw FormatException('Plan $id has bad country key "${entry.key}"');
      final channels = <PurchaseChannel, PlanPrice>{};
      for (final ch in (entry.value as Map).cast<String, dynamic>().entries) {
        final channel = PurchaseChannel.tryParse(ch.key);
        if (channel == null) throw FormatException('Plan $id has unknown channel "${ch.key}"');
        channels[channel] = PlanPrice.fromJson((ch.value as Map).cast<String, dynamic>());
      }
      if (channels.isNotEmpty) prices[key] = channels;
    }
    if (prices.isEmpty) throw FormatException('Plan $id has no prices');
    return ServicePlan(id: id, name: name, cycle: cycle, prices: prices);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'cycle': cycle.name,
        'prices': {
          for (final e in prices.entries) e.key: {for (final c in e.value.entries) c.key.key: c.value.toJson()},
        },
      };

  /// Countries with at least one price (excluding "default").
  Iterable<String> get countries => prices.keys.where((k) => k != defaultKey);

  /// Channels with a price for [country] (ISO code or "default").
  Set<PurchaseChannel> channelsFor(String country) => prices[country.toUpperCase() == defaultKey.toUpperCase() ? defaultKey : country.toUpperCase()]?.keys.toSet() ?? const {};

  /// Resolves the best price for [country] and [channel]:
  /// 1. exact country + channel,
  /// 2. same country, web (then any other channel),
  /// 3. default price for the channel, then default web / any.
  /// Returns null when the plan is sold only in other countries (no default
  /// price exists); such plans are simply not shown for this market.
  PlanQuote? quote({required String country, required PurchaseChannel channel}) {
    final cc = country.toUpperCase();
    final local = prices[cc];
    if (local != null && local.isNotEmpty) {
      final exact = local[channel];
      if (exact != null) return PlanQuote(price: exact, match: PlanQuoteMatch.exact, channel: channel, countryKey: cc);
      final alt = _pick(local, channel);
      if (alt != null) return PlanQuote(price: alt.$2, match: PlanQuoteMatch.countryOtherChannel, channel: alt.$1, countryKey: cc);
    }
    final def = prices[defaultKey];
    if (def == null || def.isEmpty) return null;
    final exactDefault = def[channel];
    if (exactDefault != null) return PlanQuote(price: exactDefault, match: PlanQuoteMatch.defaultPrice, channel: channel, countryKey: defaultKey);
    final alt = _pick(def, channel)!;
    return PlanQuote(price: alt.$2, match: PlanQuoteMatch.defaultPrice, channel: alt.$1, countryKey: defaultKey);
  }

  static (PurchaseChannel, PlanPrice)? _pick(Map<PurchaseChannel, PlanPrice> m, PurchaseChannel requested) {
    for (final c in [PurchaseChannel.web, ...PurchaseChannel.values]) {
      if (c == requested) continue;
      final p = m[c];
      if (p != null) return (c, p);
    }
    return null;
  }
}

class ServicePlans {
  const ServicePlans({required this.platformId, required this.name, required this.plans, this.pricingUrl, this.notes});

  final String platformId;
  final String name;
  final String? pricingUrl;
  final String? notes;
  final List<ServicePlan> plans;

  factory ServicePlans.fromJson(Map<String, dynamic> j) {
    final platformId = j['platformId'] as String?;
    if (platformId == null || platformId.trim().isEmpty) throw const FormatException('Service without platformId');
    final plans = ((j['plans'] as List?) ?? const []).cast<Map<String, dynamic>>().map(ServicePlan.fromJson).toList();
    final ids = <String>{};
    for (final p in plans) {
      if (!ids.add(p.id)) throw FormatException('Duplicate plan id "${p.id}" in $platformId');
    }
    return ServicePlans(
      platformId: platformId,
      name: (j['name'] as String?) ?? platformId,
      pricingUrl: j['pricingUrl'] as String?,
      notes: j['notes'] as String?,
      plans: plans,
    );
  }

  Map<String, dynamic> toJson() => {
        'platformId': platformId,
        'name': name,
        if (pricingUrl != null) 'pricingUrl': pricingUrl,
        if (notes != null) 'notes': notes,
        'plans': plans.map((p) => p.toJson()).toList(),
      };

  /// Every country that at least one plan has a local price for.
  Set<String> get countries => {for (final p in plans) ...p.countries};

  bool hasLocalPricing(String country) => countries.contains(country.toUpperCase());

  /// Most recent verification date across all prices.
  DateTime? get lastVerifiedAt {
    DateTime? latest;
    for (final p in plans) {
      for (final byChannel in p.prices.values) {
        for (final price in byChannel.values) {
          final v = price.verifiedAt;
          if (v != null && (latest == null || v.isAfter(latest))) latest = v;
        }
      }
    }
    return latest;
  }
}

class PlanCatalogDocument {
  const PlanCatalogDocument({required this.version, required this.services, this.generatedAt});

  final int version;
  final DateTime? generatedAt;
  final List<ServicePlans> services;

  static const empty = PlanCatalogDocument(version: 0, services: []);

  factory PlanCatalogDocument.fromJson(Map<String, dynamic> j) {
    final services = ((j['services'] as List?) ?? const []).cast<Map<String, dynamic>>().map(ServicePlans.fromJson).toList();
    final ids = <String>{};
    for (final s in services) {
      if (!ids.add(s.platformId)) throw FormatException('Duplicate service "${s.platformId}" in plan catalog');
    }
    return PlanCatalogDocument(
      version: (j['version'] as num?)?.toInt() ?? 1,
      generatedAt: DateTime.tryParse((j['generatedAt'] as String?) ?? ''),
      services: services,
    );
  }

  Map<String, dynamic> toJson() => {
        'version': version,
        if (generatedAt != null) 'generatedAt': generatedAt!.toIso8601String().substring(0, 10),
        'services': services.map((s) => s.toJson()).toList(),
      };
}
