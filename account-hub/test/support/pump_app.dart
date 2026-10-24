import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:syhu_account_hub/app/app.dart';
import 'package:syhu_account_hub/app/providers.dart';
import 'package:syhu_account_hub/app/theme/app_theme.dart';
import 'package:syhu_account_hub/data/catalog/catalog_service.dart';
import 'package:syhu_account_hub/data/db/app_database.dart';
import 'package:syhu_account_hub/data/db/database_connection.dart';
import 'package:syhu_account_hub/data/secure/key_store.dart';

import 'test_bundle.dart';

/// Builds a fully wired [ProviderContainer] on an in-memory database with the
/// real catalog seeded. Dispose it with `container.dispose()` and close the db.
Future<ProviderContainer> createTestContainer({bool seedCatalog = true}) async {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  final db = openInMemoryDatabase();
  final container = ProviderContainer(overrides: [
    databaseProvider.overrideWithValue(db),
    keyStoreProvider.overrideWithValue(InMemoryKeyStore()),
    catalogServiceProvider.overrideWith((ref) => CatalogService(db, bundle: FileAssetBundle())),
  ]);
  if (seedCatalog) await container.read(catalogServiceProvider).ensureSeeded();
  return container;
}

/// Pumps the whole app (router + shell) at a desktop window size.
Future<void> pumpApp(WidgetTester tester, ProviderContainer container, {Size size = const Size(1400, 900)}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(UncontrolledProviderScope(container: container, child: const AccountHubApp()));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 300));
}

/// Pumps a single screen inside MaterialApp + theme, without the router.
Future<void> pumpScreen(WidgetTester tester, ProviderContainer container, Widget screen, {Size size = const Size(1200, 900)}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(UncontrolledProviderScope(
    container: container,
    child: MaterialApp(theme: AppTheme.dark(), home: Scaffold(body: screen)),
  ));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 300));
}

/// Drains the pending drift streams; [pumpAndSettle] cannot be used because
/// the dashboard clock and animations keep the tree "unsettled".
Future<void> settle(WidgetTester tester, [int frames = 6]) async {
  for (var i = 0; i < frames; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

AppDatabase dbOf(ProviderContainer c) => c.read(databaseProvider);

/// Runs database work with real async inside a widget test. Drift queries and
/// file I/O never complete inside the test's fake-async zone, so every await
/// on a repository from a `testWidgets` body must go through this.
Future<T> data<T>(WidgetTester tester, Future<T> Function() body) async => (await tester.runAsync(body)) as T;

/// Standard teardown: unmount the tree, then dispose container and database.
void registerTeardown(WidgetTester tester, ProviderContainer c) {
  final db = dbOf(c);
  addTearDown(() async {
    await tester.pumpWidget(const SizedBox.shrink());
    c.dispose();
    await db.close();
  });
}
