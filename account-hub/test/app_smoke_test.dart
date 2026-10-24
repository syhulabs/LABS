import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:syhu_account_hub/app/providers.dart';
import 'package:syhu_account_hub/features/explore/explore_screen.dart';
import 'package:syhu_account_hub/features/home/home_screen.dart';
import 'package:syhu_account_hub/features/my_world/my_world_screen.dart';

import 'support/pump_app.dart';

void main() {
  testWidgets('app boots to Home with zero counts and no fabricated data', (tester) async {
    final c = (await tester.runAsync(createTestContainer))!;
    registerTeardown(tester, c);
    await pumpApp(tester, c);
    await settle(tester);
    expect(find.text('SYHU Account Hub'), findsWidgets);
    expect(find.text('Email identities'), findsOneWidget);
    expect(find.text('My World is empty'), findsOneWidget);
    // Stat cards show zeros, never sample numbers.
    expect(find.text('0'), findsWidgets);
    expect(find.text('127'), findsNothing);
  });

  testWidgets('sidebar navigates to Explore and My World', (tester) async {
    final c = (await tester.runAsync(createTestContainer))!;
    registerTeardown(tester, c);
    await pumpApp(tester, c);
    await settle(tester);
    await tester.tap(find.text('Explore').first);
    await settle(tester);
    expect(find.byType(ExploreScreen), findsOneWidget);
    expect(find.textContaining('platforms. Nothing is added'), findsOneWidget);
    await tester.tap(find.text('My World').first);
    await settle(tester);
    expect(find.byType(MyWorldScreen), findsOneWidget);
    expect(find.text('Build your world'), findsOneWidget);
  });

  testWidgets('Explore: Add puts a platform in My World; browsing does not', (tester) async {
    final c = (await tester.runAsync(createTestContainer))!;
    registerTeardown(tester, c);
    await pumpScreen(tester, c, const ExploreScreen());
    await settle(tester);
    await tester.enterText(find.byType(TextField).first, 'Claude');
    await settle(tester);
    expect(await data(tester, () => c.read(platformRepositoryProvider).watchMyWorld().first), isEmpty);
    final addButtons = find.widgetWithText(FilledButton, 'Add');
    expect(addButtons, findsWidgets);
    await tester.tap(addButtons.first);
    await settle(tester);
    final mine = await data(tester, () => c.read(platformRepositoryProvider).watchMyWorld().first);
    expect(mine.length, 1);
    expect(find.text('In My World'), findsWidgets);
  });

  testWidgets('Home renders customize dashboard dialog', (tester) async {
    final c = (await tester.runAsync(createTestContainer))!;
    registerTeardown(tester, c);
    await pumpScreen(tester, c, const HomeScreen());
    await settle(tester);
    await tester.tap(find.text('Customize dashboard'));
    await settle(tester);
    expect(find.text('Upcoming renewals'), findsWidgets);
    expect(find.text('Quick actions'), findsWidgets);
  });
}
