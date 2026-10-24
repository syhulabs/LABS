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
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
        },
        onUpgrade: (m, from, to) async {
          // Future schema steps go here, e.g.
          // if (from < 2) await m.addColumn(subscriptions, subscriptions.foo);
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
