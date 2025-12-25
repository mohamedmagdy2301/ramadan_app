import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../domain/entities/azkar_reminder_settings.dart';

/// Service for managing azkar reminder notifications
class AzkarReminderService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static bool _isInitialized = false;

  // Singleton instance
  static AzkarReminderService? _instance;

  static AzkarReminderService get instance {
    _instance ??= AzkarReminderService._internal();
    return _instance!;
  }

  AzkarReminderService._internal();

  /// Initialize the service
  Future<void> initialize() async {
    if (_isInitialized) return;

    tz.initializeTimeZones();
    final localTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(localTimeZone.identifier));

    _isInitialized = true;
  }

  /// Schedule all azkar reminders based on settings
  Future<void> scheduleAllReminders(AzkarReminderSettings settings) async {
    await _ensureInitialized();

    // Cancel all existing azkar reminders first
    await cancelAllReminders();

    // Schedule enabled reminders
    if (settings.morningReminderEnabled) {
      await scheduleReminder(
        type: AzkarReminderType.morning,
        time: settings.morningReminderTime,
        soundEnabled: settings.soundEnabled,
      );
    }

    if (settings.eveningReminderEnabled) {
      await scheduleReminder(
        type: AzkarReminderType.evening,
        time: settings.eveningReminderTime,
        soundEnabled: settings.soundEnabled,
      );
    }

    if (settings.sleepReminderEnabled) {
      await scheduleReminder(
        type: AzkarReminderType.sleep,
        time: settings.sleepReminderTime,
        soundEnabled: settings.soundEnabled,
      );
    }

    if (settings.istighfarReminderEnabled && settings.istighfarIntervalHours > 0) {
      await scheduleIstighfarReminder(
        intervalHours: settings.istighfarIntervalHours,
        soundEnabled: settings.soundEnabled,
      );
    }
  }

  /// Schedule a specific azkar reminder
  Future<void> scheduleReminder({
    required AzkarReminderType type,
    required TimeOfDay time,
    bool soundEnabled = true,
  }) async {
    await _ensureInitialized();

    final notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'azkar_reminder_channel',
        'تذكيرات الأذكار',
        channelDescription: 'إشعارات تذكير بالأذكار',
        importance: Importance.high,
        priority: Priority.high,
        enableLights: true,
        enableVibration: true,
        playSound: soundEnabled,
        icon: '@drawable/icon_notification',
        sound: soundEnabled
            ? const RawResourceAndroidNotificationSound('sound_test')
            : null,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: soundEnabled,
      ),
    );

    final currentTime = tz.TZDateTime.now(tz.local);
    var scheduledTime = tz.TZDateTime(
      tz.local,
      currentTime.year,
      currentTime.month,
      currentTime.day,
      time.hour,
      time.minute,
    );

    // If time has passed today, schedule for tomorrow
    if (scheduledTime.isBefore(currentTime)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }

    await _notificationsPlugin.zonedSchedule(
      type.notificationId,
      type.arabicName,
      type.notificationBody,
      scheduledTime,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'azkar_${type.name}',
    );
  }

  /// Schedule istighfar reminder at intervals
  Future<void> scheduleIstighfarReminder({
    required int intervalHours,
    bool soundEnabled = true,
  }) async {
    await _ensureInitialized();

    if (intervalHours <= 0) return;

    final notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'istighfar_reminder_channel',
        'تذكير الاستغفار',
        channelDescription: 'تذكير دوري بالاستغفار',
        importance: Importance.high,
        priority: Priority.high,
        enableLights: true,
        enableVibration: true,
        playSound: soundEnabled,
        icon: '@drawable/icon_notification',
        sound: soundEnabled
            ? const RawResourceAndroidNotificationSound('sound_test')
            : null,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: soundEnabled,
      ),
    );

    // Schedule for the next interval from now
    final currentTime = tz.TZDateTime.now(tz.local);
    final scheduledTime = currentTime.add(Duration(hours: intervalHours));

    // Note: For truly periodic notifications, we would need to reschedule
    // when the notification is received. For now, we schedule the next one.
    await _notificationsPlugin.zonedSchedule(
      AzkarReminderType.istighfar.notificationId,
      AzkarReminderType.istighfar.arabicName,
      AzkarReminderType.istighfar.notificationBody,
      scheduledTime,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: 'azkar_istighfar',
    );
  }

  /// Schedule after-prayer reminder for a specific prayer
  Future<void> scheduleAfterPrayerReminder({
    required int prayerIndex, // 0-4 for Fajr to Isha
    required int hour,
    required int minute,
    int delayMinutes = 5, // Minutes after prayer time
    bool soundEnabled = true,
  }) async {
    await _ensureInitialized();

    final notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'after_prayer_reminder_channel',
        'تذكير أذكار بعد الصلاة',
        channelDescription: 'تذكير بأذكار ما بعد الصلاة',
        importance: Importance.high,
        priority: Priority.high,
        enableLights: true,
        enableVibration: true,
        playSound: soundEnabled,
        icon: '@drawable/icon_notification',
        sound: soundEnabled
            ? const RawResourceAndroidNotificationSound('sound_test')
            : null,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: soundEnabled,
      ),
    );

    final currentTime = tz.TZDateTime.now(tz.local);

    // Calculate time with delay
    int totalMinutes = hour * 60 + minute + delayMinutes;
    int adjustedHour = totalMinutes ~/ 60;
    int adjustedMinute = totalMinutes % 60;

    // Handle day wrap
    if (adjustedHour >= 24) {
      adjustedHour -= 24;
    }

    var scheduledTime = tz.TZDateTime(
      tz.local,
      currentTime.year,
      currentTime.month,
      currentTime.day,
      adjustedHour,
      adjustedMinute,
    );

    // If time has passed today, schedule for tomorrow
    if (scheduledTime.isBefore(currentTime)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }

    await _notificationsPlugin.zonedSchedule(
      AzkarReminderType.afterPrayer.notificationId + prayerIndex,
      AzkarReminderType.afterPrayer.arabicName,
      AzkarReminderType.afterPrayer.notificationBody,
      scheduledTime,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'azkar_after_prayer_$prayerIndex',
    );
  }

  /// Cancel a specific reminder
  Future<void> cancelReminder(AzkarReminderType type) async {
    await _notificationsPlugin.cancel(type.notificationId);

    // Cancel after-prayer reminders for all prayers if needed
    if (type == AzkarReminderType.afterPrayer) {
      for (int i = 0; i < 5; i++) {
        await _notificationsPlugin.cancel(type.notificationId + i);
      }
    }
  }

  /// Cancel all azkar reminders
  Future<void> cancelAllReminders() async {
    for (final type in AzkarReminderType.values) {
      await cancelReminder(type);
    }
  }

  /// Get pending notifications (for debugging)
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notificationsPlugin.pendingNotificationRequests();
  }

  // Private helper methods
  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initialize();
    }
  }
}
