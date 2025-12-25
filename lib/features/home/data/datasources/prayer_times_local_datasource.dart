import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/exceptions.dart';
import '../prayer_times_model/prayer_times_model.dart';

/// Keys for SharedPreferences
abstract class PrayerTimesCacheKeys {
  static const String cachedPrayerTimes = 'CACHED_PRAYER_TIMES';
  static const String cacheDate = 'PRAYER_TIMES_CACHE_DATE';
  static const String cachedLocation = 'CACHED_LOCATION_NAME';
  static const String cachedLatitude = 'CACHED_LATITUDE';
  static const String cachedLongitude = 'CACHED_LONGITUDE';
}

/// Abstract class for prayer times local datasource
abstract class PrayerTimesLocalDatasource {
  /// Gets the cached [PrayerTimesModel] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<PrayerTimesModel> getCachedPrayerTimes();

  /// Cache the prayer times data
  Future<void> cachePrayerTimes(PrayerTimesModel prayerTimes);

  /// Get the cached location name
  Future<String?> getCachedLocationName();

  /// Cache the location name
  Future<void> cacheLocationName(String locationName);

  /// Check if cache is valid (same day)
  Future<bool> isCacheValid();

  /// Get cached coordinates
  Future<Map<String, double>?> getCachedCoordinates();

  /// Cache coordinates
  Future<void> cacheCoordinates(double latitude, double longitude);

  /// Clear all cached data
  Future<void> clearCache();
}

/// Implementation of [PrayerTimesLocalDatasource] using SharedPreferences
class PrayerTimesLocalDatasourceImpl implements PrayerTimesLocalDatasource {
  final SharedPreferences sharedPreferences;

  PrayerTimesLocalDatasourceImpl({required this.sharedPreferences});

  @override
  Future<PrayerTimesModel> getCachedPrayerTimes() async {
    final jsonString = sharedPreferences.getString(
      PrayerTimesCacheKeys.cachedPrayerTimes,
    );

    if (jsonString != null) {
      try {
        final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
        return PrayerTimesModel.fromJson(jsonMap);
      } catch (e) {
        throw CacheException(message: 'فشل في قراءة البيانات المخزنة: $e');
      }
    } else {
      throw const CacheException(message: 'لا توجد بيانات مخزنة');
    }
  }

  @override
  Future<void> cachePrayerTimes(PrayerTimesModel prayerTimes) async {
    try {
      final jsonString = json.encode(prayerTimes.toJson());
      await sharedPreferences.setString(
        PrayerTimesCacheKeys.cachedPrayerTimes,
        jsonString,
      );

      // Store the cache date
      final today = _getTodayDateString();
      await sharedPreferences.setString(
        PrayerTimesCacheKeys.cacheDate,
        today,
      );
    } catch (e) {
      throw CacheException(message: 'فشل في حفظ البيانات: $e');
    }
  }

  @override
  Future<String?> getCachedLocationName() async {
    return sharedPreferences.getString(PrayerTimesCacheKeys.cachedLocation);
  }

  @override
  Future<void> cacheLocationName(String locationName) async {
    await sharedPreferences.setString(
      PrayerTimesCacheKeys.cachedLocation,
      locationName,
    );
  }

  @override
  Future<bool> isCacheValid() async {
    final cachedDate = sharedPreferences.getString(
      PrayerTimesCacheKeys.cacheDate,
    );

    if (cachedDate == null) return false;

    final today = _getTodayDateString();
    return cachedDate == today;
  }

  @override
  Future<Map<String, double>?> getCachedCoordinates() async {
    final latitude = sharedPreferences.getDouble(
      PrayerTimesCacheKeys.cachedLatitude,
    );
    final longitude = sharedPreferences.getDouble(
      PrayerTimesCacheKeys.cachedLongitude,
    );

    if (latitude != null && longitude != null) {
      return {'latitude': latitude, 'longitude': longitude};
    }
    return null;
  }

  @override
  Future<void> cacheCoordinates(double latitude, double longitude) async {
    await sharedPreferences.setDouble(
      PrayerTimesCacheKeys.cachedLatitude,
      latitude,
    );
    await sharedPreferences.setDouble(
      PrayerTimesCacheKeys.cachedLongitude,
      longitude,
    );
  }

  @override
  Future<void> clearCache() async {
    await sharedPreferences.remove(PrayerTimesCacheKeys.cachedPrayerTimes);
    await sharedPreferences.remove(PrayerTimesCacheKeys.cacheDate);
    await sharedPreferences.remove(PrayerTimesCacheKeys.cachedLocation);
    await sharedPreferences.remove(PrayerTimesCacheKeys.cachedLatitude);
    await sharedPreferences.remove(PrayerTimesCacheKeys.cachedLongitude);
  }

  /// Get today's date as a string for comparison
  String _getTodayDateString() {
    final now = DateTime.now();
    return '${now.year}-${now.month}-${now.day}';
  }
}
