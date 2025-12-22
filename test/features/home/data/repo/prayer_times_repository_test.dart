import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ramadan_app/core/error/exceptions.dart';
import 'package:ramadan_app/core/error/failures.dart';
import 'package:ramadan_app/core/network/network_info.dart';
import 'package:ramadan_app/features/home/data/datasources/prayer_times_local_datasource.dart';
import 'package:ramadan_app/features/home/data/datasources/prayer_times_remote_datasource.dart';
import 'package:ramadan_app/features/home/data/prayer_times_model/prayer_times_model.dart';
import 'package:ramadan_app/features/home/data/repo/prayer_times_repository.dart';

class MockRemoteDatasource extends Mock implements PrayerTimesRemoteDatasource {}

class MockLocalDatasource extends Mock implements PrayerTimesLocalDatasource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

class FakePosition extends Fake implements Position {}

void main() {
  late PrayerTimesRepositoryImpl repository;
  late MockRemoteDatasource mockRemoteDatasource;
  late MockLocalDatasource mockLocalDatasource;
  late MockNetworkInfo mockNetworkInfo;

  setUpAll(() {
    registerFallbackValue(FakePosition());
    registerFallbackValue(PrayerTimesModel());
  });

  setUp(() {
    mockRemoteDatasource = MockRemoteDatasource();
    mockLocalDatasource = MockLocalDatasource();
    mockNetworkInfo = MockNetworkInfo();
    repository = PrayerTimesRepositoryImpl(
      remoteDatasource: mockRemoteDatasource,
      localDatasource: mockLocalDatasource,
      networkInfo: mockNetworkInfo,
    );
  });

  final tPosition = Position(
    latitude: 30.0444,
    longitude: 31.2357,
    timestamp: DateTime.now(),
    accuracy: 0,
    altitude: 0,
    heading: 0,
    speed: 0,
    speedAccuracy: 0,
    altitudeAccuracy: 0,
    headingAccuracy: 0,
  );

  final tPrayerTimesModel = PrayerTimesModel();

  group('getPrayerTimes', () {
    test('should return cached data when cache is valid and location unchanged',
        () async {
      // Arrange
      when(() => mockLocalDatasource.isCacheValid())
          .thenAnswer((_) async => true);
      when(() => mockLocalDatasource.getCachedCoordinates())
          .thenAnswer((_) async => {
                'latitude': 30.0444,
                'longitude': 31.2357,
              });
      when(() => mockLocalDatasource.getCachedPrayerTimes())
          .thenAnswer((_) async => tPrayerTimesModel);
      when(() => mockLocalDatasource.getCachedLocationName())
          .thenAnswer((_) async => 'Cairo, Egypt');

      // Act
      final result = await repository.getPrayerTimes(location: tPosition);

      // Assert
      expect(result.isSuccess, true);
      expect(result.isFromCache, true);
      expect(result.locationName, 'Cairo, Egypt');
      verifyNever(() => mockRemoteDatasource.fetchPrayerTimes(
            location: any(named: 'location'),
          ));
    });

    test('should fetch from remote when cache is invalid', () async {
      // Arrange
      when(() => mockLocalDatasource.isCacheValid())
          .thenAnswer((_) async => false);
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDatasource.fetchPrayerTimes(
            location: any(named: 'location'),
          )).thenAnswer((_) async => tPrayerTimesModel);
      when(() => mockLocalDatasource.cachePrayerTimes(any()))
          .thenAnswer((_) async {});
      when(() => mockLocalDatasource.cacheCoordinates(any(), any()))
          .thenAnswer((_) async {});
      when(() => mockLocalDatasource.getCachedLocationName())
          .thenAnswer((_) async => 'Cairo, Egypt');

      // Act
      final result = await repository.getPrayerTimes(location: tPosition);

      // Assert
      expect(result.isSuccess, true);
      expect(result.isFromCache, false);
      verify(() => mockRemoteDatasource.fetchPrayerTimes(
            location: any(named: 'location'),
          )).called(1);
    });

    test('should fetch from remote when location changed significantly',
        () async {
      // Arrange
      when(() => mockLocalDatasource.isCacheValid())
          .thenAnswer((_) async => true);
      // Different location (more than 1km away)
      when(() => mockLocalDatasource.getCachedCoordinates())
          .thenAnswer((_) async => {
                'latitude': 31.0,
                'longitude': 32.0,
              });
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDatasource.fetchPrayerTimes(
            location: any(named: 'location'),
          )).thenAnswer((_) async => tPrayerTimesModel);
      when(() => mockLocalDatasource.cachePrayerTimes(any()))
          .thenAnswer((_) async {});
      when(() => mockLocalDatasource.cacheCoordinates(any(), any()))
          .thenAnswer((_) async {});
      when(() => mockLocalDatasource.getCachedLocationName())
          .thenAnswer((_) async => 'Cairo, Egypt');

      // Act
      final result = await repository.getPrayerTimes(location: tPosition);

      // Assert
      expect(result.isSuccess, true);
      verify(() => mockRemoteDatasource.fetchPrayerTimes(
            location: any(named: 'location'),
          )).called(1);
    });

    test('should return failure when no network and no cache', () async {
      // Arrange
      when(() => mockLocalDatasource.isCacheValid())
          .thenAnswer((_) async => false);
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(() => mockLocalDatasource.getCachedPrayerTimes())
          .thenThrow(const CacheException());

      // Act
      final result = await repository.getPrayerTimes(location: tPosition);

      // Assert
      expect(result.isFailure, true);
      expect(result.failure, isA<NetworkFailure>());
    });

    test('should return cached data when network fails but cache exists',
        () async {
      // Arrange
      when(() => mockLocalDatasource.isCacheValid())
          .thenAnswer((_) async => false);
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDatasource.fetchPrayerTimes(
            location: any(named: 'location'),
          )).thenThrow(const ServerException());
      when(() => mockLocalDatasource.getCachedPrayerTimes())
          .thenAnswer((_) async => tPrayerTimesModel);
      when(() => mockLocalDatasource.getCachedLocationName())
          .thenAnswer((_) async => 'Cairo, Egypt');

      // Act
      final result = await repository.getPrayerTimes(location: tPosition);

      // Assert
      expect(result.isSuccess, true);
      expect(result.isFromCache, true);
    });

    test('should return ServerFailure when remote fails and no cache',
        () async {
      // Arrange
      when(() => mockLocalDatasource.isCacheValid())
          .thenAnswer((_) async => false);
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDatasource.fetchPrayerTimes(
            location: any(named: 'location'),
          )).thenThrow(const ServerException(message: 'Server error'));
      when(() => mockLocalDatasource.getCachedPrayerTimes())
          .thenThrow(const CacheException());

      // Act
      final result = await repository.getPrayerTimes(location: tPosition);

      // Assert
      expect(result.isFailure, true);
      expect(result.failure, isA<ServerFailure>());
    });
  });

  group('getCachedPrayerTimes', () {
    test('should return cached data when available', () async {
      // Arrange
      when(() => mockLocalDatasource.getCachedPrayerTimes())
          .thenAnswer((_) async => tPrayerTimesModel);
      when(() => mockLocalDatasource.getCachedLocationName())
          .thenAnswer((_) async => 'Cairo, Egypt');

      // Act
      final result = await repository.getCachedPrayerTimes();

      // Assert
      expect(result.isSuccess, true);
      expect(result.isFromCache, true);
    });

    test('should return CacheFailure when no cached data', () async {
      // Arrange
      when(() => mockLocalDatasource.getCachedPrayerTimes())
          .thenThrow(const CacheException(message: 'No cache'));

      // Act
      final result = await repository.getCachedPrayerTimes();

      // Assert
      expect(result.isFailure, true);
      expect(result.failure, isA<CacheFailure>());
    });
  });

  group('clearCache', () {
    test('should call localDatasource.clearCache', () async {
      // Arrange
      when(() => mockLocalDatasource.clearCache()).thenAnswer((_) async {});

      // Act
      await repository.clearCache();

      // Assert
      verify(() => mockLocalDatasource.clearCache()).called(1);
    });
  });
}
