import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Represents settings for azkar reminders
class AzkarReminderSettings extends Equatable {
  /// Morning azkar reminder enabled
  final bool morningReminderEnabled;

  /// Morning reminder time (default: 6:00 AM - after Fajr)
  final TimeOfDay morningReminderTime;

  /// Evening azkar reminder enabled
  final bool eveningReminderEnabled;

  /// Evening reminder time (default: 5:00 PM - after Asr)
  final TimeOfDay eveningReminderTime;

  /// Sleep azkar reminder enabled
  final bool sleepReminderEnabled;

  /// Sleep reminder time (default: 10:00 PM)
  final TimeOfDay sleepReminderTime;

  /// After prayer azkar reminder enabled
  final bool afterPrayerReminderEnabled;

  /// Istighfar reminder enabled (periodic)
  final bool istighfarReminderEnabled;

  /// Istighfar reminder interval in hours (0 = disabled)
  final int istighfarIntervalHours;

  /// Sound enabled for azkar reminders
  final bool soundEnabled;

  const AzkarReminderSettings({
    this.morningReminderEnabled = false,
    this.morningReminderTime = const TimeOfDay(hour: 6, minute: 0),
    this.eveningReminderEnabled = false,
    this.eveningReminderTime = const TimeOfDay(hour: 17, minute: 0),
    this.sleepReminderEnabled = false,
    this.sleepReminderTime = const TimeOfDay(hour: 22, minute: 0),
    this.afterPrayerReminderEnabled = false,
    this.istighfarReminderEnabled = false,
    this.istighfarIntervalHours = 0,
    this.soundEnabled = true,
  });

  /// Create a copy with updated values
  AzkarReminderSettings copyWith({
    bool? morningReminderEnabled,
    TimeOfDay? morningReminderTime,
    bool? eveningReminderEnabled,
    TimeOfDay? eveningReminderTime,
    bool? sleepReminderEnabled,
    TimeOfDay? sleepReminderTime,
    bool? afterPrayerReminderEnabled,
    bool? istighfarReminderEnabled,
    int? istighfarIntervalHours,
    bool? soundEnabled,
  }) {
    return AzkarReminderSettings(
      morningReminderEnabled: morningReminderEnabled ?? this.morningReminderEnabled,
      morningReminderTime: morningReminderTime ?? this.morningReminderTime,
      eveningReminderEnabled: eveningReminderEnabled ?? this.eveningReminderEnabled,
      eveningReminderTime: eveningReminderTime ?? this.eveningReminderTime,
      sleepReminderEnabled: sleepReminderEnabled ?? this.sleepReminderEnabled,
      sleepReminderTime: sleepReminderTime ?? this.sleepReminderTime,
      afterPrayerReminderEnabled: afterPrayerReminderEnabled ?? this.afterPrayerReminderEnabled,
      istighfarReminderEnabled: istighfarReminderEnabled ?? this.istighfarReminderEnabled,
      istighfarIntervalHours: istighfarIntervalHours ?? this.istighfarIntervalHours,
      soundEnabled: soundEnabled ?? this.soundEnabled,
    );
  }

  /// Check if any reminder is enabled
  bool get hasAnyReminderEnabled =>
      morningReminderEnabled ||
      eveningReminderEnabled ||
      sleepReminderEnabled ||
      afterPrayerReminderEnabled ||
      istighfarReminderEnabled;

  @override
  List<Object?> get props => [
        morningReminderEnabled,
        morningReminderTime,
        eveningReminderEnabled,
        eveningReminderTime,
        sleepReminderEnabled,
        sleepReminderTime,
        afterPrayerReminderEnabled,
        istighfarReminderEnabled,
        istighfarIntervalHours,
        soundEnabled,
      ];
}

/// Enum representing different types of azkar reminders
enum AzkarReminderType {
  morning,
  evening,
  sleep,
  afterPrayer,
  istighfar;

  /// Get Arabic name for the reminder type
  String get arabicName {
    switch (this) {
      case AzkarReminderType.morning:
        return 'أذكار الصباح';
      case AzkarReminderType.evening:
        return 'أذكار المساء';
      case AzkarReminderType.sleep:
        return 'أذكار النوم';
      case AzkarReminderType.afterPrayer:
        return 'أذكار بعد الصلاة';
      case AzkarReminderType.istighfar:
        return 'الاستغفار';
    }
  }

  /// Get notification ID for the reminder type
  int get notificationId {
    switch (this) {
      case AzkarReminderType.morning:
        return 3001;
      case AzkarReminderType.evening:
        return 3002;
      case AzkarReminderType.sleep:
        return 3003;
      case AzkarReminderType.afterPrayer:
        return 3004; // Base ID, actual IDs are 3004-3008 for each prayer
      case AzkarReminderType.istighfar:
        return 3010;
    }
  }

  /// Get notification body text
  String get notificationBody {
    switch (this) {
      case AzkarReminderType.morning:
        return 'حان وقت أذكار الصباح - ابدأ يومك بذكر الله';
      case AzkarReminderType.evening:
        return 'حان وقت أذكار المساء - أمسِك بذكر الله';
      case AzkarReminderType.sleep:
        return 'لا تنسَ أذكار النوم قبل أن تنام';
      case AzkarReminderType.afterPrayer:
        return 'لا تنسَ أذكار ما بعد الصلاة';
      case AzkarReminderType.istighfar:
        return 'استغفر الله العظيم وأتوب إليه';
    }
  }
}
