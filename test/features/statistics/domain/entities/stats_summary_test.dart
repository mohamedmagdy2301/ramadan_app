import 'package:flutter_test/flutter_test.dart';
import 'package:ramadan_app/features/statistics/domain/entities/daily_stats.dart';
import 'package:ramadan_app/features/statistics/domain/entities/stats_summary.dart';

void main() {
  group('StatsSummary', () {
    test('empty should create summary with all zeros', () {
      final summary = StatsSummary.empty();

      expect(summary.totalAzkarCompleted, 0);
      expect(summary.totalAzkarCount, 0);
      expect(summary.totalQuranPages, 0);
      expect(summary.totalQuranSurahs, 0);
      expect(summary.totalSabhaCount, 0);
      expect(summary.currentStreak, 0);
      expect(summary.longestStreak, 0);
      expect(summary.activeDays, 0);
      expect(summary.totalDays, 0);
    });

    test('fromDailyStats should calculate totals correctly', () {
      final stats = [
        DailyStats(
          date: '2024-01-15',
          azkarCompleted: 5,
          azkarCount: 100,
          quranPagesRead: 10,
          quranSurahsRead: 2,
          sabhaCount: 500,
          lastUpdated: DateTime.now(),
        ),
        DailyStats(
          date: '2024-01-14',
          azkarCompleted: 3,
          azkarCount: 50,
          quranPagesRead: 5,
          quranSurahsRead: 1,
          sabhaCount: 300,
          lastUpdated: DateTime.now(),
        ),
      ];

      final summary = StatsSummary.fromDailyStats(stats);

      expect(summary.totalAzkarCompleted, 8);
      expect(summary.totalAzkarCount, 150);
      expect(summary.totalQuranPages, 15);
      expect(summary.totalQuranSurahs, 3);
      expect(summary.totalSabhaCount, 800);
      expect(summary.activeDays, 2);
      expect(summary.totalDays, 2);
    });

    test('fromDailyStats with empty list should return empty summary', () {
      final summary = StatsSummary.fromDailyStats([]);

      expect(summary.totalAzkarCompleted, 0);
      expect(summary.activeDays, 0);
      expect(summary.totalDays, 0);
    });

    test('consistencyPercentage should calculate correctly', () {
      final summary = const StatsSummary(
        activeDays: 7,
        totalDays: 10,
      );

      expect(summary.consistencyPercentage, 70.0);
    });

    test('consistencyPercentage should return 0 when totalDays is 0', () {
      final summary = StatsSummary.empty();

      expect(summary.consistencyPercentage, 0.0);
    });

    test('should count active days correctly', () {
      final stats = [
        DailyStats(
          date: '2024-01-15',
          azkarCompleted: 5,
          lastUpdated: DateTime.now(),
        ),
        DailyStats(
          date: '2024-01-14',
          lastUpdated: DateTime.now(),
        ), // No activity
        DailyStats(
          date: '2024-01-13',
          sabhaCount: 100,
          lastUpdated: DateTime.now(),
        ),
      ];

      final summary = StatsSummary.fromDailyStats(stats);

      expect(summary.activeDays, 2);
      expect(summary.totalDays, 3);
    });
  });
}
