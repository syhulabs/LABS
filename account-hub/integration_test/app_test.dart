// End-to-end test on a real device/desktop build:
//   flutter test integration_test -d macos   (or -d linux / -d android / -d ios)
// Uses the real on-disk database and keychain-backed key store.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:syhu_account_hub/app/app.dart';
import 'package:syhu_account_hub/app/bootstrap.dart';
import 'package:syhu_account_hub/app/providers.dart';
import 'package:syhu_account_hub/data/db/database_connection.dart';
import 'package:syhu_account_hub/data/secure/key_store.dart';
import 'package:syhu_account_hub/shared/widgets/app_card.dart';

void step(String name, WidgetTester t) {
  final texts = t.widgetList<Text>(find.byType(Text)).map((w) => w.data).whereType<String>().where((x) => x.trim().isNotEmpty).take(60).toList();
  // ignore: avoid_print
  print('STEP $name :: ${texts.join(' | ')}');
}

Future<void> settle(WidgetTester t, [int frames = 8]) async {
  for (var i = 0; i < frames; i++) {
    await t.pump(const Duration(milliseconds: 120));
  }
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late ProviderContainer container;

  setUpAll(() async {
    container = ProviderContainer(overrides: [
      databaseProvider.overrideWithValue(openAppDatabase()),
      keyStoreProvider.overrideWithValue(SecureKeyStore()),
    ]);
    await container.read(databaseProvider).clearAll();
    await bootstrap(container, notifications: false);
  });

  tearDownAll(() async {
    await container.read(databaseProvider).clearAll();
    container.dispose();
  });

  testWidgets('add a platform from Explore, create an account, find it with search', (tester) async {
    await tester.pumpWidget(UncontrolledProviderScope(container: container, child: const AccountHubApp()));
    await settle(tester, 15);
    step('home', tester);
    expect(find.text('My World is empty'), findsOneWidget);

    await tester.tap(find.text('Explore').first);
    await settle(tester);
    await tester.enterText(find.byType(TextField).first, 'GitHub');
    await settle(tester, 12);
    step('explore-searched', tester);
    expect(find.text('GitHub'), findsWidgets, reason: 'Explore should list GitHub after searching');
    final card = find.ancestor(of: find.text('GitHub').first, matching: find.byType(AppCard));
    step('card-found=${card.evaluate().length}', tester);
    final addButton = card.evaluate().isEmpty ? find.widgetWithText(FilledButton, 'Add').first : find.descendant(of: card.first, matching: find.widgetWithText(FilledButton, 'Add')).first;
    await tester.tap(addButton);
    await settle(tester, 12);
    step('after-add', tester);
    final mine = await container.read(platformRepositoryProvider).watchMyWorld().first;
    expect(mine.map((p) => p.name), contains('GitHub'), reason: 'Add must put GitHub in My World (got: ${mine.map((p) => p.name).toList()})');

    await tester.tap(find.text('My World').first);
    await settle(tester);
    step('my-world', tester);
    expect(find.text('GitHub'), findsWidgets);
    expect(find.text('No accounts yet'), findsOneWidget);

    // Open the platform and add an account through the real form.
    await tester.tap(find.text('GitHub').first);
    await settle(tester);
    await tester.tap(find.text('Add account').first);
    await settle(tester);
    await tester.enterText(find.widgetWithText(TextFormField, 'Account label'), 'Studio');
    await tester.enterText(find.widgetWithText(TextFormField, 'Username / handle'), 'syhu-labs');
    await tester.tap(find.widgetWithText(FilledButton, 'Save'));
    await settle(tester);
    expect(find.textContaining('Studio'), findsWidgets);

    final accounts = await container.read(accountRepositoryProvider).watchAll().first;
    expect(accounts.single.account.username, 'syhu-labs');
    expect(accounts.single.platform.id, 'github');

    // Global search palette (Cmd+K) finds the new account.
    await tester.tap(find.text('Search platforms, accounts, or anything…'));
    await settle(tester);
    await tester.enterText(find.byType(TextField).last, 'syhu');
    await settle(tester, 12);
    expect(find.textContaining('GitHub · Studio'), findsOneWidget);
  });
}
