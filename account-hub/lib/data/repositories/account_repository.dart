import 'package:drift/drift.dart';

import '../../core/ids.dart';
import '../../core/json_list.dart';
import '../../domain/enums.dart';
import '../db/app_database.dart';
import 'audit_repository.dart';

/// An account joined with its platform and optional email identity.
class AccountView {
  const AccountView(this.account, this.platform, this.email);
  final ServiceAccount account;
  final Platform platform;
  final EmailIdentity? email;

  String get title => account.accountName;
  String get subtitle => email?.address ?? account.username ?? account.displayName ?? '';
}

class AccountRepository {
  AccountRepository(this.db, this.audit);
  final AppDatabase db;
  final AuditRepository audit;

  JoinedSelectStatement<HasResultSet, dynamic> _joined({bool includeArchived = false}) {
    final q = db.select(db.serviceAccounts).join([
      innerJoin(db.platforms, db.platforms.id.equalsExp(db.serviceAccounts.platformId)),
      leftOuterJoin(db.emailIdentities, db.emailIdentities.id.equalsExp(db.serviceAccounts.emailIdentityId)),
    ]);
    if (!includeArchived) q.where(db.serviceAccounts.archivedAt.isNull());
    q.orderBy([OrderingTerm.asc(db.platforms.name), OrderingTerm.asc(db.serviceAccounts.accountName)]);
    return q;
  }

  AccountView _map(TypedResult r) => AccountView(
        r.readTable(db.serviceAccounts),
        r.readTable(db.platforms),
        r.readTableOrNull(db.emailIdentities),
      );

  Stream<List<AccountView>> watchAll({bool includeArchived = false}) =>
      _joined(includeArchived: includeArchived).watch().map((rows) => rows.map(_map).toList());

  Stream<List<AccountView>> watchArchived() =>
      (_joined(includeArchived: true)..where(db.serviceAccounts.archivedAt.isNotNull()))
          .watch()
          .map((rows) => rows.map(_map).toList());

  Stream<List<AccountView>> watchByPlatform(String platformId) =>
      (_joined()..where(db.serviceAccounts.platformId.equals(platformId)))
          .watch()
          .map((rows) => rows.map(_map).toList());

  Stream<AccountView?> watchById(String id) =>
      (_joined(includeArchived: true)..where(db.serviceAccounts.id.equals(id)))
          .watchSingleOrNull()
          .map((r) => r == null ? null : _map(r));

  Future<AccountView?> byId(String id) async {
    final r = await (_joined(includeArchived: true)..where(db.serviceAccounts.id.equals(id))).getSingleOrNull();
    return r == null ? null : _map(r);
  }

  Stream<List<AccountView>> watchRecent({int limit = 8}) => (_joined()
        ..where(db.serviceAccounts.lastAccessedAt.isNotNull())
        ..orderBy([OrderingTerm.desc(db.serviceAccounts.lastAccessedAt)])
        ..limit(limit))
      .watch()
      .map((rows) => rows.map(_map).toList());

  Stream<List<AccountView>> watchFavorites() =>
      (_joined()..where(db.serviceAccounts.isFavorite.equals(true))).watch().map((rows) => rows.map(_map).toList());

  /// Client-side filters shared by category / ecosystem / classification hubs.
  static List<AccountView> filter(
    List<AccountView> all, {
    String? category,
    String? vendor,
    Classification? classification,
    String query = '',
  }) {
    final q = query.trim().toLowerCase();
    return all.where((v) {
      if (category != null && !decodeStringList(v.platform.categories).contains(category)) return false;
      if (vendor != null && v.platform.vendor != vendor) return false;
      if (classification != null && v.account.classification != classification.name) return false;
      if (q.isEmpty) return true;
      return v.platform.name.toLowerCase().contains(q) ||
          v.account.accountName.toLowerCase().contains(q) ||
          (v.account.username ?? '').toLowerCase().contains(q) ||
          (v.account.displayName ?? '').toLowerCase().contains(q) ||
          (v.email?.address ?? '').toLowerCase().contains(q) ||
          (v.account.purpose ?? '').toLowerCase().contains(q);
    }).toList();
  }

  Future<ServiceAccount> upsert({
    String? id,
    required String platformId,
    String? emailIdentityId,
    required String accountName,
    String? username,
    String? displayName,
    String? profileUrl,
    String? purpose,
    AccountStatus status = AccountStatus.active,
    Classification classification = Classification.personal,
    String? plan,
    BillingCycle? billingCycle,
    bool isApiAccount = false,
    String? notes,
    String? credentialRefId,
  }) async {
    if (accountName.trim().isEmpty) throw ArgumentError('Account name is required');
    // Avoid exact duplicates: same platform + same name + same email.
    final dup = await (db.select(db.serviceAccounts)
          ..where((a) =>
              a.platformId.equals(platformId) &
              a.accountName.lower().equals(accountName.trim().toLowerCase()) &
              (emailIdentityId == null ? a.emailIdentityId.isNull() : a.emailIdentityId.equals(emailIdentityId)) &
              a.archivedAt.isNull()))
        .get();
    if (dup.any((d) => d.id != id)) {
      throw StateError('An account named "${accountName.trim()}" already exists for this platform with the same email');
    }
    final rowId = id ?? newId();
    final c = ServiceAccountsCompanion(
      id: Value(rowId),
      platformId: Value(platformId),
      emailIdentityId: Value(emailIdentityId),
      accountName: Value(accountName.trim()),
      username: Value(_clean(username)),
      displayName: Value(_clean(displayName)),
      profileUrl: Value(_clean(profileUrl)),
      purpose: Value(_clean(purpose)),
      status: Value(status.name),
      classification: Value(classification.name),
      plan: Value(_clean(plan)),
      billingCycle: Value(billingCycle?.name),
      isApiAccount: Value(isApiAccount),
      notes: Value(_clean(notes)),
      credentialRefId: Value(credentialRefId),
      updatedAt: Value(DateTime.now()),
    );
    if (id == null) {
      await db.into(db.serviceAccounts).insert(c);
      // Adding an account implicitly makes the platform part of My World.
      await (db.update(db.platforms)..where((p) => p.id.equals(platformId) & p.inMyWorld.equals(false)))
          .write(PlatformsCompanion(inMyWorld: const Value(true), addedToMyWorldAt: Value(DateTime.now())));
      await audit.log('account.create', type: EntityType.serviceAccount, id: rowId, summary: 'Added account "${accountName.trim()}"');
    } else {
      await (db.update(db.serviceAccounts)..where((a) => a.id.equals(id))).write(c);
      await audit.log('account.update', type: EntityType.serviceAccount, id: rowId, summary: 'Updated account "${accountName.trim()}"');
    }
    return (await (db.select(db.serviceAccounts)..where((a) => a.id.equals(rowId))).getSingle());
  }

  Future<void> setArchived(String id, bool archived) async {
    await (db.update(db.serviceAccounts)..where((a) => a.id.equals(id)))
        .write(ServiceAccountsCompanion(archivedAt: Value(archived ? DateTime.now() : null)));
    await audit.log(archived ? 'account.archive' : 'account.restore', type: EntityType.serviceAccount, id: id, summary: archived ? 'Archived account' : 'Restored account');
  }

  Future<void> setFavorite(String id, bool v) =>
      (db.update(db.serviceAccounts)..where((a) => a.id.equals(id))).write(ServiceAccountsCompanion(isFavorite: Value(v)));

  Future<void> touchAccessed(String id) =>
      (db.update(db.serviceAccounts)..where((a) => a.id.equals(id))).write(ServiceAccountsCompanion(lastAccessedAt: Value(DateTime.now())));

  Future<void> delete(String id) async {
    await db.transaction(() async {
      await (db.update(db.subscriptions)..where((s) => s.accountId.equals(id)))
          .write(const SubscriptionsCompanion(accountId: Value(null)));
      await (db.delete(db.links)
            ..where((l) =>
                (l.fromType.equals(EntityType.serviceAccount.name) & l.fromId.equals(id)) |
                (l.toType.equals(EntityType.serviceAccount.name) & l.toId.equals(id))))
          .go();
      await (db.delete(db.tagLinks)..where((t) => t.entityType.equals(EntityType.serviceAccount.name) & t.entityId.equals(id))).go();
      await (db.delete(db.customFields)..where((t) => t.entityType.equals(EntityType.serviceAccount.name) & t.entityId.equals(id))).go();
      await (db.delete(db.serviceAccounts)..where((a) => a.id.equals(id))).go();
    });
    await audit.log('account.delete', type: EntityType.serviceAccount, id: id, summary: 'Deleted account');
  }

  Future<int> countActive() async {
    final c = db.serviceAccounts.id.count();
    final row = await (db.selectOnly(db.serviceAccounts)
          ..addColumns([c])
          ..where(db.serviceAccounts.archivedAt.isNull()))
        .getSingle();
    return row.read(c) ?? 0;
  }

  static String? _clean(String? s) {
    final t = s?.trim();
    return (t == null || t.isEmpty) ? null : t;
  }
}
