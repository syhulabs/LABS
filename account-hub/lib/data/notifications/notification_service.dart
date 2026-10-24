import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_10y.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../repositories/subscription_repository.dart';

/// Local renewal reminders. Notification text names the service only: no
/// amounts, no account identifiers, no secrets.
class NotificationService {
  NotificationService({FlutterLocalNotificationsPlugin? plugin}) : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;
  bool _initialized = false;
  bool get isSupported => !kIsWeb && (Platform.isMacOS || Platform.isIOS || Platform.isAndroid || Platform.isLinux);

  Future<bool> initialize() async {
    if (_initialized || !isSupported) return _initialized;
    tzdata.initializeTimeZones();
    const darwin = DarwinInitializationSettings(requestAlertPermission: true, requestBadgePermission: true, requestSoundPermission: false);
    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: darwin,
      macOS: darwin,
      linux: LinuxInitializationSettings(defaultActionName: 'Open'),
    );
    try {
      final ok = await _plugin.initialize(settings: settings);
      _initialized = ok ?? true;
      if (Platform.isAndroid) {
        await _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
      }
    } catch (e) {
      debugPrint('Notifications unavailable: $e');
      _initialized = false;
    }
    return _initialized;
  }

  static const _channel = AndroidNotificationDetails('renewals', 'Subscription renewals', channelDescription: 'Upcoming subscription renewals', importance: Importance.defaultImportance);
  static const _details = NotificationDetails(android: _channel, iOS: DarwinNotificationDetails(), macOS: DarwinNotificationDetails(), linux: LinuxNotificationDetails());

  /// Re-plans every reminder: cancels existing ones and schedules a reminder
  /// [daysBefore] each upcoming renewal (at 09:00 local), plus one on the day.
  Future<int> rescheduleRenewals(List<SubscriptionView> subs, {required int daysBefore, required bool enabled}) async {
    if (!_initialized) return 0;
    await _plugin.cancelAll();
    if (!enabled) return 0;
    var scheduled = 0;
    final now = DateTime.now();
    for (final s in subs) {
      if (!s.sub.remindersEnabled || !s.status.isRecurringCost) continue;
      final next = s.sub.nextBillingDate;
      if (next == null) continue;
      for (final offset in {daysBefore, 0}) {
        final at = DateTime(next.year, next.month, next.day, 9).subtract(Duration(days: offset));
        if (!at.isAfter(now)) continue;
        final body = offset == 0 ? '${s.sub.serviceName} renews today.' : '${s.sub.serviceName} renews in $offset day${offset == 1 ? '' : 's'}.';
        try {
          await _plugin.zonedSchedule(
            id: _idFor(s.sub.id, offset),
            title: 'Subscription renewal',
            body: body,
            scheduledDate: tz.TZDateTime.from(at.toUtc(), tz.UTC),
            notificationDetails: _details,
            androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
            payload: 'subscription:${s.sub.id}',
          );
          scheduled++;
        } catch (e) {
          debugPrint('Could not schedule reminder: $e');
        }
      }
    }
    return scheduled;
  }

  Future<void> showTest() async {
    if (!_initialized) return;
    await _plugin.show(id: 1, title: 'SYHU Account Hub', body: 'Notifications are working.', notificationDetails: _details);
  }

  static int _idFor(String subscriptionId, int offset) => (subscriptionId.hashCode & 0x3FFFFFFF) ^ offset;
}
