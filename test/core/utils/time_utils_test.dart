import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ramadan_app/core/utils/functions/time_utils.dart';

void main() {
  group('TimeUtils.isTimeInFuture', () {
    test('should return true when time is in the future', () {
      // Arrange - Set "now" to 10:00
      final now = DateTime(2025, 1, 1, 10, 0);
      const time = TimeOfDay(hour: 14, minute: 30); // 2:30 PM

      // Act
      final result = TimeUtils.isTimeInFuture(time, now: now);

      // Assert
      expect(result, true);
    });

    test('should return false when time is in the past', () {
      // Arrange - Set "now" to 14:30
      final now = DateTime(2025, 1, 1, 14, 30);
      const time = TimeOfDay(hour: 10, minute: 0); // 10:00 AM

      // Act
      final result = TimeUtils.isTimeInFuture(time, now: now);

      // Assert
      expect(result, false);
    });

    test('should return false when time is exactly now', () {
      // Arrange
      final now = DateTime(2025, 1, 1, 14, 30);
      const time = TimeOfDay(hour: 14, minute: 30);

      // Act
      final result = TimeUtils.isTimeInFuture(time, now: now);

      // Assert
      expect(result, false);
    });

    test('should handle edge case: same hour different minute (future)', () {
      // Arrange - now is 14:30, selected is 14:45
      final now = DateTime(2025, 1, 1, 14, 30);
      const time = TimeOfDay(hour: 14, minute: 45);

      // Act
      final result = TimeUtils.isTimeInFuture(time, now: now);

      // Assert
      expect(result, true);
    });

    test('should handle edge case: same hour different minute (past)', () {
      // Arrange - now is 14:45, selected is 14:30
      final now = DateTime(2025, 1, 1, 14, 45);
      const time = TimeOfDay(hour: 14, minute: 30);

      // Act
      final result = TimeUtils.isTimeInFuture(time, now: now);

      // Assert
      expect(result, false);
    });

    test('should handle midnight correctly', () {
      // Arrange - now is 23:59, selected is 00:00
      final now = DateTime(2025, 1, 1, 23, 59);
      const time = TimeOfDay(hour: 0, minute: 0);

      // Act
      final result = TimeUtils.isTimeInFuture(time, now: now);

      // Assert - 00:00 on same day is in the past relative to 23:59
      expect(result, false);
    });
  });

  group('TimeUtils.isTimeInPast', () {
    test('should return true when time is in the past', () {
      final now = DateTime(2025, 1, 1, 14, 30);
      const time = TimeOfDay(hour: 10, minute: 0);

      expect(TimeUtils.isTimeInPast(time, now: now), true);
    });

    test('should return false when time is in the future', () {
      final now = DateTime(2025, 1, 1, 10, 0);
      const time = TimeOfDay(hour: 14, minute: 30);

      expect(TimeUtils.isTimeInPast(time, now: now), false);
    });
  });

  group('TimeUtils.timeOfDayToDateTime', () {
    test('should convert TimeOfDay to DateTime for today', () {
      const time = TimeOfDay(hour: 14, minute: 30);
      final date = DateTime(2025, 6, 15);

      final result = TimeUtils.timeOfDayToDateTime(time, date: date);

      expect(result.year, 2025);
      expect(result.month, 6);
      expect(result.day, 15);
      expect(result.hour, 14);
      expect(result.minute, 30);
    });
  });

  group('TimeUtils.getNextOccurrence', () {
    test('should return today if time is in the future', () {
      final now = DateTime(2025, 1, 1, 10, 0);
      const time = TimeOfDay(hour: 14, minute: 30);

      final result = TimeUtils.getNextOccurrence(time, now: now);

      expect(result.day, 1);
      expect(result.hour, 14);
      expect(result.minute, 30);
    });

    test('should return tomorrow if time is in the past', () {
      final now = DateTime(2025, 1, 1, 16, 0);
      const time = TimeOfDay(hour: 14, minute: 30);

      final result = TimeUtils.getNextOccurrence(time, now: now);

      expect(result.day, 2); // Tomorrow
      expect(result.hour, 14);
      expect(result.minute, 30);
    });

    test('should return tomorrow if time is exactly now', () {
      final now = DateTime(2025, 1, 1, 14, 30);
      const time = TimeOfDay(hour: 14, minute: 30);

      final result = TimeUtils.getNextOccurrence(time, now: now);

      expect(result.day, 2); // Tomorrow
    });
  });

  group('TimeUtils.formatTimeArabic', () {
    test('should format AM time correctly', () {
      const time = TimeOfDay(hour: 5, minute: 30);

      final result = TimeUtils.formatTimeArabic(time);

      expect(result, '5:30 ص');
    });

    test('should format PM time correctly', () {
      const time = TimeOfDay(hour: 14, minute: 45);

      final result = TimeUtils.formatTimeArabic(time);

      expect(result, '2:45 م');
    });

    test('should format 12 PM correctly', () {
      const time = TimeOfDay(hour: 12, minute: 0);

      final result = TimeUtils.formatTimeArabic(time);

      expect(result, '12:00 م');
    });

    test('should format 12 AM (midnight) correctly', () {
      const time = TimeOfDay(hour: 0, minute: 0);

      final result = TimeUtils.formatTimeArabic(time);

      expect(result, '12:00 ص');
    });

    test('should pad minutes with zero', () {
      const time = TimeOfDay(hour: 9, minute: 5);

      final result = TimeUtils.formatTimeArabic(time);

      expect(result, '9:05 ص');
    });
  });

  group('TimeUtils.durationBetween', () {
    test('should calculate duration between two times on same day', () {
      const from = TimeOfDay(hour: 10, minute: 0);
      const to = TimeOfDay(hour: 14, minute: 30);

      final result = TimeUtils.durationBetween(from, to);

      expect(result.inHours, 4);
      expect(result.inMinutes, 270); // 4 hours 30 minutes
    });

    test('should handle crossing midnight', () {
      const from = TimeOfDay(hour: 23, minute: 0);
      const to = TimeOfDay(hour: 1, minute: 0);

      final result = TimeUtils.durationBetween(from, to);

      expect(result.inHours, 2);
    });
  });

  group('TimeUtils.parseTimeString', () {
    test('should parse valid time string', () {
      final result = TimeUtils.parseTimeString('14:30');

      expect(result, isNotNull);
      expect(result!.hour, 14);
      expect(result.minute, 30);
    });

    test('should parse time with single digit hour', () {
      final result = TimeUtils.parseTimeString('5:30');

      expect(result, isNotNull);
      expect(result!.hour, 5);
      expect(result.minute, 30);
    });

    test('should return null for invalid format', () {
      expect(TimeUtils.parseTimeString('invalid'), isNull);
      expect(TimeUtils.parseTimeString('25:00'), isNull);
      expect(TimeUtils.parseTimeString('12:60'), isNull);
      expect(TimeUtils.parseTimeString(''), isNull);
    });

    test('should handle time with extra characters', () {
      final result = TimeUtils.parseTimeString('(14:30)');

      expect(result, isNotNull);
      expect(result!.hour, 14);
      expect(result.minute, 30);
    });
  });
}
