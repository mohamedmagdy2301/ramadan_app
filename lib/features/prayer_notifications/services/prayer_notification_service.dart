import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../home/domain/prayer_times_entity.dart';
import '../domain/entities/adhan_sound.dart';
import '../domain/entities/prayer_notification_settings.dart';

/// Abstract interface for prayer notification service
abstract class IPrayerNotificationService {
  Future<void> initialize();
  Future<void> schedulePrayerNotification({
    required PrayerType prayer,
    required int hour,
    required int minute,
    bool withPreAlert = false,
    int preAlertMinutes = 0,
    bool soundEnabled = true,
    AdhanSound? adhanSound,
  });
  Future<void> scheduleAllPrayerNotifications({
    required PrayerTimesEntity prayerTimes,
    required PrayerNotificationSettings settings,
  });
  Future<void> cancelPrayerNotification(PrayerType prayer);
  Future<void> cancelAllPrayerNotifications();
}

/// Service for managing prayer time notifications
class PrayerNotificationService implements IPrayerNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static bool _isInitialized = false;

  // Singleton instance
  static PrayerNotificationService? _instance;

  static PrayerNotificationService get instance {
    _instance ??= PrayerNotificationService._internal();
    return _instance!;
  }

  PrayerNotificationService._internal();

  // Static methods for convenience
  static Future<void> initializeStatic() async {
    await instance.initialize();
  }

  static Future<void> schedulePrayerNotificationStatic({
    required PrayerType prayer,
    required int hour,
    required int minute,
    bool withPreAlert = false,
    int preAlertMinutes = 0,
    bool soundEnabled = true,
    AdhanSound? adhanSound,
  }) async {
    await instance.schedulePrayerNotification(
      prayer: prayer,
      hour: hour,
      minute: minute,
      withPreAlert: withPreAlert,
      preAlertMinutes: preAlertMinutes,
      soundEnabled: soundEnabled,
      adhanSound: adhanSound,
    );
  }

  static Future<void> scheduleAllPrayerNotificationsStatic({
    required PrayerTimesEntity prayerTimes,
    required PrayerNotificationSettings settings,
  }) async {
    await instance.scheduleAllPrayerNotifications(
      prayerTimes: prayerTimes,
      settings: settings,
    );
  }

  static Future<void> cancelPrayerNotificationStatic(PrayerType prayer) async {
    await instance.cancelPrayerNotification(prayer);
  }

  static Future<void> cancelAllPrayerNotificationsStatic() async {
    await instance.cancelAllPrayerNotifications();
  }

  /// Initialize the notification service
  @override
  Future<void> initialize() async {
    if (_isInitialized) return;

    tz.initializeTimeZones();
    final localTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(localTimeZone.identifier));

    _isInitialized = true;
  }

  /// Schedule notification for a specific prayer
  @override
  Future<void> schedulePrayerNotification({
    required PrayerType prayer,
    required int hour,
    required int minute,
    bool withPreAlert = false,
    int preAlertMinutes = 0,
    bool soundEnabled = true,
    AdhanSound? adhanSound,
  }) async {
    await _ensureInitialized();

    // Get the sound name to use
    final soundName = adhanSound?.rawResourceName;

    // Schedule main prayer notification with adhan sound
    await _scheduleNotification(
      id: prayer.notificationId,
      title: 'حان وقت صلاة ${prayer.arabicName}',
      body: 'حي على الصلاة، حي على الفلاح',
      hour: hour,
      minute: minute,
      channelId: 'prayer_notification_channel',
      channelName: 'إشعارات الصلاة',
      soundName: soundName,
      playSound: soundEnabled,
    );

    // Schedule pre-alert notification if enabled (uses reminder sound, not adhan)
    if (withPreAlert && preAlertMinutes > 0) {
      final preAlertTime = _subtractMinutes(hour, minute, preAlertMinutes);
      await _scheduleNotification(
        id: prayer.preAlertNotificationId,
        title: 'تذكير: صلاة ${prayer.arabicName}',
        body: 'باقي $preAlertMinutes دقيقة على صلاة ${prayer.arabicName}',
        hour: preAlertTime['hour']!,
        minute: preAlertTime['minute']!,
        channelId: 'prayer_pre_alert_channel',
        channelName: 'تذكيرات الصلاة',
        soundName: 'sound_test', // Use reminder sound for pre-alerts
        playSound: soundEnabled,
      );
    }
  }

  /// Schedule all prayer notifications for today
  @override
  Future<void> scheduleAllPrayerNotifications({
    required PrayerTimesEntity prayerTimes,
    required PrayerNotificationSettings settings,
  }) async {
    await _ensureInitialized();

    // Cancel all previous prayer notifications
    await cancelAllPrayerNotifications();

    // Get the adhan sound from settings
    final adhanSound = AdhanSound.fromString(settings.selectedAdhan);

    final prayers = {
      PrayerType.fajr: prayerTimes.fajrTime,
      PrayerType.dhuhr: prayerTimes.dhuhrTime,
      PrayerType.asr: prayerTimes.asrTime,
      PrayerType.maghrib: prayerTimes.maghribTime,
      PrayerType.isha: prayerTimes.ishaTime,
    };

    for (final entry in prayers.entries) {
      final prayer = entry.key;
      final timeString = entry.value;

      if (!settings.isPrayerEnabled(prayer)) continue;

      final time = _parseTimeString(timeString);
      if (time == null) continue;

      await schedulePrayerNotification(
        prayer: prayer,
        hour: time['hour']!,
        minute: time['minute']!,
        withPreAlert: settings.preAlertMinutes > 0,
        preAlertMinutes: settings.preAlertMinutes,
        soundEnabled: settings.soundEnabled,
        adhanSound: adhanSound,
      );
    }
  }

  /// Cancel notification for a specific prayer
  @override
  Future<void> cancelPrayerNotification(PrayerType prayer) async {
    await _notificationsPlugin.cancel(prayer.notificationId);
    await _notificationsPlugin.cancel(prayer.preAlertNotificationId);
  }

  /// Cancel all prayer notifications
  @override
  Future<void> cancelAllPrayerNotifications() async {
    for (final prayer in PrayerType.values) {
      await cancelPrayerNotification(prayer);
    }
  }

  /// Get list of pending notifications (for debugging)
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notificationsPlugin.pendingNotificationRequests();
  }

  /// Check if a specific prayer notification is scheduled
  Future<bool> isPrayerNotificationScheduled(PrayerType prayer) async {
    final pending = await getPendingNotifications();
    return pending.any((n) =>
        n.id == prayer.notificationId ||
        n.id == prayer.preAlertNotificationId);
  }

  // Private helper methods

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initialize();
    }
  }

  Future<void> _scheduleNotification({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
    required String channelId,
    required String channelName,
    String? soundName,
    bool playSound = true,
  }) async {
    // Determine the sound to use
    AndroidNotificationSound? androidSound;
    if (playSound && soundName != null) {
      androidSound = RawResourceAndroidNotificationSound(soundName);
    } else if (playSound) {
      // Default to system sound
      androidSound = null; // Uses default notification sound
    }

    final notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        channelId,
        channelName,
        channelDescription: 'إشعارات مواقيت الصلاة',
        importance: Importance.max,
        priority: Priority.high,
        enableLights: true,
        enableVibration: true,
        playSound: playSound,
        icon: '@drawable/icon_notification',
        sound: androidSound,
        category: AndroidNotificationCategory.alarm,
        fullScreenIntent: true,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: playSound,
        interruptionLevel: InterruptionLevel.timeSensitive,
      ),
    );

    final currentTime = tz.TZDateTime.now(tz.local);
    var scheduledTime = tz.TZDateTime(
      tz.local,
      currentTime.year,
      currentTime.month,
      currentTime.day,
      hour,
      minute,
    );

    // If time has passed today, schedule for tomorrow
    if (scheduledTime.isBefore(currentTime)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }

    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledTime,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'prayer_$id',
    );
  }

  /// Parse time string (HH:MM) to hour and minute
  Map<String, int>? _parseTimeString(String timeString) {
    try {
      // Handle format like "05:30 (EET)" by taking only the time part
      final timePart = timeString.split(' ').first;
      final parts = timePart.split(':');
      if (parts.length >= 2) {
        return {
          'hour': int.parse(parts[0]),
          'minute': int.parse(parts[1]),
        };
      }
    } catch (_) {
      // Return null on parse error
    }
    return null;
  }

  /// Subtract minutes from a time, handling day wrap
  Map<String, int> _subtractMinutes(
      int hour, int minute, int subtractMinutes) {
    int totalMinutes = hour * 60 + minute - subtractMinutes;

    // Handle negative values (wrap to previous day)
    if (totalMinutes < 0) {
      totalMinutes += 24 * 60;
    }

    return {
      'hour': totalMinutes ~/ 60,
      'minute': totalMinutes % 60,
    };
  }
}
