import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/settings_repository.dart';
import '../shared/widgets/platform_logo.dart';
import 'providers.dart';

/// Startup work that needs the database: seed the catalog, register the
/// bundled logo files, configure the app lock and plan reminders. Each step
/// fails soft so a problem in one never blocks launch.
Future<void> bootstrap(ProviderContainer container, {bool notifications = true}) async {
  try {
    await container.read(catalogServiceProvider).ensureSeeded();
  } catch (e, st) {
    // The app still works without the catalog: users can add custom platforms.
    // ignore: avoid_print
    print('Catalog seed failed: $e\n$st');
  }
  try {
    final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
    PlatformLogo.setAvailableLogos(manifest.listAssets());
  } catch (_) {
    PlatformLogo.setAvailableLogos(const []);
  }
  try {
    final raw = await rootBundle.loadString('assets/logos/manifest.json');
    PlatformLogo.setToneManifest(jsonDecode(raw) as Map<String, dynamic>);
  } catch (_) {}
  try {
    final settings = container.read(settingsRepositoryProvider);
    final enabled = await settings.get<bool>(SettingsRepository.kLockEnabled) ?? false;
    final timeout = (await settings.get<num>(SettingsRepository.kLockTimeoutSeconds))?.toInt() ?? 300;
    final clip = (await settings.get<num>(SettingsRepository.kClipboardClearSeconds))?.toInt() ?? 30;
    await container.read(appLockProvider).configure(enabled: enabled, timeoutSeconds: timeout);
    container.read(clipboardServiceProvider).clearAfter = Duration(seconds: clip);
  } catch (_) {}
  if (notifications) {
    try {
      final ns = container.read(notificationServiceProvider);
      if (await ns.initialize()) {
        final settings = container.read(settingsRepositoryProvider);
        final enabled = await settings.get<bool>(SettingsRepository.kNotificationsEnabled) ?? true;
        final days = (await settings.get<num>(SettingsRepository.kRenewalReminderDays))?.toInt() ?? 3;
        final subs = await container.read(subscriptionRepositoryProvider).watchAll().first;
        await ns.rescheduleRenewals(subs, daysBefore: days, enabled: enabled);
      }
    } catch (_) {}
  }
}
