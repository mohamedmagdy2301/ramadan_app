import 'package:flutter_test/flutter_test.dart';
import 'package:ramadan_app/features/prayer_notifications/domain/entities/prayer_notification_settings.dart';

void main() {
  group('PrayerNotificationSettings', () {
    test('should create with default values', () {
      const settings = PrayerNotificationSettings();

      expect(settings.fajrEnabled, true);
      expect(settings.dhuhrEnabled, true);
      expect(settings.asrEnabled, true);
      expect(settings.maghribEnabled, true);
      expect(settings.ishaEnabled, true);
      expect(settings.preAlertMinutes, 0);
      expect(settings.soundEnabled, true);
      expect(settings.selectedAdhan, isNull);
    });

    test('should create with custom values', () {
      const settings = PrayerNotificationSettings(
        fajrEnabled: false,
        dhuhrEnabled: true,
        asrEnabled: false,
        maghribEnabled: true,
        ishaEnabled: false,
        preAlertMinutes: 10,
        soundEnabled: false,
        selectedAdhan: 'makkah',
      );

      expect(settings.fajrEnabled, false);
      expect(settings.dhuhrEnabled, true);
      expect(settings.asrEnabled, false);
      expect(settings.maghribEnabled, true);
      expect(settings.ishaEnabled, false);
      expect(settings.preAlertMinutes, 10);
      expect(settings.soundEnabled, false);
      expect(settings.selectedAdhan, 'makkah');
    });

    test('isPrayerEnabled should return correct value for each prayer', () {
      const settings = PrayerNotificationSettings(
        fajrEnabled: true,
        dhuhrEnabled: false,
        asrEnabled: true,
        maghribEnabled: false,
        ishaEnabled: true,
      );

      expect(settings.isPrayerEnabled(PrayerType.fajr), true);
      expect(settings.isPrayerEnabled(PrayerType.dhuhr), false);
      expect(settings.isPrayerEnabled(PrayerType.asr), true);
      expect(settings.isPrayerEnabled(PrayerType.maghrib), false);
      expect(settings.isPrayerEnabled(PrayerType.isha), true);
    });

    test('copyWith should create new instance with updated values', () {
      const original = PrayerNotificationSettings(
        fajrEnabled: true,
        preAlertMinutes: 5,
      );

      final updated = original.copyWith(
        fajrEnabled: false,
        preAlertMinutes: 10,
      );

      expect(updated.fajrEnabled, false);
      expect(updated.preAlertMinutes, 10);
      // Unchanged values should remain the same
      expect(updated.dhuhrEnabled, original.dhuhrEnabled);
      expect(updated.soundEnabled, original.soundEnabled);
    });

    test('togglePrayer should update correct prayer', () {
      const settings = PrayerNotificationSettings();

      final updatedFajr = settings.togglePrayer(PrayerType.fajr, false);
      expect(updatedFajr.fajrEnabled, false);
      expect(updatedFajr.dhuhrEnabled, true);

      final updatedDhuhr = settings.togglePrayer(PrayerType.dhuhr, false);
      expect(updatedDhuhr.fajrEnabled, true);
      expect(updatedDhuhr.dhuhrEnabled, false);

      final updatedAsr = settings.togglePrayer(PrayerType.asr, false);
      expect(updatedAsr.asrEnabled, false);

      final updatedMaghrib = settings.togglePrayer(PrayerType.maghrib, false);
      expect(updatedMaghrib.maghribEnabled, false);

      final updatedIsha = settings.togglePrayer(PrayerType.isha, false);
      expect(updatedIsha.ishaEnabled, false);
    });

    test('two settings with same values should be equal', () {
      const settings1 = PrayerNotificationSettings(
        fajrEnabled: true,
        preAlertMinutes: 5,
      );
      const settings2 = PrayerNotificationSettings(
        fajrEnabled: true,
        preAlertMinutes: 5,
      );

      expect(settings1, equals(settings2));
    });

    test('two settings with different values should not be equal', () {
      const settings1 = PrayerNotificationSettings(preAlertMinutes: 5);
      const settings2 = PrayerNotificationSettings(preAlertMinutes: 10);

      expect(settings1, isNot(equals(settings2)));
    });
  });

  group('PrayerType', () {
    test('arabicName should return correct Arabic name', () {
      expect(PrayerType.fajr.arabicName, 'الفجر');
      expect(PrayerType.dhuhr.arabicName, 'الظهر');
      expect(PrayerType.asr.arabicName, 'العصر');
      expect(PrayerType.maghrib.arabicName, 'المغرب');
      expect(PrayerType.isha.arabicName, 'العشاء');
    });

    test('notificationId should return unique IDs starting from 1001', () {
      expect(PrayerType.fajr.notificationId, 1001);
      expect(PrayerType.dhuhr.notificationId, 1002);
      expect(PrayerType.asr.notificationId, 1003);
      expect(PrayerType.maghrib.notificationId, 1004);
      expect(PrayerType.isha.notificationId, 1005);
    });

    test('preAlertNotificationId should return unique IDs starting from 2001',
        () {
      expect(PrayerType.fajr.preAlertNotificationId, 2001);
      expect(PrayerType.dhuhr.preAlertNotificationId, 2002);
      expect(PrayerType.asr.preAlertNotificationId, 2003);
      expect(PrayerType.maghrib.preAlertNotificationId, 2004);
      expect(PrayerType.isha.preAlertNotificationId, 2005);
    });

    test('notification IDs should not overlap', () {
      final allIds = <int>{};

      for (final prayer in PrayerType.values) {
        expect(allIds.contains(prayer.notificationId), false);
        expect(allIds.contains(prayer.preAlertNotificationId), false);
        allIds.add(prayer.notificationId);
        allIds.add(prayer.preAlertNotificationId);
      }

      expect(allIds.length, 10); // 5 prayers * 2 IDs each
    });
  });
}
