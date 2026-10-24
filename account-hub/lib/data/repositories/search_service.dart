import 'package:drift/drift.dart';

import '../../domain/enums.dart';
import '../db/app_database.dart';

class SearchHit {
  const SearchHit({required this.type, required this.id, required this.title, this.subtitle, this.platformId});
  final EntityType type;
  final String id;
  final String title;
  final String? subtitle;
  final String? platformId;
}

/// Global search over non-sensitive metadata. By design it never reads the
/// vault, bank numbers, netbanking usernames or card details.
class SearchService {
  SearchService(this.db);
  final AppDatabase db;

  Future<List<SearchHit>> search(String query, {int limit = 40}) async {
    final q = query.trim().toLowerCase();
    if (q.length < 2) return const [];
    final like = '%$q%';
    final out = <SearchHit>[];

    final platforms = await (db.select(db.platforms)
          ..where((p) => p.name.lower().like(like) | p.description.lower().like(like))
          ..orderBy([(p) => OrderingTerm.desc(p.inMyWorld), (p) => OrderingTerm.asc(p.name)])
          ..limit(12))
        .get();
    out.addAll(platforms.map((p) => SearchHit(type: EntityType.platform, id: p.id, title: p.name, subtitle: p.inMyWorld ? 'In My World' : 'Catalog', platformId: p.id)));

    final emails = await (db.select(db.emailIdentities)
          ..where((e) => e.archivedAt.isNull() & (e.address.lower().like(like) | e.displayName.lower().like(like) | e.purpose.lower().like(like)))
          ..limit(10))
        .get();
    out.addAll(emails.map((e) => SearchHit(type: EntityType.emailIdentity, id: e.id, title: e.address, subtitle: e.displayName ?? e.provider)));

    final accounts = await (db.select(db.serviceAccounts).join([innerJoin(db.platforms, db.platforms.id.equalsExp(db.serviceAccounts.platformId))])
          ..where(db.serviceAccounts.archivedAt.isNull() &
              (db.serviceAccounts.accountName.lower().like(like) |
                  db.serviceAccounts.username.lower().like(like) |
                  db.serviceAccounts.displayName.lower().like(like) |
                  db.serviceAccounts.purpose.lower().like(like) |
                  db.platforms.name.lower().like(like)))
          ..limit(15))
        .get();
    out.addAll(accounts.map((r) {
      final a = r.readTable(db.serviceAccounts);
      final p = r.readTable(db.platforms);
      return SearchHit(type: EntityType.serviceAccount, id: a.id, title: '${p.name} · ${a.accountName}', subtitle: a.username ?? a.displayName, platformId: p.id);
    }));

    final channels = await (db.select(db.youtubeChannels)
          ..where((c) => c.archivedAt.isNull() & (c.name.lower().like(like) | c.handle.lower().like(like) | c.purpose.lower().like(like)))
          ..limit(10))
        .get();
    out.addAll(channels.map((c) => SearchHit(type: EntityType.youtubeChannel, id: c.id, title: c.name, subtitle: c.handle ?? 'YouTube channel', platformId: 'youtube')));

    final projects = await (db.select(db.projects)..where((p) => p.archivedAt.isNull() & (p.name.lower().like(like) | p.description.lower().like(like)))..limit(10)).get();
    out.addAll(projects.map((p) => SearchHit(type: EntityType.project, id: p.id, title: p.name, subtitle: enumFromName(ProjectKind.values, p.kind, ProjectKind.other).label)));

    final orgs = await (db.select(db.organizations)..where((o) => o.archivedAt.isNull() & o.name.lower().like(like))..limit(8)).get();
    out.addAll(orgs.map((o) => SearchHit(type: EntityType.organization, id: o.id, title: o.name, subtitle: enumFromName(OrganizationKind.values, o.kind, OrganizationKind.business).label)));

    final artists = await (db.select(db.artists)..where((a) => a.archivedAt.isNull() & a.name.lower().like(like))..limit(8)).get();
    out.addAll(artists.map((a) => SearchHit(type: EntityType.artist, id: a.id, title: a.name, subtitle: a.genre ?? 'Artist')));

    final subs = await (db.select(db.subscriptions)..where((s) => s.archivedAt.isNull() & (s.serviceName.lower().like(like) | s.plan.lower().like(like)))..limit(10)).get();
    out.addAll(subs.map((s) => SearchHit(type: EntityType.subscription, id: s.id, title: s.serviceName, subtitle: s.plan ?? enumFromName(SubscriptionStatus.values, s.status, SubscriptionStatus.active).label, platformId: s.platformId)));

    final banks = await (db.select(db.bankAccounts)..where((b) => b.archivedAt.isNull() & (b.nickname.lower().like(like) | b.bankName.lower().like(like)))..limit(6)).get();
    out.addAll(banks.map((b) => SearchHit(type: EntityType.bankAccount, id: b.id, title: b.nickname, subtitle: b.bankName)));

    // Tags: return the tagged entities.
    final tagRows = await (db.select(db.tagLinks).join([innerJoin(db.tags, db.tags.id.equalsExp(db.tagLinks.tagId))])
          ..where(db.tags.name.lower().like(like))
          ..limit(10))
        .get();
    for (final r in tagRows) {
      final l = r.readTable(db.tagLinks);
      final t = r.readTable(db.tags);
      final type = enumFromName(EntityType.values, l.entityType, EntityType.platform);
      if (type == EntityType.secureItem) continue;
      if (out.any((h) => h.type == type && h.id == l.entityId)) continue;
      out.add(SearchHit(type: type, id: l.entityId, title: '#${t.name}', subtitle: type.label));
    }

    return out.take(limit).toList();
  }
}
