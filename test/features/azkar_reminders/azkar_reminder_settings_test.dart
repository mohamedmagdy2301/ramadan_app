import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ramadan_app/features/azkar_reminders/domain/entities/azkar_reminder_settings.dart';

void main() {
  group('AzkarReminderSettings', () {
    test('should create with default values', () {
      const settings = AzkarReminderSettings();

      expect(settings.morningReminderEnabled, false);
      expect(settings.morningReminderTime, const TimeOfDay(hour: 6, minute: 0));
      expect(settings.eveningReminderEnabled, false);
      expect(settings.eveningReminderTime, const TimeOfDay(hour: 17, minute: 0));
      expect(settings.sleepReminderEnabled, false);
      expect(settings.sleepReminderTime, const TimeOfDay(hour: 22, minute: 0));
      expect(settings.afterPrayerReminderEnabled, false);
      expect(settings.istighfarReminderEnabled, false);
      expect(settings.istighfarIntervalHours, 0);
      expect(settings.soundEnabled, true);
    });

    test('should create with custom values', () {
      const settings = AzkarReminderSettings(
        morningReminderEnabled: true,
        morningReminderTime: TimeOfDay(hour: 5, minute: 30),
        eveningReminderEnabled: true,
        soundEnabled: false,
      );

      expect(settings.morningReminderEnabled, true);
      expect(settings.morningReminderTime, const TimeOfDay(hour: 5, minute: 30));
      expect(settings.eveningReminderEnabled, true);
      expect(settings.soundEnabled, false);
    });

    test('copyWith should create new instance with updated values', () {
      const settings = AzkarReminderSettings();
      final updated = settings.copyWith(
        morningReminderEnabled: true,
        istighfarIntervalHours: 3,
      );

      // Original should be unchanged
      expect(settings.morningReminderEnabled, false);
      expect(settings.istighfarIntervalHours, 0);

      // Updated should have new values
      expect(updated.morningReminderEnabled, true);
      expect(updated.istighfarIntervalHours, 3);

      // Other values should be unchanged
      expect(updated.eveningReminderEnabled, settings.eveningReminderEnabled);
      expect(updated.soundEnabled, settings.soundEnabled);
    });

    test('hasAnyReminderEnabled should return correct value', () {
      const noReminders = AzkarReminderSettings();
      expect(noReminders.hasAnyReminderEnabled, false);

      const withMorning = AzkarReminderSettings(morningReminderEnabled: true);
      expect(withMorning.hasAnyReminderEnabled, true);

      const withEvening = AzkarReminderSettings(eveningReminderEnabled: true);
      expect(withEvening.hasAnyReminderEnabled, true);

      const withSleep = AzkarReminderSettings(sleepReminderEnabled: true);
      expect(withSleep.hasAnyReminderEnabled, true);

      const withAfterPrayer = AzkarReminderSettings(afterPrayerReminderEnabled: true);
      expect(withAfterPrayer.hasAnyReminderEnabled, true);

      const withIstighfar = AzkarReminderSettings(istighfarReminderEnabled: true);
      expect(withIstighfar.hasAnyReminderEnabled, true);
    });

    test('equality should work correctly', () {
      const settings1 = AzkarReminderSettings(
        morningReminderEnabled: true,
        morningReminderTime: TimeOfDay(hour: 6, minute: 0),
      );
      const settings2 = AzkarReminderSettings(
        morningReminderEnabled: true,
        morningReminderTime: TimeOfDay(hour: 6, minute: 0),
      );
      const settings3 = AzkarReminderSettings(
        morningReminderEnabled: false,
        morningReminderTime: TimeOfDay(hour: 6, minute: 0),
      );

      expect(settings1, equals(settings2));
      expect(settings1, isNot(equals(settings3)));
    });
  });

  group('AzkarReminderType', () {
    test('should have correct Arabic names', () {
      expect(AzkarReminderType.morning.arabicName, 'أذكار الصباح');
      expect(AzkarReminderType.evening.arabicName, 'أذكار المساء');
      expect(AzkarReminderType.sleep.arabicName, 'أذكار النوم');
      expect(AzkarReminderType.afterPrayer.arabicName, 'أذكار بعد الصلاة');
      expect(AzkarReminderType.istighfar.arabicName, 'الاستغفار');
    });

    test('should have correct notification IDs', () {
      expect(AzkarReminderType.morning.notificationId, 3001);
      expect(AzkarReminderType.evening.notificationId, 3002);
      expect(AzkarReminderType.sleep.notificationId, 3003);
      expect(AzkarReminderType.afterPrayer.notificationId, 3004);
      expect(AzkarReminderType.istighfar.notificationId, 3010);
    });

    test('should have non-empty notification body', () {
      for (final type in AzkarReminderType.values) {
        expect(type.notificationBody, isNotEmpty);
        expect(type.notificationBody, isA<String>());
      }
    });
  });
}
