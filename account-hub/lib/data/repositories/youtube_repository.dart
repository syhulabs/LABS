import 'package:drift/drift.dart';

import '../../core/ids.dart';
import '../../core/streams.dart';
import '../../domain/enums.dart';
import '../db/app_database.dart';
import 'audit_repository.dart';

class ChannelView {
  const ChannelView(this.channel, this.owner, this.managers);
  final YoutubeChannel channel;
  final EmailIdentity? owner;
  final List<(EmailIdentity, ChannelRole)> managers;
}

class YoutubeRepository {
  YoutubeRepository(this.db, this.audit);
  final AppDatabase db;
  final AuditRepository audit;

  Stream<List<ChannelView>> watchAll({bool includeArchived = false}) {
    final channels = db.select(db.youtubeChannels).join([
      leftOuterJoin(db.emailIdentities, db.emailIdentities.id.equalsExp(db.youtubeChannels.ownerEmailId)),
    ])
      ..orderBy([OrderingTerm.asc(db.youtubeChannels.name)]);
    if (!includeArchived) channels.where(db.youtubeChannels.archivedAt.isNull());
    final managers = db.select(db.channelManagers).join([
      innerJoin(db.emailIdentities, db.emailIdentities.id.equalsExp(db.channelManagers.emailIdentityId)),
    ]);
    return combine2(channels.watch(), managers.watch()).map((t) {
      final (rows, mrows) = t;
      final byChannel = <String, List<(EmailIdentity, ChannelRole)>>{};
      for (final r in mrows) {
        final m = r.readTable(db.channelManagers);
        byChannel.putIfAbsent(m.channelId, () => []).add((
          r.readTable(db.emailIdentities),
          enumFromName(ChannelRole.values, m.role, ChannelRole.manager),
        ));
      }
      return rows.map((r) {
        final c = r.readTable(db.youtubeChannels);
        return ChannelView(c, r.readTableOrNull(db.emailIdentities), byChannel[c.id] ?? const []);
      }).toList();
    });
  }

  Stream<ChannelView?> watchById(String id) =>
      watchAll(includeArchived: true).map((l) => l.where((c) => c.channel.id == id).firstOrNull);

  /// Channels grouped by owning Google identity (null key = no owner set).
  static Map<EmailIdentity?, List<ChannelView>> groupByOwner(List<ChannelView> all) {
    final map = <String?, (EmailIdentity?, List<ChannelView>)>{};
    for (final c in all) {
      final key = c.owner?.id;
      map.putIfAbsent(key, () => (c.owner, [])).$2.add(c);
    }
    return {for (final e in map.values) e.$1: e.$2};
  }

  Future<YoutubeChannel> upsert({
    String? id,
    required String name,
    String? handle,
    String? channelId,
    String? url,
    String? channelType,
    String? purpose,
    String? brandingNotes,
    AccountStatus status = AccountStatus.active,
    String? ownerEmailId,
    String? artistId,
    String? organizationId,
    String? notes,
    List<(String emailId, ChannelRole role)> managers = const [],
  }) async {
    if (name.trim().isEmpty) throw ArgumentError('Channel name is required');
    final rowId = id ?? newId();
    final c = YoutubeChannelsCompanion(
      id: Value(rowId),
      name: Value(name.trim()),
      handle: Value(_handle(handle)),
      channelId: Value(_clean(channelId)),
      url: Value(_clean(url)),
      channelType: Value(_clean(channelType)),
      purpose: Value(_clean(purpose)),
      brandingNotes: Value(_clean(brandingNotes)),
      status: Value(status.name),
      ownerEmailId: Value(ownerEmailId),
      artistId: Value(artistId),
      organizationId: Value(organizationId),
      notes: Value(_clean(notes)),
      updatedAt: Value(DateTime.now()),
    );
    await db.transaction(() async {
      if (id == null) {
        await db.into(db.youtubeChannels).insert(c);
      } else {
        await (db.update(db.youtubeChannels)..where((x) => x.id.equals(id))).write(c);
        await (db.delete(db.channelManagers)..where((m) => m.channelId.equals(id))).go();
      }
      final seen = <String>{};
      for (final (emailId, role) in managers) {
        if (emailId == ownerEmailId || !seen.add(emailId)) continue;
        await db.into(db.channelManagers).insert(ChannelManagersCompanion.insert(
              channelId: rowId,
              emailIdentityId: emailId,
              role: Value(role.name),
            ));
      }
    });
    await audit.log(id == null ? 'channel.create' : 'channel.update',
        type: EntityType.youtubeChannel, id: rowId, summary: '${id == null ? 'Added' : 'Updated'} YouTube channel "${name.trim()}"');
    return (db.select(db.youtubeChannels)..where((x) => x.id.equals(rowId))).getSingle();
  }

  Future<void> setArchived(String id, bool archived) =>
      (db.update(db.youtubeChannels)..where((c) => c.id.equals(id)))
          .write(YoutubeChannelsCompanion(archivedAt: Value(archived ? DateTime.now() : null)));

  Future<void> delete(String id) async {
    await db.transaction(() async {
      await (db.delete(db.channelManagers)..where((m) => m.channelId.equals(id))).go();
      await (db.delete(db.links)
            ..where((l) =>
                (l.fromType.equals(EntityType.youtubeChannel.name) & l.fromId.equals(id)) |
                (l.toType.equals(EntityType.youtubeChannel.name) & l.toId.equals(id))))
          .go();
      await (db.delete(db.tagLinks)..where((t) => t.entityType.equals(EntityType.youtubeChannel.name) & t.entityId.equals(id))).go();
      await (db.delete(db.customFields)..where((t) => t.entityType.equals(EntityType.youtubeChannel.name) & t.entityId.equals(id))).go();
      await (db.delete(db.youtubeChannels)..where((c) => c.id.equals(id))).go();
    });
    await audit.log('channel.delete', type: EntityType.youtubeChannel, id: id, summary: 'Deleted YouTube channel');
  }

  Future<int> countActive() async {
    final c = db.youtubeChannels.id.count();
    final row = await (db.selectOnly(db.youtubeChannels)
          ..addColumns([c])
          ..where(db.youtubeChannels.archivedAt.isNull()))
        .getSingle();
    return row.read(c) ?? 0;
  }

  static String? _clean(String? s) {
    final t = s?.trim();
    return (t == null || t.isEmpty) ? null : t;
  }

  static String? _handle(String? s) {
    final t = _clean(s);
    if (t == null) return null;
    return t.startsWith('@') ? t : '@$t';
  }
}
