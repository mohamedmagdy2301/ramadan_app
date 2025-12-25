import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ramadan_app/core/error/exceptions.dart';
import 'package:ramadan_app/features/home/data/datasources/prayer_times_local_datasource.dart';
import 'package:ramadan_app/features/home/data/prayer_times_model/prayer_times_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late PrayerTimesLocalDatasourceImpl datasource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    datasource = PrayerTimesLocalDatasourceImpl(
      sharedPreferences: mockSharedPreferences,
    );
  });

  group('getCachedPrayerTimes', () {
    final tPrayerTimesJson = {
      'timings': {
        'Fajr': '05:00',
        'Sunrise': '06:30',
        'Dhuhr': '12:00',
        'Asr': '15:30',
        'Maghrib': '18:00',
        'Isha': '19:30',
      },
      'date': {
        'readable': '22 Dec 2025',
        'hijri': {
          'day': '21',
          'weekday': {'ar': 'الإثنين'},
          'month': {'ar': 'جمادى الآخرة'},
          'year': '1447',
        },
      },
      'meta': {},
    };

    test('should return PrayerTimesModel when cache exists', () async {
      // Arrange
      when(() => mockSharedPreferences.getString(any()))
          .thenReturn(json.encode(tPrayerTimesJson));

      // Act
      final result = await datasource.getCachedPrayerTimes();

      // Assert
      expect(result, isA<PrayerTimesModel>());
      verify(() => mockSharedPreferences.getString(
            PrayerTimesCacheKeys.cachedPrayerTimes,
          )).called(1);
    });

    test('should throw CacheException when cache is empty', () async {
      // Arrange
      when(() => mockSharedPreferences.getString(any())).thenReturn(null);

      // Act & Assert
      expect(
        () => datasource.getCachedPrayerTimes(),
        throwsA(isA<CacheException>()),
      );
    });

    test('should throw CacheException when cache is invalid JSON', () async {
      // Arrange
      when(() => mockSharedPreferences.getString(any()))
          .thenReturn('invalid json');

      // Act & Assert
      expect(
        () => datasource.getCachedPrayerTimes(),
        throwsA(isA<CacheException>()),
      );
    });
  });

  group('cachePrayerTimes', () {
    test('should call SharedPreferences to cache data', () async {
      // Arrange
      when(() => mockSharedPreferences.setString(any(), any()))
          .thenAnswer((_) async => true);

      final tPrayerTimes = PrayerTimesModel();

      // Act
      await datasource.cachePrayerTimes(tPrayerTimes);

      // Assert
      verify(() => mockSharedPreferences.setString(
            PrayerTimesCacheKeys.cachedPrayerTimes,
            any(),
          )).called(1);
      verify(() => mockSharedPreferences.setString(
            PrayerTimesCacheKeys.cacheDate,
            any(),
          )).called(1);
    });
  });

  group('isCacheValid', () {
    test('should return true when cache date is today', () async {
      // Arrange
      final today = DateTime.now();
      final todayString = '${today.year}-${today.month}-${today.day}';
      when(() => mockSharedPreferences.getString(PrayerTimesCacheKeys.cacheDate))
          .thenReturn(todayString);

      // Act
      final result = await datasource.isCacheValid();

      // Assert
      expect(result, true);
    });

    test('should return false when cache date is not today', () async {
      // Arrange
      when(() => mockSharedPreferences.getString(PrayerTimesCacheKeys.cacheDate))
          .thenReturn('2020-1-1');

      // Act
      final result = await datasource.isCacheValid();

      // Assert
      expect(result, false);
    });

    test('should return false when cache date is null', () async {
      // Arrange
      when(() => mockSharedPreferences.getString(PrayerTimesCacheKeys.cacheDate))
          .thenReturn(null);

      // Act
      final result = await datasource.isCacheValid();

      // Assert
      expect(result, false);
    });
  });

  group('getCachedLocationName', () {
    test('should return location name when cached', () async {
      // Arrange
      when(() => mockSharedPreferences.getString(
            PrayerTimesCacheKeys.cachedLocation,
          )).thenReturn('Cairo, Egypt');

      // Act
      final result = await datasource.getCachedLocationName();

      // Assert
      expect(result, 'Cairo, Egypt');
    });

    test('should return null when no cached location', () async {
      // Arrange
      when(() => mockSharedPreferences.getString(
            PrayerTimesCacheKeys.cachedLocation,
          )).thenReturn(null);

      // Act
      final result = await datasource.getCachedLocationName();

      // Assert
      expect(result, isNull);
    });
  });

  group('cacheLocationName', () {
    test('should call SharedPreferences to cache location name', () async {
      // Arrange
      when(() => mockSharedPreferences.setString(any(), any()))
          .thenAnswer((_) async => true);

      // Act
      await datasource.cacheLocationName('Cairo, Egypt');

      // Assert
      verify(() => mockSharedPreferences.setString(
            PrayerTimesCacheKeys.cachedLocation,
            'Cairo, Egypt',
          )).called(1);
    });
  });

  group('getCachedCoordinates', () {
    test('should return coordinates when cached', () async {
      // Arrange
      when(() => mockSharedPreferences.getDouble(
            PrayerTimesCacheKeys.cachedLatitude,
          )).thenReturn(30.0444);
      when(() => mockSharedPreferences.getDouble(
            PrayerTimesCacheKeys.cachedLongitude,
          )).thenReturn(31.2357);

      // Act
      final result = await datasource.getCachedCoordinates();

      // Assert
      expect(result, isNotNull);
      expect(result!['latitude'], 30.0444);
      expect(result['longitude'], 31.2357);
    });

    test('should return null when no cached coordinates', () async {
      // Arrange
      when(() => mockSharedPreferences.getDouble(any())).thenReturn(null);

      // Act
      final result = await datasource.getCachedCoordinates();

      // Assert
      expect(result, isNull);
    });
  });

  group('cacheCoordinates', () {
    test('should call SharedPreferences to cache coordinates', () async {
      // Arrange
      when(() => mockSharedPreferences.setDouble(any(), any()))
          .thenAnswer((_) async => true);

      // Act
      await datasource.cacheCoordinates(30.0444, 31.2357);

      // Assert
      verify(() => mockSharedPreferences.setDouble(
            PrayerTimesCacheKeys.cachedLatitude,
            30.0444,
          )).called(1);
      verify(() => mockSharedPreferences.setDouble(
            PrayerTimesCacheKeys.cachedLongitude,
            31.2357,
          )).called(1);
    });
  });

  group('clearCache', () {
    test('should remove all cached data', () async {
      // Arrange
      when(() => mockSharedPreferences.remove(any()))
          .thenAnswer((_) async => true);

      // Act
      await datasource.clearCache();

      // Assert
      verify(() => mockSharedPreferences.remove(
            PrayerTimesCacheKeys.cachedPrayerTimes,
          )).called(1);
      verify(() => mockSharedPreferences.remove(
            PrayerTimesCacheKeys.cacheDate,
          )).called(1);
      verify(() => mockSharedPreferences.remove(
            PrayerTimesCacheKeys.cachedLocation,
          )).called(1);
      verify(() => mockSharedPreferences.remove(
            PrayerTimesCacheKeys.cachedLatitude,
          )).called(1);
      verify(() => mockSharedPreferences.remove(
            PrayerTimesCacheKeys.cachedLongitude,
          )).called(1);
    });
  });
}
