import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ramadan_app/features/statistics/data/statistics_local_datasource.dart';
import 'package:ramadan_app/features/statistics/presentation/cubit/statistics_state.dart';

/// Cubit for managing statistics state
class StatisticsCubit extends Cubit<StatisticsState> {
  final IStatisticsLocalDatasource _datasource;

  StatisticsCubit(this._datasource) : super(const StatisticsInitial());

  /// Load all statistics
  Future<void> loadStatistics() async {
    emit(const StatisticsLoading());

    try {
      final todayStats = await _datasource.getTodayStats();
      final weeklySummary = await _datasource.getWeeklySummary();
      final monthlySummary = await _datasource.getMonthlySummary();
      final allTimeSummary = await _datasource.getStatsSummary();

      // Get last 7 days of stats
      final now = DateTime.now();
      final weekAgo = now.subtract(const Duration(days: 7));
      final startDate =
          '${weekAgo.year}-${weekAgo.month.toString().padLeft(2, '0')}-${weekAgo.day.toString().padLeft(2, '0')}';
      final endDate =
          '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
      final recentStats = await _datasource.getStatsRange(startDate, endDate);

      emit(StatisticsLoaded(
        todayStats: todayStats,
        weeklySummary: weeklySummary,
        monthlySummary: monthlySummary,
        allTimeSummary: allTimeSummary,
        recentStats: recentStats,
      ));
    } catch (e) {
      emit(StatisticsError(e.toString()));
    }
  }

  /// Increment azkar completed
  Future<void> incrementAzkarCompleted({int count = 1}) async {
    await _datasource.incrementAzkarCompleted(count: count);
    await _refreshIfLoaded();
  }

  /// Increment azkar count
  Future<void> incrementAzkarCount({int count = 1}) async {
    await _datasource.incrementAzkarCount(count: count);
    await _refreshIfLoaded();
  }

  /// Increment quran pages
  Future<void> incrementQuranPages({int count = 1}) async {
    await _datasource.incrementQuranPages(count: count);
    await _refreshIfLoaded();
  }

  /// Increment quran surahs
  Future<void> incrementQuranSurahs({int count = 1}) async {
    await _datasource.incrementQuranSurahs(count: count);
    await _refreshIfLoaded();
  }

  /// Increment sabha count
  Future<void> incrementSabhaCount({int count = 1}) async {
    await _datasource.incrementSabhaCount(count: count);
    await _refreshIfLoaded();
  }

  /// Clear all statistics
  Future<void> clearAllStatistics() async {
    await _datasource.clearAllStats();
    await loadStatistics();
  }

  /// Refresh stats if already loaded
  Future<void> _refreshIfLoaded() async {
    if (state is StatisticsLoaded) {
      final todayStats = await _datasource.getTodayStats();
      final weeklySummary = await _datasource.getWeeklySummary();
      final monthlySummary = await _datasource.getMonthlySummary();
      final allTimeSummary = await _datasource.getStatsSummary();

      emit((state as StatisticsLoaded).copyWith(
        todayStats: todayStats,
        weeklySummary: weeklySummary,
        monthlySummary: monthlySummary,
        allTimeSummary: allTimeSummary,
      ));
    }
  }
}
