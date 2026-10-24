import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:syhu_account_hub/data/db/app_database.dart';
import 'package:syhu_account_hub/data/repositories/account_repository.dart';
import 'package:syhu_account_hub/data/repositories/audit_repository.dart';
import 'package:syhu_account_hub/data/repositories/email_repository.dart';
import 'package:syhu_account_hub/data/repositories/platform_repository.dart';
import 'package:drift/drift.dart' show Value;

/// Proves data survives a full close/re-open of the on-disk database file,
/// which is what "persist across restarts" means for the app.
void main() {
  test('rows written before close are read back by a fresh database instance', () async {
    final dir = await Directory.systemTemp.createTemp('syhu_persist');
    final file = File('${dir.path}/hub.sqlite');

    var db = AppDatabase(NativeDatabase(file));
    final audit = AuditRepository(db);
    await db.into(db.platforms).insert(PlatformsCompanion.insert(id: 'github', name: 'GitHub', categories: '["developer"]', website: const Value('https://github.com')));
    final email = await EmailRepository(db, audit).upsert(address: 'dev@syhu.example');
    final acc = await AccountRepository(db, audit).upsert(platformId: 'github', emailIdentityId: email.id, accountName: 'Main', username: 'syhu');
    await PlatformRepository(db, audit).setFavorite('github', true);
    await db.close();

    db = AppDatabase(NativeDatabase(file));
    final accounts = await AccountRepository(db, AuditRepository(db)).watchAll().first;
    expect(accounts.single.account.id, acc.id);
    expect(accounts.single.email!.address, 'dev@syhu.example');
    expect(accounts.single.platform.isFavorite, isTrue);
    expect(accounts.single.platform.inMyWorld, isTrue);
    final fk = await db.customSelect('PRAGMA foreign_keys').getSingle();
    expect(fk.data.values.first, 1, reason: 'foreign keys are enforced on every open');
    await db.close();
    await dir.delete(recursive: true);
  });

  test('schema version is recorded and migration hook runs on open', () async {
    final dir = await Directory.systemTemp.createTemp('syhu_schema');
    final db = AppDatabase(NativeDatabase(File('${dir.path}/hub.sqlite')));
    await db.customSelect('SELECT 1').get();
    final v = await db.customSelect('PRAGMA user_version').getSingle();
    expect(v.data.values.first, db.schemaVersion);
    final tables = await db.customSelect("SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%'").get();
    expect(tables.length, 22);
    await db.close();
    await dir.delete(recursive: true);
  });
}
