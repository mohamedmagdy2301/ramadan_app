import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/prayer_notification_settings.dart';

/// Keys for storing prayer notification settings in SharedPreferences
class PrayerNotificationKeys {
  static const String fajrEnabled = 'prayer_notification_fajr';
  static const String dhuhrEnabled = 'prayer_notification_dhuhr';
  static const String asrEnabled = 'prayer_notification_asr';
  static const String maghribEnabled = 'prayer_notification_maghrib';
  static const String ishaEnabled = 'prayer_notification_isha';
  static const String preAlertMinutes = 'prayer_notification_pre_alert';
  static const String soundEnabled = 'prayer_notification_sound';
  static const String selectedAdhan = 'prayer_notification_adhan';
  static const String notificationsScheduled = 'prayer_notifications_scheduled';
  static const String lastScheduledDate = 'prayer_notifications_last_date';
}

/// Abstract class for prayer notification local datasource
abstract class PrayerNotificationLocalDatasource {
  /// Get saved notification settings
  Future<PrayerNotificationSettings> getSettings();

  /// Save notification settings
  Future<void> saveSettings(PrayerNotificationSettings settings);

  /// Toggle a specific prayer notification
  Future<void> togglePrayerNotification(PrayerType prayer, bool enabled);

  /// Set pre-alert minutes
  Future<void> setPreAlertMinutes(int minutes);

  /// Toggle sound
  Future<void> toggleSound(bool enabled);

  /// Set selected adhan
  Future<void> setSelectedAdhan(String? adhan);

  /// Check if notifications are scheduled for today
  Future<bool> areNotificationsScheduledForToday();

  /// Mark notifications as scheduled for today
  Future<void> markNotificationsAsScheduled();

  /// Clear scheduled status (for testing or reset)
  Future<void> clearScheduledStatus();
}

/// Implementation of [PrayerNotificationLocalDatasource]
class PrayerNotificationLocalDatasourceImpl
    implements PrayerNotificationLocalDatasource {
  final SharedPreferences sharedPreferences;

  PrayerNotificationLocalDatasourceImpl({required this.sharedPreferences});

  @override
  Future<PrayerNotificationSettings> getSettings() async {
    return PrayerNotificationSettings(
      fajrEnabled:
          sharedPreferences.getBool(PrayerNotificationKeys.fajrEnabled) ?? true,
      dhuhrEnabled:
          sharedPreferences.getBool(PrayerNotificationKeys.dhuhrEnabled) ??
              true,
      asrEnabled:
          sharedPreferences.getBool(PrayerNotificationKeys.asrEnabled) ?? true,
      maghribEnabled:
          sharedPreferences.getBool(PrayerNotificationKeys.maghribEnabled) ??
              true,
      ishaEnabled:
          sharedPreferences.getBool(PrayerNotificationKeys.ishaEnabled) ?? true,
      preAlertMinutes:
          sharedPreferences.getInt(PrayerNotificationKeys.preAlertMinutes) ?? 0,
      soundEnabled:
          sharedPreferences.getBool(PrayerNotificationKeys.soundEnabled) ??
              true,
      selectedAdhan:
          sharedPreferences.getString(PrayerNotificationKeys.selectedAdhan),
    );
  }

  @override
  Future<void> saveSettings(PrayerNotificationSettings settings) async {
    await sharedPreferences.setBool(
        PrayerNotificationKeys.fajrEnabled, settings.fajrEnabled);
    await sharedPreferences.setBool(
        PrayerNotificationKeys.dhuhrEnabled, settings.dhuhrEnabled);
    await sharedPreferences.setBool(
        PrayerNotificationKeys.asrEnabled, settings.asrEnabled);
    await sharedPreferences.setBool(
        PrayerNotificationKeys.maghribEnabled, settings.maghribEnabled);
    await sharedPreferences.setBool(
        PrayerNotificationKeys.ishaEnabled, settings.ishaEnabled);
    await sharedPreferences.setInt(
        PrayerNotificationKeys.preAlertMinutes, settings.preAlertMinutes);
    await sharedPreferences.setBool(
        PrayerNotificationKeys.soundEnabled, settings.soundEnabled);
    if (settings.selectedAdhan != null) {
      await sharedPreferences.setString(
          PrayerNotificationKeys.selectedAdhan, settings.selectedAdhan!);
    } else {
      await sharedPreferences.remove(PrayerNotificationKeys.selectedAdhan);
    }
  }

  @override
  Future<void> togglePrayerNotification(PrayerType prayer, bool enabled) async {
    final key = _getPrayerKey(prayer);
    await sharedPreferences.setBool(key, enabled);
  }

  @override
  Future<void> setPreAlertMinutes(int minutes) async {
    await sharedPreferences.setInt(
        PrayerNotificationKeys.preAlertMinutes, minutes);
  }

  @override
  Future<void> toggleSound(bool enabled) async {
    await sharedPreferences.setBool(
        PrayerNotificationKeys.soundEnabled, enabled);
  }

  @override
  Future<void> setSelectedAdhan(String? adhan) async {
    if (adhan != null) {
      await sharedPreferences.setString(
          PrayerNotificationKeys.selectedAdhan, adhan);
    } else {
      await sharedPreferences.remove(PrayerNotificationKeys.selectedAdhan);
    }
  }

  @override
  Future<bool> areNotificationsScheduledForToday() async {
    final lastScheduledDate =
        sharedPreferences.getString(PrayerNotificationKeys.lastScheduledDate);
    if (lastScheduledDate == null) return false;

    final today = DateTime.now();
    final todayString = '${today.year}-${today.month}-${today.day}';
    return lastScheduledDate == todayString;
  }

  @override
  Future<void> markNotificationsAsScheduled() async {
    final today = DateTime.now();
    final todayString = '${today.year}-${today.month}-${today.day}';
    await sharedPreferences.setString(
        PrayerNotificationKeys.lastScheduledDate, todayString);
    await sharedPreferences.setBool(
        PrayerNotificationKeys.notificationsScheduled, true);
  }

  @override
  Future<void> clearScheduledStatus() async {
    await sharedPreferences.remove(PrayerNotificationKeys.lastScheduledDate);
    await sharedPreferences.remove(
        PrayerNotificationKeys.notificationsScheduled);
  }

  String _getPrayerKey(PrayerType prayer) {
    switch (prayer) {
      case PrayerType.fajr:
        return PrayerNotificationKeys.fajrEnabled;
      case PrayerType.dhuhr:
        return PrayerNotificationKeys.dhuhrEnabled;
      case PrayerType.asr:
        return PrayerNotificationKeys.asrEnabled;
      case PrayerType.maghrib:
        return PrayerNotificationKeys.maghribEnabled;
      case PrayerType.isha:
        return PrayerNotificationKeys.ishaEnabled;
    }
  }
}
