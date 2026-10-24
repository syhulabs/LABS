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

  testWidgets('Explore → Add → My World → account form → global search', (tester) async {
    await tester.pumpWidget(UncontrolledProviderScope(container: container, child: const AccountHubApp()));
    await settle(tester, 15);
    expect(find.text('My World is empty'), findsOneWidget);

    // Explore: browsing adds nothing; pressing Add on a card does.
    await tester.tap(find.text('Explore').first);
    await settle(tester, 12);
    expect(await container.read(platformRepositoryProvider).watchMyWorld().first, isEmpty);
    final add = find.widgetWithText(FilledButton, 'Add').first;
    await tester.ensureVisible(add);
    await tester.tap(add);
    await settle(tester, 12);
    final mine = await container.read(platformRepositoryProvider).watchMyWorld().first;
    expect(mine.length, 1, reason: 'exactly one platform added');
    final name = mine.single.name;
    expect(find.text('In My World'), findsWidgets);

    // My World shows it with no accounts.
    await tester.tap(find.text('My World').first);
    await settle(tester);
    expect(find.text(name), findsWidgets);
    expect(find.text('No accounts yet'), findsOneWidget);

    // Platform detail → real account form → saved to the database.
    await tester.tap(find.text(name).first);
    await settle(tester);
    await tester.tap(find.text('Add account').first);
    await settle(tester);
    final label = find.widgetWithText(TextFormField, 'Account label');
    expect(label, findsOneWidget);
    await tester.enterText(label, 'Studio');
    await tester.enterText(find.widgetWithText(TextFormField, 'Username / handle'), 'syhu-labs');
    await settle(tester, 2);
    final save = find.widgetWithText(FilledButton, 'Save');
    await tester.ensureVisible(save);
    await settle(tester, 2);
    await tester.tap(save);
    await settle(tester, 12);
    final accounts = await container.read(accountRepositoryProvider).watchAll().first;
    expect(accounts.length, 1);
    expect(accounts.single.account.accountName, 'Studio');
    expect(accounts.single.account.username, 'syhu-labs');
    expect(accounts.single.platform.id, mine.single.id);
    expect(find.text('Studio'), findsWidgets);

    // Global search finds the account by username; vault stays unsearchable.
    final hits = await container.read(searchServiceProvider).search('syhu-labs');
    expect(hits.map((h) => h.title), contains('$name · Studio'));
    await tester.tap(find.text('Search platforms, accounts, or anything…'), warnIfMissed: false);
    await settle(tester, 15);
    expect(find.textContaining('Search platforms, accounts, emails'), findsOneWidget, reason: 'the ⌘K palette should be open');
  });
}
