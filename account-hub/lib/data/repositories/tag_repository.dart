import 'package:drift/drift.dart';

import '../../core/ids.dart';
import '../../domain/enums.dart';
import '../db/app_database.dart';

/// Tags and non-secret custom fields attachable to any entity.
class TagRepository {
  TagRepository(this.db);
  final AppDatabase db;

  Stream<List<Tag>> watchTags() => (db.select(db.tags)..orderBy([(t) => OrderingTerm.asc(t.name)])).watch();

  Future<Tag> ensureTag(String name, {int? color}) async {
    final n = name.trim();
    if (n.isEmpty) throw ArgumentError('Tag name is required');
    final existing = await (db.select(db.tags)..where((t) => t.name.lower().equals(n.toLowerCase()))).getSingleOrNull();
    if (existing != null) return existing;
    final id = newId();
    await db.into(db.tags).insert(TagsCompanion.insert(id: id, name: n, color: Value(color)));
    return (db.select(db.tags)..where((t) => t.id.equals(id))).getSingle();
  }

  Future<void> deleteTag(String id) async {
    await db.transaction(() async {
      await (db.delete(db.tagLinks)..where((l) => l.tagId.equals(id))).go();
      await (db.delete(db.tags)..where((t) => t.id.equals(id))).go();
    });
  }

  Stream<List<Tag>> watchTagsFor(EntityType type, String id) {
    final q = db.select(db.tagLinks).join([innerJoin(db.tags, db.tags.id.equalsExp(db.tagLinks.tagId))])
      ..where(db.tagLinks.entityType.equals(type.name) & db.tagLinks.entityId.equals(id));
    return q.watch().map((rows) => rows.map((r) => r.readTable(db.tags)).toList()..sort((a, b) => a.name.compareTo(b.name)));
  }

  /// Entity ids (by type) that carry a tag; used by search and filters.
  Stream<List<TagLink>> watchLinksForTag(String tagId) =>
      (db.select(db.tagLinks)..where((l) => l.tagId.equals(tagId))).watch();

  Future<void> setTags(EntityType type, String id, List<String> names) async {
    await db.transaction(() async {
      await (db.delete(db.tagLinks)..where((l) => l.entityType.equals(type.name) & l.entityId.equals(id))).go();
      for (final n in names.map((e) => e.trim()).where((e) => e.isNotEmpty).toSet()) {
        final tag = await ensureTag(n);
        await db.into(db.tagLinks).insert(
              TagLinksCompanion.insert(tagId: tag.id, entityType: type.name, entityId: id),
              mode: InsertMode.insertOrIgnore,
            );
      }
    });
  }

  // ---------- Custom fields ----------
  Stream<List<CustomField>> watchFields(EntityType type, String id) => (db.select(db.customFields)
        ..where((f) => f.entityType.equals(type.name) & f.entityId.equals(id))
        ..orderBy([(f) => OrderingTerm.asc(f.sortOrder)]))
      .watch();

  Future<void> setFields(EntityType type, String id, List<(String label, String value)> fields) async {
    await db.transaction(() async {
      await (db.delete(db.customFields)..where((f) => f.entityType.equals(type.name) & f.entityId.equals(id))).go();
      var i = 0;
      for (final (label, value) in fields) {
        if (label.trim().isEmpty) continue;
        await db.into(db.customFields).insert(CustomFieldsCompanion.insert(
              id: newId(), entityType: type.name, entityId: id, label: label.trim(), value: value.trim(), sortOrder: Value(i++),
            ));
      }
    });
  }
}
