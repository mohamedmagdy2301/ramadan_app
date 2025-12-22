import 'package:flutter_test/flutter_test.dart';
import 'package:ramadan_app/features/statistics/domain/entities/daily_stats.dart';

void main() {
  group('DailyStats', () {
    test('should create empty stats with correct date', () {
      final date = '2024-01-15';
      final stats = DailyStats.empty(date);

      expect(stats.date, date);
      expect(stats.azkarCompleted, 0);
      expect(stats.azkarCount, 0);
      expect(stats.quranPagesRead, 0);
      expect(stats.quranSurahsRead, 0);
      expect(stats.sabhaCount, 0);
    });

    test('should serialize to JSON correctly', () {
      final stats = DailyStats(
        date: '2024-01-15',
        azkarCompleted: 5,
        azkarCount: 100,
        quranPagesRead: 10,
        quranSurahsRead: 2,
        sabhaCount: 500,
        lastUpdated: DateTime(2024, 1, 15, 10, 30),
      );

      final json = stats.toJson();

      expect(json['date'], '2024-01-15');
      expect(json['azkarCompleted'], 5);
      expect(json['azkarCount'], 100);
      expect(json['quranPagesRead'], 10);
      expect(json['quranSurahsRead'], 2);
      expect(json['sabhaCount'], 500);
      expect(json['lastUpdated'], '2024-01-15T10:30:00.000');
    });

    test('should deserialize from JSON correctly', () {
      final json = {
        'date': '2024-01-15',
        'azkarCompleted': 5,
        'azkarCount': 100,
        'quranPagesRead': 10,
        'quranSurahsRead': 2,
        'sabhaCount': 500,
        'lastUpdated': '2024-01-15T10:30:00.000',
      };

      final stats = DailyStats.fromJson(json);

      expect(stats.date, '2024-01-15');
      expect(stats.azkarCompleted, 5);
      expect(stats.azkarCount, 100);
      expect(stats.quranPagesRead, 10);
      expect(stats.quranSurahsRead, 2);
      expect(stats.sabhaCount, 500);
    });

    test('should handle missing values in JSON', () {
      final json = {
        'date': '2024-01-15',
        'lastUpdated': '2024-01-15T10:30:00.000',
      };

      final stats = DailyStats.fromJson(json);

      expect(stats.date, '2024-01-15');
      expect(stats.azkarCompleted, 0);
      expect(stats.azkarCount, 0);
      expect(stats.quranPagesRead, 0);
      expect(stats.quranSurahsRead, 0);
      expect(stats.sabhaCount, 0);
    });

    test('hasActivity should return true when any activity exists', () {
      final statsWithAzkar = DailyStats(
        date: '2024-01-15',
        azkarCompleted: 1,
        lastUpdated: DateTime.now(),
      );
      expect(statsWithAzkar.hasActivity, true);

      final statsWithQuran = DailyStats(
        date: '2024-01-15',
        quranSurahsRead: 1,
        lastUpdated: DateTime.now(),
      );
      expect(statsWithQuran.hasActivity, true);

      final statsWithSabha = DailyStats(
        date: '2024-01-15',
        sabhaCount: 1,
        lastUpdated: DateTime.now(),
      );
      expect(statsWithSabha.hasActivity, true);
    });

    test('hasActivity should return false when no activity exists', () {
      final stats = DailyStats.empty('2024-01-15');
      expect(stats.hasActivity, false);
    });

    test('copyWith should create new instance with updated values', () {
      final original = DailyStats(
        date: '2024-01-15',
        azkarCompleted: 5,
        lastUpdated: DateTime(2024, 1, 15),
      );

      final updated = original.copyWith(azkarCompleted: 10);

      expect(updated.azkarCompleted, 10);
      expect(updated.date, original.date);
      expect(original.azkarCompleted, 5); // Original unchanged
    });

    test('activityScore should calculate correctly', () {
      final stats = DailyStats(
        date: '2024-01-15',
        azkarCompleted: 3,
        quranSurahsRead: 2,
        sabhaCount: 350,
        lastUpdated: DateTime.now(),
      );

      // 3 + 2 + (350 ~/ 100) = 3 + 2 + 3 = 8
      expect(stats.activityScore, 8);
    });
  });
}
