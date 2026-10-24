import 'package:drift/drift.dart';

import '../../core/ids.dart';
import '../../core/json_list.dart';
import '../../domain/enums.dart';
import '../db/app_database.dart';
import 'audit_repository.dart';

class PlatformRepository {
  PlatformRepository(this.db, this.audit);
  final AppDatabase db;
  final AuditRepository audit;

  Stream<List<Platform>> watchAll() =>
      (db.select(db.platforms)..orderBy([(p) => OrderingTerm.asc(p.name)])).watch();

  Stream<List<Platform>> watchMyWorld() => (db.select(db.platforms)
        ..where((p) => p.inMyWorld.equals(true))
        ..orderBy([
          (p) => OrderingTerm.asc(p.sortOrder),
          (p) => OrderingTerm.asc(p.name),
        ]))
      .watch();

  Stream<List<Platform>> watchFavorites() => (db.select(db.platforms)
        ..where((p) => p.isFavorite.equals(true))
        ..orderBy([(p) => OrderingTerm.asc(p.name)]))
      .watch();

  Future<Platform?> byId(String id) =>
      (db.select(db.platforms)..where((p) => p.id.equals(id))).getSingleOrNull();

  Stream<Platform?> watchById(String id) =>
      (db.select(db.platforms)..where((p) => p.id.equals(id))).watchSingleOrNull();

  /// In-memory filter helper used by Explore and category hubs.
  static List<Platform> filter(
    List<Platform> all, {
    String query = '',
    String? category,
    String? vendor,
    bool onlyMyWorld = false,
    bool onlyFavorites = false,
  }) {
    final q = query.trim().toLowerCase();
    return all.where((p) {
      if (onlyMyWorld && !p.inMyWorld) return false;
      if (onlyFavorites && !p.isFavorite) return false;
      if (vendor != null && p.vendor != vendor) return false;
      if (category != null && !decodeStringList(p.categories).contains(category)) {
        return false;
      }
      if (q.isEmpty) return true;
      return p.name.toLowerCase().contains(q) ||
          p.description.toLowerCase().contains(q) ||
          (p.website ?? '').toLowerCase().contains(q) ||
          decodeStringList(p.categories).any((c) => c.contains(q));
    }).toList();
  }

  Future<void> setInMyWorld(String id, bool value) async {
    await (db.update(db.platforms)..where((p) => p.id.equals(id))).write(
      PlatformsCompanion(
        inMyWorld: Value(value),
        addedToMyWorldAt: Value(value ? DateTime.now() : null),
      ),
    );
    final p = await byId(id);
    await audit.log(value ? 'myworld.add' : 'myworld.remove',
        type: EntityType.platform,
        id: id,
        summary: value ? 'Added ${p?.name ?? id} to My World' : 'Removed ${p?.name ?? id} from My World');
  }

  Future<void> setFavorite(String id, bool value) =>
      (db.update(db.platforms)..where((p) => p.id.equals(id)))
          .write(PlatformsCompanion(isFavorite: Value(value)));

  Future<void> saveOrder(List<String> orderedIds) async {
    await db.batch((b) {
      for (var i = 0; i < orderedIds.length; i++) {
        b.update(
          db.platforms,
          PlatformsCompanion(sortOrder: Value(i)),
          where: (p) => p.id.equals(orderedIds[i]),
        );
      }
    });
  }

  /// Creates a user-defined platform that is not in the catalog.
  Future<Platform> createCustom({
    required String name,
    required List<String> categories,
    String? website,
    String description = '',
    bool addToMyWorld = true,
  }) async {
    final id = customPlatformId(name);
    await db.into(db.platforms).insert(PlatformsCompanion.insert(
          id: id,
          name: name.trim(),
          categories: encodeStringList(categories),
          website: Value(website?.trim().isEmpty ?? true ? null : website!.trim()),
          description: Value(description),
          isCustom: const Value(true),
          inMyWorld: Value(addToMyWorld),
          addedToMyWorldAt: Value(addToMyWorld ? DateTime.now() : null),
        ));
    await audit.log('platform.create', type: EntityType.platform, id: id, summary: 'Created custom platform $name');
    return (await byId(id))!;
  }

  Future<void> updateCustom(String id, {required String name, required List<String> categories, String? website, String description = ''}) async {
    await (db.update(db.platforms)..where((p) => p.id.equals(id) & p.isCustom.equals(true))).write(
      PlatformsCompanion(
        name: Value(name.trim()),
        categories: Value(encodeStringList(categories)),
        website: Value(website?.trim().isEmpty ?? true ? null : website!.trim()),
        description: Value(description),
      ),
    );
  }

  /// Deletes a custom platform. Fails if accounts still reference it.
  Future<bool> deleteCustom(String id) async {
    final usage = await (db.select(db.serviceAccounts)..where((a) => a.platformId.equals(id))).get();
    if (usage.isNotEmpty) return false;
    final n = await (db.delete(db.platforms)..where((p) => p.id.equals(id) & p.isCustom.equals(true))).go();
    if (n > 0) {
      await audit.log('platform.delete', type: EntityType.platform, id: id, summary: 'Deleted custom platform');
    }
    return n > 0;
  }
}
