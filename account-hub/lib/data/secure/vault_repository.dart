import 'dart:convert';

import 'package:drift/drift.dart';

import '../../core/ids.dart';
import '../../domain/enums.dart';
import '../db/app_database.dart';
import '../repositories/audit_repository.dart';
import 'crypto_service.dart';

/// Decrypted vault payload. Never persisted, logged or searched.
class VaultSecret {
  const VaultSecret({required this.value, this.username, this.url, this.notes});
  final String value;
  final String? username;
  final String? url;
  final String? notes;

  Map<String, dynamic> toJson() => {'value': value, 'username': username, 'url': url, 'notes': notes};
  factory VaultSecret.fromJson(Map<String, dynamic> j) => VaultSecret(
        value: (j['value'] as String?) ?? '',
        username: j['username'] as String?,
        url: j['url'] as String?,
        notes: j['notes'] as String?,
      );
}

/// Encrypted secret storage. Metadata (title, kind, timestamps) is in clear so
/// the vault can be listed while locked; the payload is AES-GCM ciphertext.
class VaultRepository {
  VaultRepository(this.db, this.crypto, this.audit);
  final AppDatabase db;
  final CryptoService crypto;
  final AuditRepository audit;

  Stream<List<SecureItem>> watchAll() =>
      (db.select(db.secureItems)..orderBy([(s) => OrderingTerm.asc(s.title)])).watch();

  Future<SecureItem?> byId(String id) => (db.select(db.secureItems)..where((s) => s.id.equals(id))).getSingleOrNull();

  /// [id] may be supplied by restore so references keep pointing at the item;
  /// the id is bound into the ciphertext as associated data.
  Future<SecureItem> create({String? id, required String title, required SecureItemKind kind, required VaultSecret secret}) async {
    if (title.trim().isEmpty) throw ArgumentError('Title is required');
    id ??= newId();
    final (ct, nonce) = await crypto.encryptWithMaster(utf8.encode(jsonEncode(secret.toJson())), aad: utf8.encode(id));
    await db.into(db.secureItems).insert(SecureItemsCompanion.insert(
          id: id,
          title: title.trim(),
          kind: kind.name,
          ciphertext: ct,
          nonce: nonce,
          keyId: const Value(CryptoService.currentKeyId),
        ));
    await audit.log('vault.create', type: EntityType.secureItem, id: id, summary: 'Added vault item "${title.trim()}"');
    return (await byId(id))!;
  }

  Future<void> update(String id, {required String title, required SecureItemKind kind, VaultSecret? secret}) async {
    var c = SecureItemsCompanion(title: Value(title.trim()), kind: Value(kind.name), updatedAt: Value(DateTime.now()));
    if (secret != null) {
      final (ct, nonce) = await crypto.encryptWithMaster(utf8.encode(jsonEncode(secret.toJson())), aad: utf8.encode(id));
      c = c.copyWith(ciphertext: Value(ct), nonce: Value(nonce));
    }
    await (db.update(db.secureItems)..where((s) => s.id.equals(id))).write(c);
    await audit.log('vault.update', type: EntityType.secureItem, id: id, summary: 'Updated vault item "${title.trim()}"');
  }

  /// Decrypts an item. Records the view time (not the value) in the audit log.
  Future<VaultSecret> reveal(String id) async {
    final item = await byId(id);
    if (item == null) throw StateError('Vault item not found');
    final clear = await crypto.decryptWithMaster(item.ciphertext, item.nonce, aad: utf8.encode(id));
    await (db.update(db.secureItems)..where((s) => s.id.equals(id))).write(SecureItemsCompanion(lastViewedAt: Value(DateTime.now())));
    await audit.log('vault.reveal', type: EntityType.secureItem, id: id, summary: 'Revealed "${item.title}"');
    return VaultSecret.fromJson(jsonDecode(utf8.decode(clear)) as Map<String, dynamic>);
  }

  Future<void> delete(String id) async {
    await db.transaction(() async {
      await (db.update(db.bankAccounts)..where((b) => b.fullNumberVaultId.equals(id))).write(const BankAccountsCompanion(fullNumberVaultId: Value(null)));
      await (db.update(db.credentialReferences)..where((c) => c.vaultItemId.equals(id))).write(const CredentialReferencesCompanion(vaultItemId: Value(null)));
      await (db.delete(db.links)..where((l) => (l.fromType.equals(EntityType.secureItem.name) & l.fromId.equals(id)) | (l.toType.equals(EntityType.secureItem.name) & l.toId.equals(id)))).go();
      await (db.delete(db.secureItems)..where((s) => s.id.equals(id))).go();
    });
    await audit.log('vault.delete', type: EntityType.secureItem, id: id, summary: 'Deleted vault item');
  }

  Future<int> count() async {
    final c = db.secureItems.id.count();
    final row = await (db.selectOnly(db.secureItems)..addColumns([c])).getSingle();
    return row.read(c) ?? 0;
  }

  // ---------- Credential references ----------
  Stream<List<CredentialReference>> watchCredentialRefs() =>
      (db.select(db.credentialReferences)..orderBy([(c) => OrderingTerm.asc(c.label)])).watch();

  Future<CredentialReference> upsertCredentialRef({String? id, required String label, String? manager, String? locator, String? usernameHint, String? notes, String? vaultItemId}) async {
    if (label.trim().isEmpty) throw ArgumentError('Label is required');
    final rowId = id ?? newId();
    final c = CredentialReferencesCompanion(
      id: Value(rowId), label: Value(label.trim()), manager: Value(_clean(manager)), locator: Value(_clean(locator)), usernameHint: Value(_clean(usernameHint)), notes: Value(_clean(notes)), vaultItemId: Value(vaultItemId), updatedAt: Value(DateTime.now()),
    );
    if (id == null) {
      await db.into(db.credentialReferences).insert(c);
    } else {
      await (db.update(db.credentialReferences)..where((x) => x.id.equals(id))).write(c);
    }
    return (db.select(db.credentialReferences)..where((x) => x.id.equals(rowId))).getSingle();
  }

  Future<void> deleteCredentialRef(String id) async {
    await db.transaction(() async {
      await (db.update(db.serviceAccounts)..where((a) => a.credentialRefId.equals(id))).write(const ServiceAccountsCompanion(credentialRefId: Value(null)));
      await (db.delete(db.credentialReferences)..where((c) => c.id.equals(id))).go();
    });
  }

  static String? _clean(String? s) {
    final t = s?.trim();
    return (t == null || t.isEmpty) ? null : t;
  }
}
