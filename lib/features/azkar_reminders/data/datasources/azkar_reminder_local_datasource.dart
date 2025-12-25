import 'package:flutter/material.dart';
import 'package:ramadan_app/features/azkar_reminders/domain/entities/azkar_reminder_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Local datasource for storing azkar reminder settings
class AzkarReminderLocalDatasource {
  // Storage keys
  static const String _morningEnabledKey = 'azkar_reminder_morning_enabled';
  static const String _morningTimeKey = 'azkar_reminder_morning_time';
  static const String _eveningEnabledKey = 'azkar_reminder_evening_enabled';
  static const String _eveningTimeKey = 'azkar_reminder_evening_time';
  static const String _sleepEnabledKey = 'azkar_reminder_sleep_enabled';
  static const String _sleepTimeKey = 'azkar_reminder_sleep_time';
  static const String _afterPrayerEnabledKey = 'azkar_reminder_after_prayer_enabled';
  static const String _istighfarEnabledKey = 'azkar_reminder_istighfar_enabled';
  static const String _istighfarIntervalKey = 'azkar_reminder_istighfar_interval';
  static const String _soundEnabledKey = 'azkar_reminder_sound_enabled';

  SharedPreferences? _prefs;

  Future<SharedPreferences> get _sharedPrefs async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  /// Get saved settings
  Future<AzkarReminderSettings> getSettings() async {
    final prefs = await _sharedPrefs;
    return AzkarReminderSettings(
      morningReminderEnabled: prefs.getBool(_morningEnabledKey) ?? false,
      morningReminderTime: await _getTimeOfDay(_morningTimeKey, const TimeOfDay(hour: 6, minute: 0)),
      eveningReminderEnabled: prefs.getBool(_eveningEnabledKey) ?? false,
      eveningReminderTime: await _getTimeOfDay(_eveningTimeKey, const TimeOfDay(hour: 17, minute: 0)),
      sleepReminderEnabled: prefs.getBool(_sleepEnabledKey) ?? false,
      sleepReminderTime: await _getTimeOfDay(_sleepTimeKey, const TimeOfDay(hour: 22, minute: 0)),
      afterPrayerReminderEnabled: prefs.getBool(_afterPrayerEnabledKey) ?? false,
      istighfarReminderEnabled: prefs.getBool(_istighfarEnabledKey) ?? false,
      istighfarIntervalHours: prefs.getInt(_istighfarIntervalKey) ?? 0,
      soundEnabled: prefs.getBool(_soundEnabledKey) ?? true,
    );
  }

  /// Toggle morning reminder
  Future<void> toggleMorningReminder(bool enabled) async {
    final prefs = await _sharedPrefs;
    await prefs.setBool(_morningEnabledKey, enabled);
  }

  /// Set morning reminder time
  Future<void> setMorningReminderTime(TimeOfDay time) async {
    await _saveTimeOfDay(_morningTimeKey, time);
  }

  /// Toggle evening reminder
  Future<void> toggleEveningReminder(bool enabled) async {
    final prefs = await _sharedPrefs;
    await prefs.setBool(_eveningEnabledKey, enabled);
  }

  /// Set evening reminder time
  Future<void> setEveningReminderTime(TimeOfDay time) async {
    await _saveTimeOfDay(_eveningTimeKey, time);
  }

  /// Toggle sleep reminder
  Future<void> toggleSleepReminder(bool enabled) async {
    final prefs = await _sharedPrefs;
    await prefs.setBool(_sleepEnabledKey, enabled);
  }

  /// Set sleep reminder time
  Future<void> setSleepReminderTime(TimeOfDay time) async {
    await _saveTimeOfDay(_sleepTimeKey, time);
  }

  /// Toggle after prayer reminder
  Future<void> toggleAfterPrayerReminder(bool enabled) async {
    final prefs = await _sharedPrefs;
    await prefs.setBool(_afterPrayerEnabledKey, enabled);
  }

  /// Toggle istighfar reminder
  Future<void> toggleIstighfarReminder(bool enabled) async {
    final prefs = await _sharedPrefs;
    await prefs.setBool(_istighfarEnabledKey, enabled);
  }

  /// Set istighfar interval
  Future<void> setIstighfarInterval(int hours) async {
    final prefs = await _sharedPrefs;
    await prefs.setInt(_istighfarIntervalKey, hours);
  }

  /// Toggle sound
  Future<void> toggleSound(bool enabled) async {
    final prefs = await _sharedPrefs;
    await prefs.setBool(_soundEnabledKey, enabled);
  }

  // Helper methods
  Future<TimeOfDay> _getTimeOfDay(String key, TimeOfDay defaultValue) async {
    final prefs = await _sharedPrefs;
    final timeString = prefs.getString(key);
    if (timeString == null) return defaultValue;

    try {
      final parts = timeString.split(':');
      return TimeOfDay(
        hour: int.parse(parts[0]),
        minute: int.parse(parts[1]),
      );
    } catch (_) {
      return defaultValue;
    }
  }

  Future<void> _saveTimeOfDay(String key, TimeOfDay time) async {
    final prefs = await _sharedPrefs;
    await prefs.setString(key, '${time.hour}:${time.minute}');
  }
}
