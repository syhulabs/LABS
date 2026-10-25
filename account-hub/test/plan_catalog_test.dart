import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:syhu_account_hub/data/catalog/plan_catalog_service.dart';
import 'package:syhu_account_hub/data/catalog/plan_models.dart';
import 'package:syhu_account_hub/data/db/database_connection.dart';
import 'package:syhu_account_hub/data/repositories/settings_repository.dart';
import 'package:syhu_account_hub/domain/enums.dart';
import 'package:syhu_account_hub/domain/markets.dart';
import 'package:syhu_account_hub/domain/money.dart';

import 'support/test_bundle.dart';

const _fixture = '''
{
  "version": 3,
  "generatedAt": "2026-10-25",
  "services": [
    {
      "platformId": "spotify",
      "name": "Spotify",
      "pricingUrl": "https://www.spotify.com/premium/",
      "plans": [
        {
          "id": "individual",
          "name": "Premium Individual",
          "cycle": "monthly",
          "prices": {
            "default": {"web": {"amount": 11.99, "currency": "USD", "source": "https://s", "verifiedAt": "2026-10-25"}},
            "IN": {
              "web": {"amount": 119, "currency": "INR", "source": "https://s", "verifiedAt": "2026-10-20"},
              "ios": {"amount": 129, "currency": "INR", "source": "https://a", "verifiedAt": "2026-10-25"}
            },
            "JP": {"web": {"amount": 980, "currency": "JPY", "source": "https://s"}}
          }
        },
        {
          "id": "family-yearly",
          "name": "Premium Family",
          "cycle": "yearly",
          "prices": {"default": {"web": {"amount": 199.99, "currency": "USD", "source": "https://s"}}}
        }
      ]
    }
  ]
}
''';

void main() {
  group('markets', () {
    test('one market per supported currency, unique codes', () {
      expect(markets.map((m) => m.code).toSet().length, markets.length);
      for (final cur in supportedCurrencies) {
        expect(markets.any((m) => m.currency == cur), isTrue, reason: '$cur has no market');
      }
      expect(marketForCurrency('EUR').code, 'DE');
      expect(marketForCurrency('XXX'), defaultMarket);
      expect(marketByCode('my')?.name, 'Malaysia');
      expect(marketByCode('ZZ'), isNull);
    });

    test('settings derive market from currency until a country is chosen', () {
      expect(<String, dynamic>{SettingsRepository.kDefaultCurrency: 'MYR'}.market.code, 'MY');
      expect(<String, dynamic>{SettingsRepository.kDefaultCurrency: 'MYR', SettingsRepository.kCountry: 'SG'}.country, 'SG');
      expect(<String, dynamic>{}.purchaseChannel, PurchaseChannel.web);
      expect(<String, dynamic>{SettingsRepository.kPurchaseChannel: 'ios'}.purchaseChannel, PurchaseChannel.ios);
      expect(PurchaseChannel.tryParse('bogus'), isNull);
    });
  });

  group('plan catalog models', () {
    final doc = PlanCatalogDocument.fromJson(jsonDecode(_fixture) as Map<String, dynamic>);
    final spotify = doc.services.single;
    final individual = spotify.plans.first;

    test('parses document', () {
      expect(doc.version, 3);
      expect(doc.generatedAt, DateTime(2026, 10, 25));
      expect(spotify.platformId, 'spotify');
      expect(individual.cycle, BillingCycle.monthly);
      expect(spotify.plans[1].cycle, BillingCycle.yearly);
      expect(spotify.countries, {'IN', 'JP'});
      expect(spotify.hasLocalPricing('in'), isTrue);
      expect(spotify.hasLocalPricing('US'), isFalse);
      expect(spotify.lastVerifiedAt, DateTime(2026, 10, 25));
      expect(individual.channelsFor('IN'), {PurchaseChannel.web, PurchaseChannel.ios});
      expect(individual.prices['JP']![PurchaseChannel.web]!.money, Money.fromMajor(980, 'JPY'));
    });

    test('quote: exact country + channel', () {
      final q = individual.quote(country: 'IN', channel: PurchaseChannel.ios)!;
      expect(q.match, PlanQuoteMatch.exact);
      expect(q.price.money, Money.fromMajor(129, 'INR'));
      expect(q.channel, PurchaseChannel.ios);
      expect(q.countryKey, 'IN');
      expect(q.caption(PurchaseChannel.ios), isNull);
    });

    test('quote: country without that channel falls back to web price', () {
      final q = individual.quote(country: 'in', channel: PurchaseChannel.android)!;
      expect(q.match, PlanQuoteMatch.countryOtherChannel);
      expect(q.price.money, Money.fromMajor(119, 'INR'));
      expect(q.channel, PurchaseChannel.web);
      expect(q.caption(PurchaseChannel.android), contains('Web price shown'));
    });

    test('quote: web request in a country with store-only prices uses the default web price', () {
      final doc = PlanCatalogDocument.fromJson(jsonDecode('{"services":[{"platformId":"claude","plans":[{"id":"pro","name":"Pro","prices":{"default":{"web":{"amount":20,"currency":"USD","source":"https://s"}},"IN":{"ios":{"amount":1999,"currency":"INR","source":"https://a"}}}}]}]}') as Map<String, dynamic>);
      final pro = doc.services.single.plans.single;
      final web = pro.quote(country: 'IN', channel: PurchaseChannel.web)!;
      expect(web.match, PlanQuoteMatch.defaultPrice);
      expect(web.price.money, Money.fromMajor(20, 'USD'));
      final android = pro.quote(country: 'IN', channel: PurchaseChannel.android)!;
      expect(android.match, PlanQuoteMatch.countryOtherChannel, reason: 'a store request prefers the local store price over USD');
      expect(android.price.money, Money.fromMajor(1999, 'INR'));
      expect(android.channel, PurchaseChannel.ios);
    });

    test('quote: unknown country falls back to default USD', () {
      final q = individual.quote(country: 'MY', channel: PurchaseChannel.ios)!;
      expect(q.match, PlanQuoteMatch.defaultPrice);
      expect(q.isDefault, isTrue);
      expect(q.price.money, Money.fromMajor(11.99, 'USD'));
      expect(q.countryKey, ServicePlan.defaultKey);
      expect(q.caption(PurchaseChannel.ios), contains('default USD'));
    });

    test('country-only plan is hidden elsewhere instead of priced in USD', () {
      final doc = PlanCatalogDocument.fromJson(jsonDecode('{"services":[{"platformId":"netflix","plans":[{"id":"mobile","name":"Mobile","prices":{"IN":{"web":{"amount":149,"currency":"INR","source":"https://s"}}}}]}]}') as Map<String, dynamic>);
      final mobile = doc.services.single.plans.single;
      expect(mobile.quote(country: 'IN', channel: PurchaseChannel.android)!.price.money, Money.fromMajor(149, 'INR'));
      expect(mobile.quote(country: 'US', channel: PurchaseChannel.web), isNull);
    });

    test('round-trips through toJson', () {
      final again = PlanCatalogDocument.fromJson(doc.toJson());
      expect(again.services.single.plans.first.quote(country: 'IN', channel: PurchaseChannel.ios)!.price.money, Money.fromMajor(129, 'INR'));
      expect(again.services.single.plans.first.prices['IN']![PurchaseChannel.web]!.verifiedAt, DateTime(2026, 10, 20));
    });

    test('rejects malformed documents', () {
      PlanCatalogDocument parse(String s) => PlanCatalogDocument.fromJson(jsonDecode(s) as Map<String, dynamic>);
      expect(() => parse('{"services":[{"platformId":"a","plans":[{"id":"p","name":"P","prices":{}}]}]}'), throwsFormatException, reason: 'no prices at all');
      expect(() => parse('{"services":[{"platformId":"a","plans":[{"id":"p","name":"P","cycle":"fortnightly","prices":{"default":{"web":{"amount":1,"currency":"USD"}}}}]}]}'), throwsFormatException, reason: 'bad cycle');
      expect(() => parse('{"services":[{"platformId":"a","plans":[{"id":"p","name":"P","prices":{"default":{"steam":{"amount":1,"currency":"USD"}}}}]}]}'), throwsFormatException, reason: 'bad channel');
      expect(() => parse('{"services":[{"platformId":"a","plans":[{"id":"p","name":"P","prices":{"default":{"web":{"amount":"1","currency":"USD"}}}}]}]}'), throwsFormatException, reason: 'string amount');
      expect(() => parse('{"services":[{"platformId":"a","plans":[]},{"platformId":"a","plans":[]}]}'), throwsFormatException, reason: 'duplicate service');
      expect(() => parse('{"services":[{"platformId":"a","plans":[{"id":"p","name":"P","prices":{"default":{"web":{"amount":1,"currency":"USD"}}}},{"id":"p","name":"Q","prices":{"default":{"web":{"amount":1,"currency":"USD"}}}}]}]}'), throwsFormatException, reason: 'duplicate plan');
    });
  });

  group('PlanCatalogService', () {
    test('loads bundled file, imports an override, clears it', () async {
      final db = openInMemoryDatabase();
      addTearDown(db.close);
      final svc = PlanCatalogService(db, bundle: FileAssetBundle());
      await svc.load();
      expect(svc.isLoaded, isTrue);
      final bundledCount = svc.serviceCount;
      final n = await svc.importFromJsonString(_fixture);
      expect(n, 1);
      expect(svc.plansFor('spotify')!.plans.first.quote(country: 'IN', channel: PurchaseChannel.ios)!.price.money, Money.fromMajor(129, 'INR'));
      expect(svc.serviceCount, greaterThanOrEqualTo(bundledCount));
      // The blob never leaks into the reactive settings map.
      final settings = await SettingsRepository(db).watchAll().first;
      expect(settings.keys.any((k) => k.startsWith('blob.')), isFalse);
      // Survives a reload (it is persisted) and disappears when cleared.
      final svc2 = PlanCatalogService(db, bundle: FileAssetBundle());
      await svc2.load();
      expect(svc2.imported, isNotNull);
      await svc2.clearImported();
      expect(svc2.imported, isNull);
      expect(svc2.serviceCount, bundledCount);
    });

    test('bundled Gemini Ultra India quotes differ by store', () async {
      final raw = await File('assets/catalog/plans.json').readAsString();
      final doc = PlanCatalogDocument.fromJson(jsonDecode(raw) as Map<String, dynamic>);
      final ultra = doc.services.firstWhere((s) => s.platformId == 'gemini').plans.firstWhere((p) => p.id == 'ai-ultra-monthly');
      final ios = ultra.quote(country: 'IN', channel: PurchaseChannel.ios)!;
      final android = ultra.quote(country: 'IN', channel: PurchaseChannel.android)!;
      expect(ios.isExact && android.isExact, isTrue);
      expect(ios.price.money, Money.fromMajor(8900, 'INR'));
      expect(android.price.money, Money.fromMajor(6500, 'INR'));
      expect(ios.price.isObserved, isTrue);
    });

    test('bundled plans.json is valid and only references catalog platforms', () async {
      final raw = await File('assets/catalog/plans.json').readAsString();
      final doc = PlanCatalogDocument.fromJson(jsonDecode(raw) as Map<String, dynamic>);
      final platforms = (jsonDecode(await File('assets/catalog/platforms.json').readAsString()) as Map<String, dynamic>)['platforms'] as List;
      final ids = {for (final p in platforms) (p as Map)['id'] as String};
      final marketCurrency = {for (final m in markets) m.code: m.currency};
      for (final s in doc.services) {
        expect(ids, contains(s.platformId), reason: '${s.platformId} is not in platforms.json');
        expect(s.plans, isNotEmpty);
        for (final p in s.plans) {
          for (final country in p.prices.keys) {
            if (country == ServicePlan.defaultKey) continue;
            expect(marketCurrency, contains(country), reason: '${s.platformId}/${p.id}: $country is not a supported market');
            for (final price in p.prices[country]!.values) {
              expect([marketCurrency[country], 'USD', 'EUR'], contains(price.money.currency), reason: '${s.platformId}/${p.id}/$country billed in wrong currency');
              expect(price.source!.startsWith('http') || price.source!.startsWith('observed:'), isTrue, reason: '${s.platformId}/${p.id}/$country has no source');
              expect(price.money.minor, greaterThanOrEqualTo(0));
            }
          }
        }
      }
    });
  });
}
