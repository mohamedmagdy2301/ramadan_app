import 'package:equatable/equatable.dart';

import 'daily_stats.dart';

/// Summary of statistics over a period
class StatsSummary extends Equatable {
  /// Total azkar categories completed
  final int totalAzkarCompleted;

  /// Total azkar count
  final int totalAzkarCount;

  /// Total Quran pages read
  final int totalQuranPages;

  /// Total Quran surahs read
  final int totalQuranSurahs;

  /// Total sabha count
  final int totalSabhaCount;

  /// Current streak (consecutive days with activity)
  final int currentStreak;

  /// Longest streak ever
  final int longestStreak;

  /// Number of days with activity
  final int activeDays;

  /// Total number of days tracked
  final int totalDays;

  const StatsSummary({
    this.totalAzkarCompleted = 0,
    this.totalAzkarCount = 0,
    this.totalQuranPages = 0,
    this.totalQuranSurahs = 0,
    this.totalSabhaCount = 0,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.activeDays = 0,
    this.totalDays = 0,
  });

  /// Create empty summary
  factory StatsSummary.empty() => const StatsSummary();

  /// Calculate summary from a list of daily stats
  factory StatsSummary.fromDailyStats(List<DailyStats> stats) {
    if (stats.isEmpty) return StatsSummary.empty();

    // Sort by date descending
    final sortedStats = List<DailyStats>.from(stats)
      ..sort((a, b) => b.date.compareTo(a.date));

    int totalAzkarCompleted = 0;
    int totalAzkarCount = 0;
    int totalQuranPages = 0;
    int totalQuranSurahs = 0;
    int totalSabhaCount = 0;
    int activeDays = 0;

    for (final stat in sortedStats) {
      totalAzkarCompleted += stat.azkarCompleted;
      totalAzkarCount += stat.azkarCount;
      totalQuranPages += stat.quranPagesRead;
      totalQuranSurahs += stat.quranSurahsRead;
      totalSabhaCount += stat.sabhaCount;
      if (stat.hasActivity) activeDays++;
    }

    // Calculate streaks
    final streakResult = _calculateStreaks(sortedStats);

    return StatsSummary(
      totalAzkarCompleted: totalAzkarCompleted,
      totalAzkarCount: totalAzkarCount,
      totalQuranPages: totalQuranPages,
      totalQuranSurahs: totalQuranSurahs,
      totalSabhaCount: totalSabhaCount,
      currentStreak: streakResult.current,
      longestStreak: streakResult.longest,
      activeDays: activeDays,
      totalDays: stats.length,
    );
  }

  static ({int current, int longest}) _calculateStreaks(
      List<DailyStats> sortedStats) {
    if (sortedStats.isEmpty) return (current: 0, longest: 0);

    int currentStreak = 0;
    int longestStreak = 0;
    int tempStreak = 0;

    // Check if today has activity for current streak
    final today = _formatDate(DateTime.now());
    final yesterday = _formatDate(DateTime.now().subtract(const Duration(days: 1)));

    bool isCurrentStreakActive = false;

    for (int i = 0; i < sortedStats.length; i++) {
      final stat = sortedStats[i];

      if (stat.hasActivity) {
        tempStreak++;

        // Check if this is part of current streak
        if (i == 0 && (stat.date == today || stat.date == yesterday)) {
          isCurrentStreakActive = true;
        }

        // Check continuity
        if (i < sortedStats.length - 1) {
          final currentDate = DateTime.parse(stat.date);
          final nextDate = DateTime.parse(sortedStats[i + 1].date);
          final diff = currentDate.difference(nextDate).inDays;

          if (diff != 1) {
            // Streak broken
            if (isCurrentStreakActive && currentStreak == 0) {
              currentStreak = tempStreak;
            }
            longestStreak = tempStreak > longestStreak ? tempStreak : longestStreak;
            tempStreak = 0;
            isCurrentStreakActive = false;
          }
        }
      } else {
        // No activity, streak broken
        if (isCurrentStreakActive && currentStreak == 0) {
          currentStreak = tempStreak;
        }
        longestStreak = tempStreak > longestStreak ? tempStreak : longestStreak;
        tempStreak = 0;
        isCurrentStreakActive = false;
      }
    }

    // Final check for last streak
    if (isCurrentStreakActive && currentStreak == 0) {
      currentStreak = tempStreak;
    }
    longestStreak = tempStreak > longestStreak ? tempStreak : longestStreak;

    return (current: currentStreak, longest: longestStreak);
  }

  static String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  /// Get consistency percentage
  double get consistencyPercentage {
    if (totalDays == 0) return 0;
    return (activeDays / totalDays) * 100;
  }

  @override
  List<Object?> get props => [
        totalAzkarCompleted,
        totalAzkarCount,
        totalQuranPages,
        totalQuranSurahs,
        totalSabhaCount,
        currentStreak,
        longestStreak,
        activeDays,
        totalDays,
      ];
}
