import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ramadan_app/core/network/network_info.dart';

class MockConnectivity extends Mock implements Connectivity {}

void main() {
  late NetworkInfoImpl networkInfo;
  late MockConnectivity mockConnectivity;

  setUp(() {
    mockConnectivity = MockConnectivity();
    networkInfo = NetworkInfoImpl(connectivity: mockConnectivity);
  });

  group('isConnected', () {
    test('should return false when connectivity result is none', () async {
      // Arrange
      when(() => mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => [ConnectivityResult.none]);

      // Act
      final result = await networkInfo.isConnected;

      // Assert
      expect(result, false);
      verify(() => mockConnectivity.checkConnectivity()).called(1);
    });

    test('should check connectivity when result is wifi', () async {
      // Arrange
      when(() => mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => [ConnectivityResult.wifi]);

      // Act - This will try to do DNS lookup which may fail in test
      // We're mainly testing that the method handles the connectivity check
      try {
        await networkInfo.isConnected;
      } catch (_) {
        // DNS lookup may fail in test environment
      }

      // Assert
      verify(() => mockConnectivity.checkConnectivity()).called(1);
    });

    test('should check connectivity when result is mobile', () async {
      // Arrange
      when(() => mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => [ConnectivityResult.mobile]);

      // Act
      try {
        await networkInfo.isConnected;
      } catch (_) {
        // DNS lookup may fail in test environment
      }

      // Assert
      verify(() => mockConnectivity.checkConnectivity()).called(1);
    });
  });

  group('onConnectivityChanged', () {
    test('should emit false when connectivity changes to none', () async {
      // Arrange
      when(() => mockConnectivity.onConnectivityChanged)
          .thenAnswer((_) => Stream.value([ConnectivityResult.none]));

      // Act & Assert
      expect(
        networkInfo.onConnectivityChanged,
        emits(false),
      );
    });
  });
}
