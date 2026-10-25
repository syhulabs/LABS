import 'dart:convert';

import '../../domain/markets.dart';
import '../db/app_database.dart';

/// Typed access to the key/value settings table. Values are JSON.
class SettingsRepository {
  SettingsRepository(this.db);
  final AppDatabase db;

  static const kDisplayName = 'profile.displayName';
  static const kThemeMode = 'ui.themeMode'; // system | light | dark
  static const kDefaultCurrency = 'finance.defaultCurrency';
  /// ISO-3166 alpha-2 market the app is set to (drives plan prices).
  static const kCountry = 'profile.country';
  /// web | ios | android: where the user usually buys subscriptions.
  static const kPurchaseChannel = 'subscriptions.purchaseChannel';
  static const kDashboardOrder = 'dashboard.order';
  static const kDashboardHidden = 'dashboard.hidden';
  static const kSidebarCollapsed = 'ui.sidebarCollapsedGroups';
  static const kLockEnabled = 'security.lockEnabled';
  static const kLockTimeoutSeconds = 'security.lockTimeoutSeconds';
  static const kClipboardClearSeconds = 'security.clipboardClearSeconds';
  static const kRenewalReminderDays = 'subscriptions.reminderDays';
  static const kNotificationsEnabled = 'notifications.enabled';
  static const kOnboarded = 'app.onboarded';
  static const kLastBackupAt = 'backup.lastAt';

  Stream<Map<String, dynamic>> watchAll() => db.select(db.settings).watch().map((rows) {
        final out = <String, dynamic>{};
        for (final r in rows) {
          // Large documents (imported plan catalogs...) live under `blob.`
          // and are read directly by their service, never through this map.
          if (r.key.startsWith('blob.')) continue;
          try {
            out[r.key] = jsonDecode(r.value);
          } catch (_) {
            out[r.key] = r.value;
          }
        }
        return out;
      });

  Future<T?> get<T>(String key) async {
    final row = await (db.select(db.settings)..where((s) => s.key.equals(key))).getSingleOrNull();
    if (row == null) return null;
    try {
      final v = jsonDecode(row.value);
      return v is T ? v : null;
    } catch (_) {
      return row.value is T ? row.value as T : null;
    }
  }

  Future<void> set(String key, Object? value) => db.into(db.settings).insertOnConflictUpdate(
        SettingsCompanion.insert(key: key, value: jsonEncode(value)),
      );

  Future<void> remove(String key) => (db.delete(db.settings)..where((s) => s.key.equals(key))).go();
}

/// Dashboard sections the user can reorder or hide.
enum DashboardSection {
  welcome,
  stats,
  myWorld,
  upcoming,
  recent,
  favorites,
  security,
  quickActions;

  String get label => switch (this) {
        DashboardSection.welcome => 'Welcome',
        DashboardSection.stats => 'Overview numbers',
        DashboardSection.myWorld => 'My World',
        DashboardSection.upcoming => 'Upcoming renewals',
        DashboardSection.recent => 'Recently accessed',
        DashboardSection.favorites => 'Favorites',
        DashboardSection.security => 'Security overview',
        DashboardSection.quickActions => 'Quick actions',
      };
}

extension SettingsMapX on Map<String, dynamic> {
  String? get displayName => this[SettingsRepository.kDisplayName] as String?;
  String get themeMode => (this[SettingsRepository.kThemeMode] as String?) ?? 'dark';
  String get defaultCurrency => (this[SettingsRepository.kDefaultCurrency] as String?) ?? 'INR';

  /// Chosen market; before the user picks one it follows the default currency.
  Market get market => marketByCode(this[SettingsRepository.kCountry] as String?) ?? marketForCurrency(defaultCurrency);
  String get country => market.code;
  PurchaseChannel get purchaseChannel => PurchaseChannel.tryParse(this[SettingsRepository.kPurchaseChannel] as String?) ?? PurchaseChannel.web;
  bool get lockEnabled => (this[SettingsRepository.kLockEnabled] as bool?) ?? false;
  int get lockTimeoutSeconds => (this[SettingsRepository.kLockTimeoutSeconds] as num?)?.toInt() ?? 300;
  int get clipboardClearSeconds => (this[SettingsRepository.kClipboardClearSeconds] as num?)?.toInt() ?? 30;
  int get renewalReminderDays => (this[SettingsRepository.kRenewalReminderDays] as num?)?.toInt() ?? 3;
  bool get notificationsEnabled => (this[SettingsRepository.kNotificationsEnabled] as bool?) ?? true;
  bool get onboarded => (this[SettingsRepository.kOnboarded] as bool?) ?? false;
  Set<String> get sidebarCollapsed => ((this[SettingsRepository.kSidebarCollapsed] as List?) ?? const []).map((e) => e.toString()).toSet();

  List<DashboardSection> get dashboardOrder {
    final stored = ((this[SettingsRepository.kDashboardOrder] as List?) ?? const []).map((e) => e.toString()).toList();
    final out = <DashboardSection>[];
    for (final name in stored) {
      final s = DashboardSection.values.where((d) => d.name == name).firstOrNull;
      if (s != null && !out.contains(s)) out.add(s);
    }
    for (final s in DashboardSection.values) {
      if (!out.contains(s)) out.add(s);
    }
    return out;
  }

  Set<DashboardSection> get dashboardHidden {
    final stored = ((this[SettingsRepository.kDashboardHidden] as List?) ?? const []).map((e) => e.toString()).toSet();
    return DashboardSection.values.where((d) => stored.contains(d.name)).toSet();
  }
}
