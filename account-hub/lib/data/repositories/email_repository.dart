import 'dart:async';

import 'package:drift/drift.dart';

import '../../core/ids.dart';
import '../../domain/enums.dart';
import '../db/app_database.dart';
import 'audit_repository.dart';

class EmailUsage {
  const EmailUsage({
    required this.accounts,
    required this.ownedChannels,
    required this.managedChannels,
    required this.organizations,
    required this.artists,
    required this.linkedProjects,
  });
  final List<(ServiceAccount, Platform)> accounts;
  final List<YoutubeChannel> ownedChannels;
  final List<(YoutubeChannel, ChannelManager)> managedChannels;
  final List<Organization> organizations;
  final List<Artist> artists;
  final List<Project> linkedProjects;

  int get total =>
      accounts.length + ownedChannels.length + managedChannels.length + organizations.length + artists.length + linkedProjects.length;
}

class EmailRepository {
  EmailRepository(this.db, this.audit);
  final AppDatabase db;
  final AuditRepository audit;

  Stream<List<EmailIdentity>> watchAll({bool includeArchived = false}) {
    final q = db.select(db.emailIdentities)..orderBy([(e) => OrderingTerm.asc(e.address)]);
    if (!includeArchived) q.where((e) => e.archivedAt.isNull());
    return q.watch();
  }

  Future<List<EmailIdentity>> all() => db.select(db.emailIdentities).get();

  Future<EmailIdentity?> byId(String id) =>
      (db.select(db.emailIdentities)..where((e) => e.id.equals(id))).getSingleOrNull();

  Stream<EmailIdentity?> watchById(String id) =>
      (db.select(db.emailIdentities)..where((e) => e.id.equals(id))).watchSingleOrNull();

  Future<EmailIdentity?> findByAddress(String address) =>
      (db.select(db.emailIdentities)..where((e) => e.normalizedAddress.equals(normalizeEmail(address))))
          .getSingleOrNull();

  /// Creates a new identity or returns the existing one with the same
  /// address: identities are deduplicated by normalized address.
  Future<EmailIdentity> upsert({
    String? id,
    required String address,
    String? provider,
    String? displayName,
    String? purpose,
    Classification classification = Classification.personal,
    String? recoveryNotes,
    String? notes,
    AccountStatus status = AccountStatus.active,
  }) async {
    final normalized = normalizeEmail(address);
    if (normalized.isEmpty || !normalized.contains('@')) {
      throw ArgumentError('Enter a valid email address');
    }
    final existing = await findByAddress(address);
    if (id == null && existing != null) {
      // Same address already tracked: don't duplicate it.
      return existing;
    }
    if (id != null && existing != null && existing.id != id) {
      throw StateError('Another identity already uses $address');
    }
    final rowId = id ?? newId();
    final companion = EmailIdentitiesCompanion(
      id: Value(rowId),
      address: Value(address.trim()),
      normalizedAddress: Value(normalized),
      provider: Value(provider ?? _guessProvider(normalized)),
      displayName: Value(displayName),
      purpose: Value(purpose),
      classification: Value(classification.name),
      recoveryNotes: Value(recoveryNotes),
      notes: Value(notes),
      status: Value(status.name),
      updatedAt: Value(DateTime.now()),
    );
    if (id == null) {
      await db.into(db.emailIdentities).insert(companion);
      await audit.log('email.create', type: EntityType.emailIdentity, id: rowId, summary: 'Added email ${address.trim()}');
    } else {
      await (db.update(db.emailIdentities)..where((e) => e.id.equals(id))).write(companion);
      await audit.log('email.update', type: EntityType.emailIdentity, id: rowId, summary: 'Updated email ${address.trim()}');
    }
    return (await byId(rowId))!;
  }

  Future<void> setArchived(String id, bool archived) async {
    await (db.update(db.emailIdentities)..where((e) => e.id.equals(id)))
        .write(EmailIdentitiesCompanion(archivedAt: Value(archived ? DateTime.now() : null)));
    await audit.log(archived ? 'email.archive' : 'email.restore', type: EntityType.emailIdentity, id: id, summary: archived ? 'Archived email' : 'Restored email');
  }

  Future<void> setFavorite(String id, bool v) =>
      (db.update(db.emailIdentities)..where((e) => e.id.equals(id))).write(EmailIdentitiesCompanion(isFavorite: Value(v)));

  /// Hard delete. Detaches references (accounts keep working without an email).
  Future<void> delete(String id) async {
    await db.transaction(() async {
      await (db.update(db.serviceAccounts)..where((a) => a.emailIdentityId.equals(id)))
          .write(const ServiceAccountsCompanion(emailIdentityId: Value(null)));
      await (db.update(db.youtubeChannels)..where((c) => c.ownerEmailId.equals(id)))
          .write(const YoutubeChannelsCompanion(ownerEmailId: Value(null)));
      await (db.update(db.organizations)..where((o) => o.primaryEmailId.equals(id)))
          .write(const OrganizationsCompanion(primaryEmailId: Value(null)));
      await (db.update(db.artists)..where((a) => a.primaryEmailId.equals(id)))
          .write(const ArtistsCompanion(primaryEmailId: Value(null)));
      await (db.delete(db.channelManagers)..where((m) => m.emailIdentityId.equals(id))).go();
      await (db.delete(db.links)
            ..where((l) =>
                (l.fromType.equals(EntityType.emailIdentity.name) & l.fromId.equals(id)) |
                (l.toType.equals(EntityType.emailIdentity.name) & l.toId.equals(id))))
          .go();
      await (db.delete(db.tagLinks)..where((t) => t.entityType.equals(EntityType.emailIdentity.name) & t.entityId.equals(id))).go();
      await (db.delete(db.customFields)..where((t) => t.entityType.equals(EntityType.emailIdentity.name) & t.entityId.equals(id))).go();
      await (db.delete(db.emailIdentities)..where((e) => e.id.equals(id))).go();
    });
    await audit.log('email.delete', type: EntityType.emailIdentity, id: id, summary: 'Deleted email identity');
  }

  /// Reverse lookup: everything connected to an email.
  Stream<EmailUsage> watchUsage(String emailId) {
    final accounts = (db.select(db.serviceAccounts).join([
      innerJoin(db.platforms, db.platforms.id.equalsExp(db.serviceAccounts.platformId)),
    ])
          ..where(db.serviceAccounts.emailIdentityId.equals(emailId) & db.serviceAccounts.archivedAt.isNull()))
        .watch()
        .map((rows) => rows.map((r) => (r.readTable(db.serviceAccounts), r.readTable(db.platforms))).toList());
    final owned = (db.select(db.youtubeChannels)..where((c) => c.ownerEmailId.equals(emailId) & c.archivedAt.isNull())).watch();
    final managed = (db.select(db.channelManagers).join([
      innerJoin(db.youtubeChannels, db.youtubeChannels.id.equalsExp(db.channelManagers.channelId)),
    ])
          ..where(db.channelManagers.emailIdentityId.equals(emailId)))
        .watch()
        .map((rows) => rows.map((r) => (r.readTable(db.youtubeChannels), r.readTable(db.channelManagers))).toList());
    final orgs = (db.select(db.organizations)..where((o) => o.primaryEmailId.equals(emailId))).watch();
    final artists = (db.select(db.artists)..where((a) => a.primaryEmailId.equals(emailId))).watch();
    final projects = (db.select(db.links).join([
      innerJoin(db.projects, db.projects.id.equalsExp(db.links.fromId)),
    ])
          ..where(db.links.fromType.equals(EntityType.project.name) &
              db.links.toType.equals(EntityType.emailIdentity.name) &
              db.links.toId.equals(emailId)))
        .watch()
        .map((rows) => rows.map((r) => r.readTable(db.projects)).toList());

    return _combine6(accounts, owned, managed, orgs, artists, projects).map((t) => EmailUsage(
          accounts: t.$1,
          ownedChannels: t.$2,
          managedChannels: t.$3,
          organizations: t.$4,
          artists: t.$5,
          linkedProjects: t.$6,
        ));
  }

  static String? _guessProvider(String normalized) {
    final domain = normalized.split('@').last;
    const known = {
      'gmail.com': 'Gmail',
      'googlemail.com': 'Gmail',
      'outlook.com': 'Outlook',
      'hotmail.com': 'Outlook',
      'live.com': 'Outlook',
      'icloud.com': 'iCloud',
      'me.com': 'iCloud',
      'yahoo.com': 'Yahoo',
      'proton.me': 'Proton Mail',
      'protonmail.com': 'Proton Mail',
      'zoho.com': 'Zoho Mail',
      'fastmail.com': 'Fastmail',
    };
    return known[domain] ?? domain;
  }
}

/// Combines six streams into a tuple stream, emitting once all have a value
/// and whenever any changes.
Stream<(A, B, C, D, E, F)> _combine6<A, B, C, D, E, F>(
    Stream<A> a, Stream<B> b, Stream<C> c, Stream<D> d, Stream<E> e, Stream<F> f) {
  late StreamController<(A, B, C, D, E, F)> ctrl;
  A? va; B? vb; C? vc; D? vd; E? ve; F? vf;
  var ha = false, hb = false, hc = false, hd = false, he = false, hf = false;
  final subs = <StreamSubscription<dynamic>>[];
  void emit() {
    if (ha && hb && hc && hd && he && hf) {
      ctrl.add((va as A, vb as B, vc as C, vd as D, ve as E, vf as F));
    }
  }
  ctrl = StreamController(
    onListen: () {
      subs.addAll([
        a.listen((v) { va = v; ha = true; emit(); }, onError: ctrl.addError),
        b.listen((v) { vb = v; hb = true; emit(); }, onError: ctrl.addError),
        c.listen((v) { vc = v; hc = true; emit(); }, onError: ctrl.addError),
        d.listen((v) { vd = v; hd = true; emit(); }, onError: ctrl.addError),
        e.listen((v) { ve = v; he = true; emit(); }, onError: ctrl.addError),
        f.listen((v) { vf = v; hf = true; emit(); }, onError: ctrl.addError),
      ]);
    },
    onCancel: () async {
      for (final s in subs) {
        await s.cancel();
      }
    },
  );
  return ctrl.stream;
}
