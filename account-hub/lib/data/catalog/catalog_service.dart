import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/services.dart' show AssetBundle, rootBundle;

import '../../core/json_list.dart';
import '../db/app_database.dart';
import 'catalog_models.dart';

/// Loads the bundled catalog into the `platforms` table and supports importing
/// catalog update files. User-owned columns (`inMyWorld`, `isFavorite`,
/// `sortOrder`, `addedToMyWorldAt`) are never touched by an import.
class CatalogService {
  CatalogService(this.db, {AssetBundle? bundle}) : _bundle = bundle ?? rootBundle;

  final AppDatabase db;
  final AssetBundle _bundle;

  static const assetPath = 'assets/catalog/platforms.json';
  static const _settingKey = 'catalog.importedVersion';

  List<CatalogCategory> _categories = const [];
  List<CatalogCategory> get categories => _categories;

  Future<CatalogDocument> loadBundled() async {
    final raw = await _bundle.loadString(assetPath);
    return CatalogDocument.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  /// Seeds/updates the catalog from the bundled asset if its version is newer
  /// than the last import (or on first launch). Returns rows upserted.
  Future<int> ensureSeeded() async {
    final doc = await loadBundled();
    _categories = doc.categories;
    final imported = await _importedVersion();
    if (imported != null && imported >= doc.version) {
      // Still make sure nothing is missing (e.g. after a partial failure).
      final count = await (db.selectOnly(db.platforms)
            ..addColumns([db.platforms.id.count()]))
          .map((r) => r.read(db.platforms.id.count()) ?? 0)
          .getSingle();
      if (count >= doc.platforms.length) return 0;
    }
    final n = await importDocument(doc);
    await _setImportedVersion(doc.version);
    return n;
  }

  /// Imports a catalog document (bundled or user-provided). Upsert by id.
  Future<int> importDocument(CatalogDocument doc) async {
    var n = 0;
    await db.batch((b) {
      for (final p in doc.platforms) {
        b.insert(
          db.platforms,
          PlatformsCompanion.insert(
            id: p.id,
            name: p.name,
            categories: encodeStringList(p.categories),
            website: Value(p.website),
            description: Value(p.description),
            platformType: Value(p.type),
            vendor: Value(p.vendor),
            iconSlug: Value(p.icon),
            logoAsset: Value(p.logoAsset),
            catalogVersion: Value(doc.version),
          ),
          onConflict: DoUpdate(
            (_) => PlatformsCompanion(
              name: Value(p.name),
              categories: Value(encodeStringList(p.categories)),
              website: Value(p.website),
              description: Value(p.description),
              platformType: Value(p.type),
              vendor: Value(p.vendor),
              iconSlug: Value(p.icon),
              logoAsset: Value(p.logoAsset),
              catalogVersion: Value(doc.version),
            ),
            target: [db.platforms.id],
          ),
        );
        n++;
      }
    });
    if (doc.categories.isNotEmpty) {
      final merged = {for (final c in _categories) c.id: c};
      for (final c in doc.categories) {
        merged[c.id] = c;
      }
      _categories = merged.values.toList();
    }
    return n;
  }

  /// Parses and imports a user-supplied JSON catalog file. Validates shape and
  /// duplicate ids before touching the database.
  Future<int> importFromJsonString(String raw) async {
    final doc = CatalogDocument.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    return importDocument(doc);
  }

  String categoryLabel(String id) {
    for (final c in _categories) {
      if (c.id == id) return c.label;
    }
    return id;
  }

  Future<int?> _importedVersion() async {
    final row = await (db.select(db.settings)
          ..where((s) => s.key.equals(_settingKey)))
        .getSingleOrNull();
    return row == null ? null : int.tryParse(row.value);
  }

  Future<void> _setImportedVersion(int v) => db.into(db.settings).insertOnConflictUpdate(
        SettingsCompanion.insert(key: _settingKey, value: '$v'),
      );
}

extension PlatformCategories on Platform {
  List<String> get categoryIds => decodeStringList(categories);
}
