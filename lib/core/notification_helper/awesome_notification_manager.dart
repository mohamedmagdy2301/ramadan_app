import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:ramadan_app/core/router/app_router.dart';
import 'package:ramadan_app/features/azkar/data/azkar_screen_body_item_model_data.dart';
import 'package:ramadan_app/features/azkar/presentation/view/screens/azkar_details_screen.dart';
import 'package:ramadan_app/features/home/presentation/view/screens/home_screen.dart';

class AwesomeNotificationManager {
  /// Initialize notifications for Android & iOS
  static Future<void> initialize() async {
    await AwesomeNotifications().initialize('resource://drawable/quran2', [
      NotificationChannel(
        channelKey: "schedule_azkar_channel",
        channelName: 'Scheduled Notifications',
        channelDescription: 'Notification channel for scheduled Azkar',
        importance: NotificationImportance.Max,
        channelShowBadge: false,
        groupAlertBehavior: GroupAlertBehavior.Children,
        enableLights: true,
        enableVibration: true,
        defaultPrivacy: NotificationPrivacy.Public,
        onlyAlertOnce: true,
        playSound: true,
      ),
    ]);

    await requestNotificationPermission();
    onActionReceived();
  }

  /// Request permission for notifications (iOS & Android)
  static Future<void> requestNotificationPermission() async {
    if (!await AwesomeNotifications().isNotificationAllowed()) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }
  }

  /// Schedule Azkar Notification
  static Future<void> scheduleAzkarNotification({
    required int id,
    required String title,
    required String body,
    required int selectedHour,
    required int selectedMinute,
    required bool isRepeating,
  }) async {
    final notificationContent = NotificationContent(
      id: id,
      channelKey: "schedule_azkar_channel",
      title: title,
      body: body,
      icon: 'resource://drawable/quran2',
      notificationLayout: NotificationLayout.Default,
    );

    final schedule = NotificationCalendar(
      hour: selectedHour,
      minute: selectedMinute,
      second: 0,
      repeats: isRepeating,
      timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier(),
    );

    await AwesomeNotifications().createNotification(
      content: notificationContent,
      schedule: schedule,
    );
  }

  /// Setup action listeners for notifications
  static void onActionReceived() {
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
    );
  }

  /// Handle when a notification is tapped (foreground)
  @pragma('vm:entry-point')
  static Future<void> onActionReceivedMethod(
    ReceivedAction receivedAction,
  ) async {
    if (receivedAction.actionType == ActionType.SilentAction ||
        receivedAction.actionType == ActionType.SilentBackgroundAction) {
      return;
    } else {
      return onActionReceivedImplementationMethod(receivedAction);
    }
  }

  /// Handle when a notification is tapped (background)
  @pragma('vm:entry-point')
  static Future<void> onBackgroundNotificationMethod(
    ReceivedAction receivedAction,
  ) async {
    onActionReceivedImplementationMethod(receivedAction);
  }

  /// Navigate to the correct screen when a notification is tapped
  static Future<void> onActionReceivedImplementationMethod(
    ReceivedAction receivedAction,
  ) async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppRouter.navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) {
            if (receivedAction.channelKey == "schedule_azkar_channel") {
              return AzkarDetailsScreen(
                azkarScreenBodyItemModel:
                    azkarScreenBodyItemModel[receivedAction.id!],
              );
            }
            return HomeScreen();
          },
        ),
        (route) => false,
      );
    });
  }
}
