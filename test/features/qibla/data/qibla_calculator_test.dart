import 'package:flutter_test/flutter_test.dart';
import 'package:ramadan_app/features/qibla/data/qibla_calculator.dart';

void main() {
  group('QiblaCalculator', () {
    group('calculateQiblaDirection', () {
      test('should return correct direction from Cairo, Egypt', () {
        // Cairo coordinates: 30.0444° N, 31.2357° E
        // Expected Qibla direction: approximately 135° (Southeast)
        final direction = QiblaCalculator.calculateQiblaDirection(
          30.0444,
          31.2357,
        );

        // Cairo to Mecca should be approximately 135° (Southeast)
        expect(direction, greaterThan(130));
        expect(direction, lessThan(140));
      });

      test('should return correct direction from London, UK', () {
        // London coordinates: 51.5074° N, 0.1278° W
        final direction = QiblaCalculator.calculateQiblaDirection(
          51.5074,
          -0.1278,
        );

        // London to Mecca should be approximately 119° (East-Southeast)
        expect(direction, greaterThan(115));
        expect(direction, lessThan(125));
      });

      test('should return correct direction from New York, USA', () {
        // New York coordinates: 40.7128° N, 74.0060° W
        final direction = QiblaCalculator.calculateQiblaDirection(
          40.7128,
          -74.0060,
        );

        // New York to Mecca should be approximately 59° (Northeast)
        expect(direction, greaterThan(55));
        expect(direction, lessThan(65));
      });

      test('should return correct direction from Tokyo, Japan', () {
        // Tokyo coordinates: 35.6762° N, 139.6503° E
        final direction = QiblaCalculator.calculateQiblaDirection(
          35.6762,
          139.6503,
        );

        // Tokyo to Mecca should be approximately 293° (West-Northwest)
        expect(direction, greaterThan(288));
        expect(direction, lessThan(298));
      });

      test('should return 0 when at Kaaba location', () {
        // At the Kaaba itself, direction should be 0 or any value
        // (mathematically undefined or 0)
        final direction = QiblaCalculator.calculateQiblaDirection(
          21.4225,
          39.8262,
        );

        // The result should be a valid number (not NaN)
        expect(direction.isNaN, false);
      });

      test('should return direction within valid range (0-360)', () {
        // Test various locations
        final testCases = [
          [30.0444, 31.2357], // Cairo
          [51.5074, -0.1278], // London
          [-33.8688, 151.2093], // Sydney
          [55.7558, 37.6173], // Moscow
          [-23.5505, -46.6333], // São Paulo
        ];

        for (final coords in testCases) {
          final direction = QiblaCalculator.calculateQiblaDirection(
            coords[0],
            coords[1],
          );

          expect(direction, greaterThanOrEqualTo(0));
          expect(direction, lessThan(360));
        }
      });
    });

    group('calculateDistanceToKaaba', () {
      test('should return correct distance from Cairo to Kaaba', () {
        // Cairo to Mecca is approximately 1,200 km
        final distance = QiblaCalculator.calculateDistanceToKaaba(
          30.0444,
          31.2357,
        );

        expect(distance, greaterThan(1100));
        expect(distance, lessThan(1300));
      });

      test('should return correct distance from London to Kaaba', () {
        // London to Mecca is approximately 4,600 km
        final distance = QiblaCalculator.calculateDistanceToKaaba(
          51.5074,
          -0.1278,
        );

        expect(distance, greaterThan(4400));
        expect(distance, lessThan(4800));
      });

      test('should return 0 when at Kaaba location', () {
        final distance = QiblaCalculator.calculateDistanceToKaaba(
          21.4225,
          39.8262,
        );

        expect(distance, lessThan(1)); // Should be approximately 0
      });

      test('should return positive distance for all locations', () {
        final testCases = [
          [30.0444, 31.2357], // Cairo
          [51.5074, -0.1278], // London
          [-33.8688, 151.2093], // Sydney
          [55.7558, 37.6173], // Moscow
          [-23.5505, -46.6333], // São Paulo
        ];

        for (final coords in testCases) {
          final distance = QiblaCalculator.calculateDistanceToKaaba(
            coords[0],
            coords[1],
          );

          expect(distance, greaterThan(0));
        }
      });
    });
  });
}
