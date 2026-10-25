import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syhu_account_hub/app/providers.dart';
import 'package:syhu_account_hub/domain/markets.dart';
import 'package:syhu_account_hub/features/platform/platform_detail_screen.dart';
import 'package:syhu_account_hub/features/subscriptions/subscription_form.dart';

import '../support/pump_app.dart';

void main() {
  test('editing an old subscription never stamps a store on it', () {
    expect(initialPurchaseChannel(isExisting: true, stored: null, usual: PurchaseChannel.web), isNull);
    expect(initialPurchaseChannel(isExisting: true, stored: 'ios', usual: PurchaseChannel.web), PurchaseChannel.ios);
    expect(initialPurchaseChannel(isExisting: false, usual: PurchaseChannel.android), PurchaseChannel.android);
    expect(initialPurchaseChannel(isExisting: false, preset: PurchaseChannel.ios, usual: PurchaseChannel.web), PurchaseChannel.ios);
  });

  testWidgets('platform plans card fits a 360px phone and re-quotes per store', (tester) async {
    final c = (await tester.runAsync(createTestContainer))!;
    registerTeardown(tester, c);
    await pumpScreen(tester, c, const PlatformDetailScreen(platformId: 'gemini'), size: const Size(360, 2400));
    await settle(tester);
    expect(tester.takeException(), isNull, reason: 'no layout overflow at phone width');
    expect(find.text('Plans in India'), findsOneWidget);
    expect(find.textContaining('India prices on file for'), findsOneWidget);
    expect(find.text('₹6,500.00'), findsOneWidget, reason: 'web price for AI Ultra');
    await tester.tap(find.text('iOS').first);
    await settle(tester);
    expect(find.text('₹8,900.00'), findsOneWidget, reason: 'App Store price for AI Ultra');
    await tester.tap(find.text('Android').first);
    await settle(tester);
    expect(find.text('₹6,500.00'), findsOneWidget, reason: 'Google Play price for AI Ultra');
    expect(tester.takeException(), isNull);
  });

  testWidgets('new subscription offers plans on a cold start and fills the picked store price', (tester) async {
    final c = (await tester.runAsync(createTestContainer))!;
    registerTeardown(tester, c);
    final gemini = (await data(tester, () => c.read(platformRepositoryProvider).watchById('gemini').first))!;
    await pumpScreen(
      tester,
      c,
      Consumer(builder: (context, ref, _) => FilledButton(onPressed: () => showSubscriptionForm(context, ref, presetPlatform: gemini), child: const Text('open'))),
      size: const Size(360, 2400),
    );
    await tester.tap(find.text('open'));
    await settle(tester);
    expect(find.text('Choose a plan (IN)'), findsOneWidget, reason: 'button must show even though nothing read the plan provider first');
    await tester.tap(find.text('Choose a plan (IN)'));
    await settle(tester);
    expect(tester.takeException(), isNull, reason: 'plan sheet header fits at 360px');
    await tester.tap(find.text('iOS').last);
    await settle(tester);
    await tester.tap(find.text('₹8,900.00'));
    await settle(tester);
    expect(find.widgetWithText(TextFormField, '8900.00'), findsOneWidget);
    expect(find.text('Google AI Ultra'), findsOneWidget, reason: 'plan name filled');
  });
}
