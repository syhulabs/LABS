import 'package:drift/drift.dart';

import '../../core/ids.dart';
import '../../domain/enums.dart';
import '../db/app_database.dart';
import 'audit_repository.dart';

/// A resolved link target for display: what the other side of a [Link] is.
class LinkedEntity {
  const LinkedEntity({required this.link, required this.type, required this.id, required this.title, this.subtitle});
  final Link link;
  final EntityType type;
  final String id;
  final String title;
  final String? subtitle;
}

/// Projects, organizations (business / label / studio), artists and the
/// generic link table that ties them to accounts, emails, subscriptions, etc.
class ProjectRepository {
  ProjectRepository(this.db, this.audit);
  final AppDatabase db;
  final AuditRepository audit;

  // ---------- Projects ----------
  Stream<List<Project>> watchProjects({bool includeArchived = false}) {
    final q = db.select(db.projects)..orderBy([(p) => OrderingTerm.asc(p.name)]);
    if (!includeArchived) q.where((p) => p.archivedAt.isNull());
    return q.watch();
  }

  Stream<Project?> watchProject(String id) =>
      (db.select(db.projects)..where((p) => p.id.equals(id))).watchSingleOrNull();

  Future<Project> upsertProject({
    String? id,
    required String name,
    required ProjectKind kind,
    ProjectStatus status = ProjectStatus.inProgress,
    String? description,
    String? url,
    String? organizationId,
    String? artistId,
    Classification classification = Classification.personal,
    String? notes,
  }) async {
    if (name.trim().isEmpty) throw ArgumentError('Project name is required');
    final rowId = id ?? newId();
    final c = ProjectsCompanion(
      id: Value(rowId),
      name: Value(name.trim()),
      kind: Value(kind.name),
      status: Value(status.name),
      description: Value(_clean(description)),
      url: Value(_clean(url)),
      organizationId: Value(organizationId),
      artistId: Value(artistId),
      classification: Value(classification.name),
      notes: Value(_clean(notes)),
      updatedAt: Value(DateTime.now()),
    );
    if (id == null) {
      await db.into(db.projects).insert(c);
    } else {
      await (db.update(db.projects)..where((p) => p.id.equals(id))).write(c);
    }
    await audit.log(id == null ? 'project.create' : 'project.update', type: EntityType.project, id: rowId, summary: '${id == null ? 'Created' : 'Updated'} project "${name.trim()}"');
    return (db.select(db.projects)..where((p) => p.id.equals(rowId))).getSingle();
  }

  Future<void> setProjectArchived(String id, bool archived) =>
      (db.update(db.projects)..where((p) => p.id.equals(id))).write(ProjectsCompanion(archivedAt: Value(archived ? DateTime.now() : null)));

  Future<void> deleteProject(String id) async {
    await db.transaction(() async {
      await (db.update(db.youtubeChannels)..where((c) => c.id.equals(id))).write(const YoutubeChannelsCompanion());
      await _deleteLinksFor(EntityType.project, id);
      await (db.delete(db.projects)..where((p) => p.id.equals(id))).go();
    });
    await audit.log('project.delete', type: EntityType.project, id: id, summary: 'Deleted project');
  }

  // ---------- Organizations ----------
  Stream<List<Organization>> watchOrganizations({OrganizationKind? kind, bool includeArchived = false}) {
    final q = db.select(db.organizations)..orderBy([(o) => OrderingTerm.asc(o.name)]);
    if (kind != null) q.where((o) => o.kind.equals(kind.name));
    if (!includeArchived) q.where((o) => o.archivedAt.isNull());
    return q.watch();
  }

  Future<Organization> upsertOrganization({
    String? id,
    required String name,
    required OrganizationKind kind,
    String? description,
    String? website,
    String? primaryEmailId,
    String? notes,
  }) async {
    if (name.trim().isEmpty) throw ArgumentError('Name is required');
    final rowId = id ?? newId();
    final c = OrganizationsCompanion(
      id: Value(rowId),
      name: Value(name.trim()),
      kind: Value(kind.name),
      description: Value(_clean(description)),
      website: Value(_clean(website)),
      primaryEmailId: Value(primaryEmailId),
      notes: Value(_clean(notes)),
      updatedAt: Value(DateTime.now()),
    );
    if (id == null) {
      await db.into(db.organizations).insert(c);
    } else {
      await (db.update(db.organizations)..where((o) => o.id.equals(id))).write(c);
    }
    await audit.log(id == null ? 'organization.create' : 'organization.update', type: EntityType.organization, id: rowId, summary: '${id == null ? 'Created' : 'Updated'} ${kind.label.toLowerCase()} "${name.trim()}"');
    return (db.select(db.organizations)..where((o) => o.id.equals(rowId))).getSingle();
  }

  Future<void> setOrganizationArchived(String id, bool archived) =>
      (db.update(db.organizations)..where((o) => o.id.equals(id))).write(OrganizationsCompanion(archivedAt: Value(archived ? DateTime.now() : null)));

  Future<void> deleteOrganization(String id) async {
    await db.transaction(() async {
      await (db.update(db.projects)..where((p) => p.organizationId.equals(id))).write(const ProjectsCompanion(organizationId: Value(null)));
      await (db.update(db.artists)..where((a) => a.labelId.equals(id))).write(const ArtistsCompanion(labelId: Value(null)));
      await (db.update(db.youtubeChannels)..where((c) => c.organizationId.equals(id))).write(const YoutubeChannelsCompanion(organizationId: Value(null)));
      await (db.update(db.bankAccounts)..where((b) => b.organizationId.equals(id))).write(const BankAccountsCompanion(organizationId: Value(null)));
      await _deleteLinksFor(EntityType.organization, id);
      await (db.delete(db.organizations)..where((o) => o.id.equals(id))).go();
    });
    await audit.log('organization.delete', type: EntityType.organization, id: id, summary: 'Deleted organization');
  }

  // ---------- Artists ----------
  Stream<List<Artist>> watchArtists({bool includeArchived = false}) {
    final q = db.select(db.artists)..orderBy([(a) => OrderingTerm.asc(a.name)]);
    if (!includeArchived) q.where((a) => a.archivedAt.isNull());
    return q.watch();
  }

  Future<Artist> upsertArtist({
    String? id,
    required String name,
    String? genre,
    String? bio,
    String? labelId,
    String? primaryEmailId,
    String? notes,
  }) async {
    if (name.trim().isEmpty) throw ArgumentError('Artist name is required');
    final rowId = id ?? newId();
    final c = ArtistsCompanion(
      id: Value(rowId),
      name: Value(name.trim()),
      genre: Value(_clean(genre)),
      bio: Value(_clean(bio)),
      labelId: Value(labelId),
      primaryEmailId: Value(primaryEmailId),
      notes: Value(_clean(notes)),
      updatedAt: Value(DateTime.now()),
    );
    if (id == null) {
      await db.into(db.artists).insert(c);
    } else {
      await (db.update(db.artists)..where((a) => a.id.equals(id))).write(c);
    }
    await audit.log(id == null ? 'artist.create' : 'artist.update', type: EntityType.artist, id: rowId, summary: '${id == null ? 'Created' : 'Updated'} artist "${name.trim()}"');
    return (db.select(db.artists)..where((a) => a.id.equals(rowId))).getSingle();
  }

  Future<void> setArtistArchived(String id, bool archived) =>
      (db.update(db.artists)..where((a) => a.id.equals(id))).write(ArtistsCompanion(archivedAt: Value(archived ? DateTime.now() : null)));

  Future<void> deleteArtist(String id) async {
    await db.transaction(() async {
      await (db.update(db.projects)..where((p) => p.artistId.equals(id))).write(const ProjectsCompanion(artistId: Value(null)));
      await (db.update(db.youtubeChannels)..where((c) => c.artistId.equals(id))).write(const YoutubeChannelsCompanion(artistId: Value(null)));
      await _deleteLinksFor(EntityType.artist, id);
      await (db.delete(db.artists)..where((a) => a.id.equals(id))).go();
    });
    await audit.log('artist.delete', type: EntityType.artist, id: id, summary: 'Deleted artist');
  }

  // ---------- Links ----------
  Future<void> link(EntityType fromType, String fromId, EntityType toType, String toId, {String relation = 'related'}) async {
    await db.into(db.links).insert(
          LinksCompanion.insert(
            id: newId(),
            fromType: fromType.name,
            fromId: fromId,
            toType: toType.name,
            toId: toId,
            relation: Value(relation),
          ),
          mode: InsertMode.insertOrIgnore,
        );
  }

  Future<void> unlink(String linkId) => (db.delete(db.links)..where((l) => l.id.equals(linkId))).go();

  /// All links touching an entity (either direction), resolved to titles.
  Stream<List<LinkedEntity>> watchLinks(EntityType type, String id) {
    final q = db.select(db.links)
      ..where((l) => (l.fromType.equals(type.name) & l.fromId.equals(id)) | (l.toType.equals(type.name) & l.toId.equals(id)));
    return q.watch().asyncMap((links) async {
      final out = <LinkedEntity>[];
      for (final l in links) {
        final otherIsTo = l.fromType == type.name && l.fromId == id;
        final otherType = enumFromName(EntityType.values, otherIsTo ? l.toType : l.fromType, EntityType.platform);
        final otherId = otherIsTo ? l.toId : l.fromId;
        final resolved = await resolveTitle(otherType, otherId);
        if (resolved != null) {
          out.add(LinkedEntity(link: l, type: otherType, id: otherId, title: resolved.$1, subtitle: resolved.$2));
        }
      }
      out.sort((a, b) => a.type.index.compareTo(b.type.index));
      return out;
    });
  }

  Future<(String, String?)?> resolveTitle(EntityType type, String id) async {
    switch (type) {
      case EntityType.platform:
        final p = await (db.select(db.platforms)..where((x) => x.id.equals(id))).getSingleOrNull();
        return p == null ? null : (p.name, 'Platform');
      case EntityType.emailIdentity:
        final e = await (db.select(db.emailIdentities)..where((x) => x.id.equals(id))).getSingleOrNull();
        return e == null ? null : (e.address, e.displayName);
      case EntityType.serviceAccount:
        final r = await (db.select(db.serviceAccounts).join([innerJoin(db.platforms, db.platforms.id.equalsExp(db.serviceAccounts.platformId))])
              ..where(db.serviceAccounts.id.equals(id)))
            .getSingleOrNull();
        if (r == null) return null;
        return ('${r.readTable(db.platforms).name} · ${r.readTable(db.serviceAccounts).accountName}', 'Account');
      case EntityType.youtubeChannel:
        final c = await (db.select(db.youtubeChannels)..where((x) => x.id.equals(id))).getSingleOrNull();
        return c == null ? null : (c.name, c.handle ?? 'YouTube channel');
      case EntityType.project:
        final p = await (db.select(db.projects)..where((x) => x.id.equals(id))).getSingleOrNull();
        return p == null ? null : (p.name, enumFromName(ProjectKind.values, p.kind, ProjectKind.other).label);
      case EntityType.organization:
        final o = await (db.select(db.organizations)..where((x) => x.id.equals(id))).getSingleOrNull();
        return o == null ? null : (o.name, enumFromName(OrganizationKind.values, o.kind, OrganizationKind.business).label);
      case EntityType.artist:
        final a = await (db.select(db.artists)..where((x) => x.id.equals(id))).getSingleOrNull();
        return a == null ? null : (a.name, 'Artist');
      case EntityType.subscription:
        final s = await (db.select(db.subscriptions)..where((x) => x.id.equals(id))).getSingleOrNull();
        return s == null ? null : (s.serviceName, s.plan ?? 'Subscription');
      case EntityType.bankAccount:
        final b = await (db.select(db.bankAccounts)..where((x) => x.id.equals(id))).getSingleOrNull();
        return b == null ? null : (b.nickname, b.bankName);
      case EntityType.paymentCard:
        final c = await (db.select(db.paymentCards)..where((x) => x.id.equals(id))).getSingleOrNull();
        return c == null ? null : (c.nickname, c.last4 == null ? 'Card' : '•••• ${c.last4}');
      case EntityType.paymentMethod:
        final m = await (db.select(db.paymentMethods)..where((x) => x.id.equals(id))).getSingleOrNull();
        return m == null ? null : (m.label, 'Payment method');
      case EntityType.credentialReference:
        final c = await (db.select(db.credentialReferences)..where((x) => x.id.equals(id))).getSingleOrNull();
        return c == null ? null : (c.label, c.manager);
      case EntityType.documentReference:
        final d = await (db.select(db.documentReferences)..where((x) => x.id.equals(id))).getSingleOrNull();
        return d == null ? null : (d.title, d.kind ?? 'Document');
      case EntityType.secureItem:
        final s = await (db.select(db.secureItems)..where((x) => x.id.equals(id))).getSingleOrNull();
        return s == null ? null : (s.title, 'Vault item');
    }
  }

  Future<void> _deleteLinksFor(EntityType type, String id) async {
    await (db.delete(db.links)..where((l) => (l.fromType.equals(type.name) & l.fromId.equals(id)) | (l.toType.equals(type.name) & l.toId.equals(id)))).go();
    await (db.delete(db.tagLinks)..where((t) => t.entityType.equals(type.name) & t.entityId.equals(id))).go();
    await (db.delete(db.customFields)..where((t) => t.entityType.equals(type.name) & t.entityId.equals(id))).go();
  }

  // ---------- Documents ----------
  Stream<List<DocumentReference>> watchDocuments() =>
      (db.select(db.documentReferences)..orderBy([(d) => OrderingTerm.asc(d.title)])).watch();

  Future<DocumentReference> upsertDocument({String? id, required String title, required String locator, String? kind, String? notes}) async {
    final rowId = id ?? newId();
    final c = DocumentReferencesCompanion(
      id: Value(rowId), title: Value(title.trim()), locator: Value(locator.trim()), kind: Value(_clean(kind)), notes: Value(_clean(notes)), updatedAt: Value(DateTime.now()),
    );
    if (id == null) {
      await db.into(db.documentReferences).insert(c);
    } else {
      await (db.update(db.documentReferences)..where((d) => d.id.equals(id))).write(c);
    }
    return (db.select(db.documentReferences)..where((d) => d.id.equals(rowId))).getSingle();
  }

  Future<void> deleteDocument(String id) async {
    await _deleteLinksFor(EntityType.documentReference, id);
    await (db.delete(db.documentReferences)..where((d) => d.id.equals(id))).go();
  }

  static String? _clean(String? s) {
    final t = s?.trim();
    return (t == null || t.isEmpty) ? null : t;
  }
}
