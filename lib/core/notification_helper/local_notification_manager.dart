import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationService {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static StreamController<NotificationResponse> streamController =
      StreamController();
  static onTap(NotificationResponse response) {
    streamController.add(response);
  }

  /// Initialize Local Notification
  static Future<void> initialize() async {
    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: AndroidInitializationSettings("@drawable/icon_notification"),
          iOS: DarwinInitializationSettings(
            requestSoundPermission: true,
            requestBadgePermission: true,
            requestAlertPermission: true,
          ),
        );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveBackgroundNotificationResponse: onTap,
      onDidReceiveNotificationResponse: onTap,
    );
  }

  //! Show Daily Scheduled Notification
  static Future<void> showDailyScheduledNotification({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    final notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'daily_scheduled_channel',
        'Daily Scheduled Notifications',
        importance: Importance.max,
        priority: Priority.high,
        enableLights: true,
        enableVibration: true,
        playSound: true,
        icon: "@drawable/icon_notification",
        sound: RawResourceAndroidNotificationSound('sound_test'),
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    tz.initializeTimeZones();
    final localTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(localTimeZone));

    final currentTime = tz.TZDateTime.now(tz.local);
    var scheduledTime = tz.TZDateTime(
      tz.local,
      currentTime.year,
      currentTime.month,
      currentTime.day,
      hour,
      minute,
    );
    if (scheduledTime.isBefore(currentTime)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledTime,
      notificationDetails,

      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: title,
    );
  }

  //! Cancel All Notifications
  static Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  //! Cancel Notification By Id
  static Future<void> cancelNotificationById(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }
}
