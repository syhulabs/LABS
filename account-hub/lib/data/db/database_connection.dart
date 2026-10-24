import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'app_database.dart';

/// Opens the on-disk database in the platform's application-support directory
/// (not Documents, so it is never casually exposed in file pickers).
AppDatabase openAppDatabase() {
  return AppDatabase(
    driftDatabase(
      name: 'syhu_account_hub',
      native: DriftNativeOptions(
        databaseDirectory: getApplicationSupportDirectory,
      ),
    ),
  );
}

/// In-memory database for tests and previews.
AppDatabase openInMemoryDatabase() =>
    AppDatabase(NativeDatabase.memory(logStatements: false));

/// Returns the absolute path of the database file (for "Show in Finder" and
/// local backups).
Future<String> databaseFilePath() async {
  final dir = await getApplicationSupportDirectory();
  return '${dir.path}/syhu_account_hub.sqlite';
}

// Keep the import used on all platforms.
// ignore: unused_element
final _ = QueryExecutor;
