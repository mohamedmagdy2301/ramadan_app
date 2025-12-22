import 'dart:convert';

import 'package:ramadan_app/core/local_storage/shared_preferences_manager.dart';
import 'package:ramadan_app/features/statistics/domain/entities/daily_stats.dart';
import 'package:ramadan_app/features/statistics/domain/entities/stats_summary.dart';

/// Interface for statistics local datasource
abstract class IStatisticsLocalDatasource {
  /// Get today's stats
  Future<DailyStats> getTodayStats();

  /// Get stats for a specific date
  Future<DailyStats?> getStatsForDate(String date);

  /// Get stats for a date range
  Future<List<DailyStats>> getStatsRange(String startDate, String endDate);

  /// Get all stats
  Future<List<DailyStats>> getAllStats();

  /// Save daily stats
  Future<void> saveStats(DailyStats stats);

  /// Increment azkar completed count
  Future<void> incrementAzkarCompleted({int count = 1});

  /// Increment azkar count
  Future<void> incrementAzkarCount({int count = 1});

  /// Increment quran pages read
  Future<void> incrementQuranPages({int count = 1});

  /// Increment quran surahs read
  Future<void> incrementQuranSurahs({int count = 1});

  /// Increment sabha count
  Future<void> incrementSabhaCount({int count = 1});

  /// Get stats summary
  Future<StatsSummary> getStatsSummary();

  /// Get weekly summary
  Future<StatsSummary> getWeeklySummary();

  /// Get monthly summary
  Future<StatsSummary> getMonthlySummary();

  /// Clear all stats
  Future<void> clearAllStats();
}

/// Key for storing statistics
const String _statsKey = 'daily_statistics';

/// Implementation of statistics local datasource
class StatisticsLocalDatasource implements IStatisticsLocalDatasource {
  /// Get current date in YYYY-MM-DD format
  String _getToday() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  /// Load all stats from storage
  Future<Map<String, DailyStats>> _loadAllStats() async {
    final jsonString = await SharedPreferencesManager.getData(key: _statsKey);
    if (jsonString == null) return {};

    try {
      final Map<String, dynamic> jsonMap = json.decode(jsonString as String);
      return jsonMap.map((key, value) => MapEntry(
            key,
            DailyStats.fromJson(value as Map<String, dynamic>),
          ));
    } catch (e) {
      return {};
    }
  }

  /// Save all stats to storage
  Future<void> _saveAllStats(Map<String, DailyStats> stats) async {
    final jsonMap = stats.map((key, value) => MapEntry(key, value.toJson()));
    await SharedPreferencesManager.setData(
      key: _statsKey,
      value: json.encode(jsonMap),
    );
  }

  @override
  Future<DailyStats> getTodayStats() async {
    final today = _getToday();
    final allStats = await _loadAllStats();
    return allStats[today] ?? DailyStats.empty(today);
  }

  @override
  Future<DailyStats?> getStatsForDate(String date) async {
    final allStats = await _loadAllStats();
    return allStats[date];
  }

  @override
  Future<List<DailyStats>> getStatsRange(
      String startDate, String endDate) async {
    final allStats = await _loadAllStats();
    return allStats.entries
        .where((e) => e.key.compareTo(startDate) >= 0 && e.key.compareTo(endDate) <= 0)
        .map((e) => e.value)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  @override
  Future<List<DailyStats>> getAllStats() async {
    final allStats = await _loadAllStats();
    return allStats.values.toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  @override
  Future<void> saveStats(DailyStats stats) async {
    final allStats = await _loadAllStats();
    allStats[stats.date] = stats;
    await _saveAllStats(allStats);
  }

  Future<DailyStats> _updateTodayStats(
      DailyStats Function(DailyStats current) update) async {
    final today = _getToday();
    final allStats = await _loadAllStats();
    final currentStats = allStats[today] ?? DailyStats.empty(today);
    final updatedStats = update(currentStats);
    allStats[today] = updatedStats;
    await _saveAllStats(allStats);
    return updatedStats;
  }

  @override
  Future<void> incrementAzkarCompleted({int count = 1}) async {
    await _updateTodayStats((current) => current.copyWith(
          azkarCompleted: current.azkarCompleted + count,
          lastUpdated: DateTime.now(),
        ));
  }

  @override
  Future<void> incrementAzkarCount({int count = 1}) async {
    await _updateTodayStats((current) => current.copyWith(
          azkarCount: current.azkarCount + count,
          lastUpdated: DateTime.now(),
        ));
  }

  @override
  Future<void> incrementQuranPages({int count = 1}) async {
    await _updateTodayStats((current) => current.copyWith(
          quranPagesRead: current.quranPagesRead + count,
          lastUpdated: DateTime.now(),
        ));
  }

  @override
  Future<void> incrementQuranSurahs({int count = 1}) async {
    await _updateTodayStats((current) => current.copyWith(
          quranSurahsRead: current.quranSurahsRead + count,
          lastUpdated: DateTime.now(),
        ));
  }

  @override
  Future<void> incrementSabhaCount({int count = 1}) async {
    await _updateTodayStats((current) => current.copyWith(
          sabhaCount: current.sabhaCount + count,
          lastUpdated: DateTime.now(),
        ));
  }

  @override
  Future<StatsSummary> getStatsSummary() async {
    final allStats = await getAllStats();
    return StatsSummary.fromDailyStats(allStats);
  }

  @override
  Future<StatsSummary> getWeeklySummary() async {
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));
    final startDate =
        '${weekAgo.year}-${weekAgo.month.toString().padLeft(2, '0')}-${weekAgo.day.toString().padLeft(2, '0')}';
    final endDate = _getToday();
    final stats = await getStatsRange(startDate, endDate);
    return StatsSummary.fromDailyStats(stats);
  }

  @override
  Future<StatsSummary> getMonthlySummary() async {
    final now = DateTime.now();
    final monthAgo = now.subtract(const Duration(days: 30));
    final startDate =
        '${monthAgo.year}-${monthAgo.month.toString().padLeft(2, '0')}-${monthAgo.day.toString().padLeft(2, '0')}';
    final endDate = _getToday();
    final stats = await getStatsRange(startDate, endDate);
    return StatsSummary.fromDailyStats(stats);
  }

  @override
  Future<void> clearAllStats() async {
    await SharedPreferencesManager.removeData(key: _statsKey);
  }
}
