import 'dart:convert';

import 'package:drift/drift.dart';

import '../../domain/enums.dart';
import '../db/app_database.dart';
import '../repositories/audit_repository.dart';
import '../secure/crypto_service.dart';
import '../secure/vault_repository.dart';

class BackupSummary {
  const BackupSummary({required this.createdAt, required this.schemaVersion, required this.rowCounts, required this.includesVault, required this.appVersion});
  final DateTime createdAt;
  final int schemaVersion;
  final Map<String, int> rowCounts;
  final bool includesVault;
  final String appVersion;
  int get totalRows => rowCounts.values.fold(0, (a, b) => a + b);
}

/// Backup, restore and metadata export.
///
/// * Plain backup: every table except `secure_items` (vault payloads never
///   leave the device unencrypted). Audit log is included.
/// * Encrypted backup: plain backup + decrypted vault items, wrapped with a
///   passphrase (AES-256-GCM, PBKDF2). Restoring re-encrypts the vault with
///   the local master key, so backups move between devices.
/// * CSV/JSON export: curated non-sensitive columns only.
class BackupService {
  BackupService(this.db, this.crypto, this.vault, this.audit);
  final AppDatabase db;
  final CryptoService crypto;
  final VaultRepository vault;
  final AuditRepository audit;

  static const format = 'syhu-account-hub-backup';
  static const appVersion = '0.1.0';
  static const _vaultTable = 'secure_items';

  // ---------- Create ----------

  Future<Map<String, dynamic>> buildPlainBackup() async {
    final tables = <String, List<Map<String, dynamic>>>{};
    for (final t in db.allTables) {
      if (t.actualTableName == _vaultTable) continue;
      tables[t.actualTableName] = await _dumpTable(t);
    }
    return {
      'format': format,
      'version': 1,
      'schemaVersion': db.schemaVersion,
      'appVersion': appVersion,
      'createdAt': DateTime.now().toIso8601String(),
      'includesVault': false,
      'tables': tables,
    };
  }

  Future<String> plainBackupJson() async => const JsonEncoder.withIndent(' ').convert(await buildPlainBackup());

  Future<String> encryptedBackup(String passphrase) async {
    final doc = await buildPlainBackup();
    final items = await vault.watchAll().first;
    final vaultOut = <Map<String, dynamic>>[];
    for (final i in items) {
      final secret = await vault.reveal(i.id);
      vaultOut.add({'id': i.id, 'title': i.title, 'kind': i.kind, 'createdAt': i.createdAt.toIso8601String(), 'secret': secret.toJson()});
    }
    doc['includesVault'] = true;
    doc['vault'] = vaultOut;
    final envelope = await crypto.encryptWithPassphrase(utf8.encode(jsonEncode(doc)), passphrase);
    await audit.log('backup.encrypted', summary: 'Created encrypted backup (${vaultOut.length} vault items)');
    return envelope;
  }

  Future<List<Map<String, dynamic>>> _dumpTable(TableInfo t) async {
    final rows = await db.customSelect('SELECT * FROM "${t.actualTableName}"').get();
    return rows.map((r) {
      final m = <String, dynamic>{};
      r.data.forEach((k, v) {
        m[k] = v is Uint8List ? {'\$base64': base64Encode(v)} : v;
      });
      return m;
    }).toList();
  }

  // ---------- Inspect ----------

  /// Parses a backup file (plain JSON or encrypted envelope) without applying.
  Future<(Map<String, dynamic>, BackupSummary)> inspect(String content, {String? passphrase}) async {
    Map<String, dynamic> doc;
    final trimmed = content.trim();
    final head = trimmed.length > 200 ? trimmed.substring(0, 200) : trimmed;
    if (head.contains('syhu-account-hub-encrypted-backup')) {
      if (passphrase == null || passphrase.isEmpty) throw const FormatException('This backup is encrypted: enter its passphrase');
      final clear = await crypto.decryptWithPassphrase(trimmed, passphrase);
      doc = jsonDecode(utf8.decode(clear)) as Map<String, dynamic>;
    } else {
      try {
        doc = jsonDecode(trimmed) as Map<String, dynamic>;
      } catch (_) {
        throw const FormatException('File is not valid JSON');
      }
    }
    if (doc['format'] != format) throw const FormatException('Not a SYHU Account Hub backup');
    final schema = (doc['schemaVersion'] as num?)?.toInt() ?? 0;
    if (schema > db.schemaVersion) {
      throw FormatException('Backup schema v$schema is newer than this app (v${db.schemaVersion}). Update the app first.');
    }
    final tables = doc['tables'];
    if (tables is! Map) throw const FormatException('Backup has no tables');
    final known = {for (final t in db.allTables) t.actualTableName};
    final counts = <String, int>{};
    for (final e in tables.entries) {
      if (!known.contains(e.key)) continue;
      if (e.value is! List) throw FormatException('Table ${e.key} is malformed');
      counts[e.key as String] = (e.value as List).length;
    }
    if ((doc['vault'] as List?)?.isNotEmpty ?? false) counts['vault'] = (doc['vault'] as List).length;
    return (
      doc,
      BackupSummary(
        createdAt: DateTime.tryParse(doc['createdAt'] as String? ?? '') ?? DateTime.fromMillisecondsSinceEpoch(0),
        schemaVersion: schema,
        rowCounts: counts,
        includesVault: doc['includesVault'] == true,
        appVersion: (doc['appVersion'] as String?) ?? '?',
      )
    );
  }

  // ---------- Restore ----------

  /// Replaces all local data with the backup. Caller must confirm first.
  ///
  /// `PRAGMA foreign_keys` cannot change inside a transaction, so it is turned
  /// off around the whole restore and the result is validated with
  /// `foreign_key_check` before the transaction commits.
  Future<void> restore(Map<String, dynamic> doc) async {
    final tables = (doc['tables'] as Map).cast<String, dynamic>();
    await db.customStatement('PRAGMA foreign_keys = OFF');
    try {
      await db.transaction(() async {
        for (final t in db.allTables.toList().reversed) {
          await db.delete(t).go();
        }
        for (final t in db.allTables) {
          final rows = tables[t.actualTableName];
          if (rows is! List) continue;
          for (final raw in rows.cast<Map<String, dynamic>>()) {
            final data = <String, dynamic>{};
            raw.forEach((k, v) {
              data[k] = (v is Map && v.containsKey('\$base64')) ? base64Decode(v['\$base64'] as String) : v;
            });
            final names = t.$columns.map((c) => c.$name).where(data.containsKey).toList();
            if (names.isEmpty) continue;
            await db.customInsert(
              'INSERT INTO "${t.actualTableName}" (${names.map((n) => '"$n"').join(',')}) VALUES (${List.filled(names.length, '?').join(',')})',
              variables: names.map((n) => _variable(data[n])).toList(),
            );
          }
        }
        // Re-encrypt vault items with the local master key, keeping their ids
        // so bank accounts and credential references still point at them.
        final vaultRows = (doc['vault'] as List?)?.cast<Map<String, dynamic>>() ?? const [];
        for (final v in vaultRows) {
          final secret = VaultSecret.fromJson((v['secret'] as Map).cast<String, dynamic>());
          final kind = enumFromName(SecureItemKind.values, v['kind'] as String?, SecureItemKind.other);
          await vault.create(id: v['id'] as String, title: v['title'] as String, kind: kind, secret: secret);
        }
        final violations = await db.customSelect('PRAGMA foreign_key_check').get();
        if (violations.isNotEmpty) {
          throw StateError('Backup has ${violations.length} dangling references; restore aborted');
        }
        await audit.log('backup.restore', summary: 'Restored backup from ${doc['createdAt']}');
      });
    } finally {
      await db.customStatement('PRAGMA foreign_keys = ON');
    }
  }

  static Variable _variable(dynamic v) {
    if (v == null) return const Variable(null);
    if (v is int) return Variable.withInt(v);
    if (v is double) return Variable.withReal(v);
    if (v is bool) return Variable.withBool(v);
    if (v is Uint8List) return Variable.withBlob(v);
    return Variable.withString(v.toString());
  }

  // ---------- Exports (non-sensitive) ----------

  Future<String> exportAccountsCsv() async {
    final rows = await (db.select(db.serviceAccounts).join([
      innerJoin(db.platforms, db.platforms.id.equalsExp(db.serviceAccounts.platformId)),
      leftOuterJoin(db.emailIdentities, db.emailIdentities.id.equalsExp(db.serviceAccounts.emailIdentityId)),
    ])
          ..where(db.serviceAccounts.archivedAt.isNull()))
        .get();
    final b = StringBuffer('platform,account,email,username,display_name,profile_url,purpose,status,classification,plan\n');
    for (final r in rows) {
      final a = r.readTable(db.serviceAccounts);
      b.writeln([
        r.readTable(db.platforms).name, a.accountName, r.readTableOrNull(db.emailIdentities)?.address, a.username, a.displayName, a.profileUrl, a.purpose, a.status, a.classification, a.plan,
      ].map(_csv).join(','));
    }
    return b.toString();
  }

  Future<String> exportSubscriptionsCsv() async {
    final rows = await (db.select(db.subscriptions)..where((s) => s.archivedAt.isNull())).get();
    final b = StringBuffer('service,plan,price,currency,billing_cycle,status,next_billing_date,classification,billed_through\n');
    for (final s in rows) {
      b.writeln([s.serviceName, s.plan, (s.priceMinor / 100).toStringAsFixed(2), s.currency, s.billingCycle, s.status, s.nextBillingDate?.toIso8601String().substring(0, 10), s.classification, s.purchaseChannel].map(_csv).join(','));
    }
    return b.toString();
  }

  Future<String> exportEmailsCsv() async {
    final rows = await (db.select(db.emailIdentities)..where((e) => e.archivedAt.isNull())).get();
    final b = StringBuffer('address,provider,display_name,purpose,classification,status\n');
    for (final e in rows) {
      b.writeln([e.address, e.provider, e.displayName, e.purpose, e.classification, e.status].map(_csv).join(','));
    }
    return b.toString();
  }

  /// JSON export of non-sensitive metadata (no vault, no bank/card rows).
  Future<String> exportMetadataJson() async {
    final doc = await buildPlainBackup();
    final tables = (doc['tables'] as Map<String, List<Map<String, dynamic>>>);
    tables.remove('bank_accounts');
    tables.remove('payment_cards');
    tables.remove('credential_references');
    tables.remove('audit_events');
    tables.remove('settings');
    doc['format'] = 'syhu-account-hub-export';
    return const JsonEncoder.withIndent(' ').convert(doc);
  }

  static String _csv(Object? v) {
    final s = v?.toString() ?? '';
    if (s.contains(',') || s.contains('"') || s.contains('\n')) {
      return '"${s.replaceAll('"', '""')}"';
    }
    return s;
  }
}
