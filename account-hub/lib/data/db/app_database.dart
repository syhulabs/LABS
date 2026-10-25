import 'package:drift/drift.dart';

import 'tables.dart';

export 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [
  Platforms,
  EmailIdentities,
  ServiceAccounts,
  YoutubeChannels,
  ChannelManagers,
  Organizations,
  Artists,
  Projects,
  Links,
  Tags,
  TagLinks,
  CustomFields,
  BankAccounts,
  PaymentCards,
  PaymentMethods,
  Subscriptions,
  SubscriptionEvents,
  CredentialReferences,
  DocumentReferences,
  SecureItems,
  AuditEvents,
  Settings,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  /// Bump when tables change and add a step in [migration].
  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            // v2: subscriptions remember which store they are billed through.
            await m.addColumn(subscriptions, subscriptions.purchaseChannel);
          }
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  /// Deletes every row in every table (used by restore). Order respects FKs.
  Future<void> clearAll() async {
    // PRAGMA foreign_keys is a no-op inside a transaction, so toggle outside.
    await customStatement('PRAGMA foreign_keys = OFF');
    try {
      await transaction(() async {
        for (final t in allTables.toList().reversed) {
          await delete(t).go();
        }
      });
    } finally {
      await customStatement('PRAGMA foreign_keys = ON');
    }
  }
}
