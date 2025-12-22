import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ramadan_app/features/prayer_notifications/data/datasources/prayer_notification_local_datasource.dart';
import 'package:ramadan_app/features/prayer_notifications/domain/entities/prayer_notification_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late PrayerNotificationLocalDatasourceImpl datasource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    datasource = PrayerNotificationLocalDatasourceImpl(
      sharedPreferences: mockSharedPreferences,
    );
  });

  group('getSettings', () {
    test('should return default settings when no data is stored', () async {
      // Arrange
      when(() => mockSharedPreferences.getBool(any())).thenReturn(null);
      when(() => mockSharedPreferences.getInt(any())).thenReturn(null);
      when(() => mockSharedPreferences.getString(any())).thenReturn(null);

      // Act
      final result = await datasource.getSettings();

      // Assert
      expect(result.fajrEnabled, true);
      expect(result.dhuhrEnabled, true);
      expect(result.asrEnabled, true);
      expect(result.maghribEnabled, true);
      expect(result.ishaEnabled, true);
      expect(result.preAlertMinutes, 0);
      expect(result.soundEnabled, true);
      expect(result.selectedAdhan, isNull);
    });

    test('should return stored settings when data exists', () async {
      // Arrange
      when(() => mockSharedPreferences.getBool(PrayerNotificationKeys.fajrEnabled))
          .thenReturn(false);
      when(() => mockSharedPreferences.getBool(PrayerNotificationKeys.dhuhrEnabled))
          .thenReturn(true);
      when(() => mockSharedPreferences.getBool(PrayerNotificationKeys.asrEnabled))
          .thenReturn(false);
      when(() => mockSharedPreferences.getBool(PrayerNotificationKeys.maghribEnabled))
          .thenReturn(true);
      when(() => mockSharedPreferences.getBool(PrayerNotificationKeys.ishaEnabled))
          .thenReturn(false);
      when(() => mockSharedPreferences.getInt(PrayerNotificationKeys.preAlertMinutes))
          .thenReturn(10);
      when(() => mockSharedPreferences.getBool(PrayerNotificationKeys.soundEnabled))
          .thenReturn(false);
      when(() => mockSharedPreferences.getString(PrayerNotificationKeys.selectedAdhan))
          .thenReturn('makkah');

      // Act
      final result = await datasource.getSettings();

      // Assert
      expect(result.fajrEnabled, false);
      expect(result.dhuhrEnabled, true);
      expect(result.asrEnabled, false);
      expect(result.maghribEnabled, true);
      expect(result.ishaEnabled, false);
      expect(result.preAlertMinutes, 10);
      expect(result.soundEnabled, false);
      expect(result.selectedAdhan, 'makkah');
    });
  });

  group('saveSettings', () {
    test('should save all settings to SharedPreferences', () async {
      // Arrange
      when(() => mockSharedPreferences.setBool(any(), any()))
          .thenAnswer((_) async => true);
      when(() => mockSharedPreferences.setInt(any(), any()))
          .thenAnswer((_) async => true);
      when(() => mockSharedPreferences.setString(any(), any()))
          .thenAnswer((_) async => true);

      const settings = PrayerNotificationSettings(
        fajrEnabled: false,
        dhuhrEnabled: true,
        asrEnabled: false,
        maghribEnabled: true,
        ishaEnabled: false,
        preAlertMinutes: 15,
        soundEnabled: false,
        selectedAdhan: 'madinah',
      );

      // Act
      await datasource.saveSettings(settings);

      // Assert
      verify(() => mockSharedPreferences.setBool(
          PrayerNotificationKeys.fajrEnabled, false)).called(1);
      verify(() => mockSharedPreferences.setBool(
          PrayerNotificationKeys.dhuhrEnabled, true)).called(1);
      verify(() => mockSharedPreferences.setBool(
          PrayerNotificationKeys.asrEnabled, false)).called(1);
      verify(() => mockSharedPreferences.setBool(
          PrayerNotificationKeys.maghribEnabled, true)).called(1);
      verify(() => mockSharedPreferences.setBool(
          PrayerNotificationKeys.ishaEnabled, false)).called(1);
      verify(() => mockSharedPreferences.setInt(
          PrayerNotificationKeys.preAlertMinutes, 15)).called(1);
      verify(() => mockSharedPreferences.setBool(
          PrayerNotificationKeys.soundEnabled, false)).called(1);
      verify(() => mockSharedPreferences.setString(
          PrayerNotificationKeys.selectedAdhan, 'madinah')).called(1);
    });

    test('should remove selectedAdhan when null', () async {
      // Arrange
      when(() => mockSharedPreferences.setBool(any(), any()))
          .thenAnswer((_) async => true);
      when(() => mockSharedPreferences.setInt(any(), any()))
          .thenAnswer((_) async => true);
      when(() => mockSharedPreferences.remove(any()))
          .thenAnswer((_) async => true);

      const settings = PrayerNotificationSettings(
        selectedAdhan: null,
      );

      // Act
      await datasource.saveSettings(settings);

      // Assert
      verify(() => mockSharedPreferences.remove(
          PrayerNotificationKeys.selectedAdhan)).called(1);
    });
  });

  group('togglePrayerNotification', () {
    test('should toggle fajr notification', () async {
      // Arrange
      when(() => mockSharedPreferences.setBool(any(), any()))
          .thenAnswer((_) async => true);

      // Act
      await datasource.togglePrayerNotification(PrayerType.fajr, false);

      // Assert
      verify(() => mockSharedPreferences.setBool(
          PrayerNotificationKeys.fajrEnabled, false)).called(1);
    });

    test('should toggle dhuhr notification', () async {
      // Arrange
      when(() => mockSharedPreferences.setBool(any(), any()))
          .thenAnswer((_) async => true);

      // Act
      await datasource.togglePrayerNotification(PrayerType.dhuhr, true);

      // Assert
      verify(() => mockSharedPreferences.setBool(
          PrayerNotificationKeys.dhuhrEnabled, true)).called(1);
    });

    test('should toggle asr notification', () async {
      // Arrange
      when(() => mockSharedPreferences.setBool(any(), any()))
          .thenAnswer((_) async => true);

      // Act
      await datasource.togglePrayerNotification(PrayerType.asr, false);

      // Assert
      verify(() => mockSharedPreferences.setBool(
          PrayerNotificationKeys.asrEnabled, false)).called(1);
    });

    test('should toggle maghrib notification', () async {
      // Arrange
      when(() => mockSharedPreferences.setBool(any(), any()))
          .thenAnswer((_) async => true);

      // Act
      await datasource.togglePrayerNotification(PrayerType.maghrib, true);

      // Assert
      verify(() => mockSharedPreferences.setBool(
          PrayerNotificationKeys.maghribEnabled, true)).called(1);
    });

    test('should toggle isha notification', () async {
      // Arrange
      when(() => mockSharedPreferences.setBool(any(), any()))
          .thenAnswer((_) async => true);

      // Act
      await datasource.togglePrayerNotification(PrayerType.isha, false);

      // Assert
      verify(() => mockSharedPreferences.setBool(
          PrayerNotificationKeys.ishaEnabled, false)).called(1);
    });
  });

  group('setPreAlertMinutes', () {
    test('should save pre-alert minutes', () async {
      // Arrange
      when(() => mockSharedPreferences.setInt(any(), any()))
          .thenAnswer((_) async => true);

      // Act
      await datasource.setPreAlertMinutes(10);

      // Assert
      verify(() => mockSharedPreferences.setInt(
          PrayerNotificationKeys.preAlertMinutes, 10)).called(1);
    });
  });

  group('toggleSound', () {
    test('should save sound enabled state', () async {
      // Arrange
      when(() => mockSharedPreferences.setBool(any(), any()))
          .thenAnswer((_) async => true);

      // Act
      await datasource.toggleSound(false);

      // Assert
      verify(() => mockSharedPreferences.setBool(
          PrayerNotificationKeys.soundEnabled, false)).called(1);
    });
  });

  group('setSelectedAdhan', () {
    test('should save selected adhan', () async {
      // Arrange
      when(() => mockSharedPreferences.setString(any(), any()))
          .thenAnswer((_) async => true);

      // Act
      await datasource.setSelectedAdhan('makkah');

      // Assert
      verify(() => mockSharedPreferences.setString(
          PrayerNotificationKeys.selectedAdhan, 'makkah')).called(1);
    });

    test('should remove selected adhan when null', () async {
      // Arrange
      when(() => mockSharedPreferences.remove(any()))
          .thenAnswer((_) async => true);

      // Act
      await datasource.setSelectedAdhan(null);

      // Assert
      verify(() => mockSharedPreferences.remove(
          PrayerNotificationKeys.selectedAdhan)).called(1);
    });
  });

  group('areNotificationsScheduledForToday', () {
    test('should return false when no date is stored', () async {
      // Arrange
      when(() => mockSharedPreferences.getString(
          PrayerNotificationKeys.lastScheduledDate)).thenReturn(null);

      // Act
      final result = await datasource.areNotificationsScheduledForToday();

      // Assert
      expect(result, false);
    });

    test('should return true when date is today', () async {
      // Arrange
      final today = DateTime.now();
      final todayString = '${today.year}-${today.month}-${today.day}';
      when(() => mockSharedPreferences.getString(
          PrayerNotificationKeys.lastScheduledDate)).thenReturn(todayString);

      // Act
      final result = await datasource.areNotificationsScheduledForToday();

      // Assert
      expect(result, true);
    });

    test('should return false when date is not today', () async {
      // Arrange
      when(() => mockSharedPreferences.getString(
          PrayerNotificationKeys.lastScheduledDate)).thenReturn('2020-1-1');

      // Act
      final result = await datasource.areNotificationsScheduledForToday();

      // Assert
      expect(result, false);
    });
  });

  group('markNotificationsAsScheduled', () {
    test('should save today date and scheduled flag', () async {
      // Arrange
      when(() => mockSharedPreferences.setString(any(), any()))
          .thenAnswer((_) async => true);
      when(() => mockSharedPreferences.setBool(any(), any()))
          .thenAnswer((_) async => true);

      // Act
      await datasource.markNotificationsAsScheduled();

      // Assert
      final today = DateTime.now();
      final todayString = '${today.year}-${today.month}-${today.day}';
      verify(() => mockSharedPreferences.setString(
          PrayerNotificationKeys.lastScheduledDate, todayString)).called(1);
      verify(() => mockSharedPreferences.setBool(
          PrayerNotificationKeys.notificationsScheduled, true)).called(1);
    });
  });

  group('clearScheduledStatus', () {
    test('should remove scheduled date and flag', () async {
      // Arrange
      when(() => mockSharedPreferences.remove(any()))
          .thenAnswer((_) async => true);

      // Act
      await datasource.clearScheduledStatus();

      // Assert
      verify(() => mockSharedPreferences.remove(
          PrayerNotificationKeys.lastScheduledDate)).called(1);
      verify(() => mockSharedPreferences.remove(
          PrayerNotificationKeys.notificationsScheduled)).called(1);
    });
  });
}
