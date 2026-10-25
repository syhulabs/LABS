import 'dart:convert';

import 'package:flutter/services.dart' show AssetBundle, rootBundle;

import '../db/app_database.dart';
import 'plan_models.dart';

/// Reference data: published subscription plans and their prices per country
/// and purchase channel. Loaded from the bundled asset; a user-imported update
/// file (same shape) is stored in the settings table and overrides bundled
/// services by platformId. Nothing is ever fetched from the network.
class PlanCatalogService {
  PlanCatalogService(this.db, {AssetBundle? bundle}) : _bundle = bundle ?? rootBundle;

  final AppDatabase db;
  final AssetBundle _bundle;

  static const assetPath = 'assets/catalog/plans.json';

  /// Settings key for the user-imported document. The `blob.` prefix keeps it
  /// out of the reactive settings map.
  static const userDocumentKey = 'blob.plans.userDocument';

  PlanCatalogDocument _bundled = PlanCatalogDocument.empty;
  PlanCatalogDocument? _imported;
  Map<String, ServicePlans> _byPlatform = const {};
  bool _loaded = false;

  bool get isLoaded => _loaded;
  PlanCatalogDocument get bundled => _bundled;
  PlanCatalogDocument? get imported => _imported;
  int get serviceCount => _byPlatform.length;
  Iterable<ServicePlans> get services => _byPlatform.values;

  /// Newest "generatedAt" of the documents in use.
  DateTime? get generatedAt {
    final a = _bundled.generatedAt;
    final b = _imported?.generatedAt;
    if (a == null) return b;
    if (b == null) return a;
    return b.isAfter(a) ? b : a;
  }

  /// Loads the bundled file and any imported override. Safe to call again.
  Future<void> load() async {
    try {
      final raw = await _bundle.loadString(assetPath);
      _bundled = PlanCatalogDocument.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      _bundled = PlanCatalogDocument.empty;
    }
    _imported = null;
    try {
      final row = await (db.select(db.settings)..where((s) => s.key.equals(userDocumentKey))).getSingleOrNull();
      if (row != null) _imported = PlanCatalogDocument.fromJson(jsonDecode(row.value) as Map<String, dynamic>);
    } catch (_) {
      _imported = null;
    }
    _rebuild();
    _loaded = true;
  }

  ServicePlans? plansFor(String? platformId) => platformId == null ? null : _byPlatform[platformId];

  /// Validates and stores a user-supplied plans JSON file. Returns the number
  /// of services in the file. The file replaces any earlier import.
  Future<int> importFromJsonString(String raw) async {
    final doc = PlanCatalogDocument.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    await db.into(db.settings).insertOnConflictUpdate(SettingsCompanion.insert(key: userDocumentKey, value: jsonEncode(doc.toJson())));
    _imported = doc;
    _rebuild();
    return doc.services.length;
  }

  Future<void> clearImported() async {
    await (db.delete(db.settings)..where((s) => s.key.equals(userDocumentKey))).go();
    _imported = null;
    _rebuild();
  }

  void _rebuild() {
    final map = <String, ServicePlans>{for (final s in _bundled.services) s.platformId: s};
    for (final s in _imported?.services ?? const <ServicePlans>[]) {
      map[s.platformId] = s;
    }
    _byPlatform = map;
  }
}
