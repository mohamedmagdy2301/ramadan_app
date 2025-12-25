import 'dart:math' as math;

import 'package:geolocator/geolocator.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/prayer_times_entity.dart';
import '../datasources/prayer_times_local_datasource.dart';
import '../datasources/prayer_times_remote_datasource.dart';
import '../prayer_times_model/prayer_times_model.dart';

/// Result class to handle success/failure cases
class PrayerTimesResult {
  final PrayerTimesEntity? data;
  final String? locationName;
  final Failure? failure;
  final bool isFromCache;

  PrayerTimesResult({
    this.data,
    this.locationName,
    this.failure,
    this.isFromCache = false,
  });

  bool get isSuccess => data != null && failure == null;
  bool get isFailure => failure != null;
}

/// Abstract repository interface
abstract class IPrayerTimesRepository {
  Future<PrayerTimesResult> getPrayerTimes({required Position location});
  Future<PrayerTimesResult> getCachedPrayerTimes();
  Future<void> clearCache();
}

/// Implementation of [IPrayerTimesRepository] with caching support
class PrayerTimesRepositoryImpl implements IPrayerTimesRepository {
  final PrayerTimesRemoteDatasource remoteDatasource;
  final PrayerTimesLocalDatasource localDatasource;
  final NetworkInfo networkInfo;

  PrayerTimesRepositoryImpl({
    required this.remoteDatasource,
    required this.localDatasource,
    required this.networkInfo,
  });

  @override
  Future<PrayerTimesResult> getPrayerTimes({required Position location}) async {
    // Check if we have valid cache for today
    final isCacheValid = await localDatasource.isCacheValid();

    if (isCacheValid) {
      // Check if location hasn't changed significantly (within ~1km)
      final cachedCoords = await localDatasource.getCachedCoordinates();
      if (cachedCoords != null) {
        final distance = _calculateDistance(
          cachedCoords['latitude']!,
          cachedCoords['longitude']!,
          location.latitude,
          location.longitude,
        );

        // If within 1km, use cached data
        if (distance < 1000) {
          try {
            final cachedData = await localDatasource.getCachedPrayerTimes();
            final locationName = await localDatasource.getCachedLocationName();
            return PrayerTimesResult(
              data: cachedData,
              locationName: locationName,
              isFromCache: true,
            );
          } on CacheException {
            // Cache read failed, continue to fetch from remote
          }
        }
      }
    }

    // Check network connectivity
    if (await networkInfo.isConnected) {
      try {
        // Fetch from remote
        final prayerTimes = await remoteDatasource.fetchPrayerTimes(
          location: location,
        );

        // Cache the data
        await _cacheData(prayerTimes, location);

        final locationName = await localDatasource.getCachedLocationName();

        return PrayerTimesResult(
          data: prayerTimes,
          locationName: locationName,
          isFromCache: false,
        );
      } on ServerException catch (e) {
        // Try to return cached data if available
        return _tryGetCachedDataOrFail(
          ServerFailure(message: e.message, statusCode: e.statusCode),
        );
      } on NetworkException catch (e) {
        return _tryGetCachedDataOrFail(NetworkFailure(message: e.message));
      } on TimeoutException catch (e) {
        return _tryGetCachedDataOrFail(TimeoutFailure(message: e.message));
      } catch (e) {
        return _tryGetCachedDataOrFail(
          UnknownFailure(message: 'خطأ غير متوقع: $e'),
        );
      }
    } else {
      // No internet, try to get cached data
      return _tryGetCachedDataOrFail(
        const NetworkFailure(message: 'لا يوجد اتصال بالإنترنت'),
      );
    }
  }

  @override
  Future<PrayerTimesResult> getCachedPrayerTimes() async {
    try {
      final cachedData = await localDatasource.getCachedPrayerTimes();
      final locationName = await localDatasource.getCachedLocationName();
      return PrayerTimesResult(
        data: cachedData,
        locationName: locationName,
        isFromCache: true,
      );
    } on CacheException catch (e) {
      return PrayerTimesResult(
        failure: CacheFailure(message: e.message),
      );
    }
  }

  @override
  Future<void> clearCache() async {
    await localDatasource.clearCache();
  }

  /// Try to get cached data, or return the failure if no cache available
  Future<PrayerTimesResult> _tryGetCachedDataOrFail(Failure failure) async {
    try {
      final cachedData = await localDatasource.getCachedPrayerTimes();
      final locationName = await localDatasource.getCachedLocationName();

      // Return cached data with a note that it might be outdated
      return PrayerTimesResult(
        data: cachedData,
        locationName: locationName,
        isFromCache: true,
      );
    } on CacheException {
      // No cached data available, return the original failure
      return PrayerTimesResult(failure: failure);
    }
  }

  /// Cache the prayer times data and location
  Future<void> _cacheData(
    PrayerTimesModel prayerTimes,
    Position location,
  ) async {
    try {
      await localDatasource.cachePrayerTimes(prayerTimes);
      await localDatasource.cacheCoordinates(
        location.latitude,
        location.longitude,
      );
    } catch (_) {
      // Caching failed, but we don't want to fail the whole operation
      // Just log it in debug mode
    }
  }

  /// Calculate distance between two coordinates in meters (Haversine formula)
  double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double earthRadius = 6371000; // meters
    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);

    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRadians(lat1)) *
            math.cos(_toRadians(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);

    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadius * c;
  }

  double _toRadians(double degree) => degree * math.pi / 180;
}
