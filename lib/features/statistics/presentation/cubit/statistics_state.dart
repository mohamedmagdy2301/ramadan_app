import 'package:equatable/equatable.dart';
import 'package:ramadan_app/features/statistics/domain/entities/daily_stats.dart';
import 'package:ramadan_app/features/statistics/domain/entities/stats_summary.dart';

/// Base state for statistics
sealed class StatisticsState extends Equatable {
  const StatisticsState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class StatisticsInitial extends StatisticsState {
  const StatisticsInitial();
}

/// Loading state
class StatisticsLoading extends StatisticsState {
  const StatisticsLoading();
}

/// Loaded state with all statistics data
class StatisticsLoaded extends StatisticsState {
  /// Today's statistics
  final DailyStats todayStats;

  /// Weekly summary
  final StatsSummary weeklySummary;

  /// Monthly summary
  final StatsSummary monthlySummary;

  /// All-time summary
  final StatsSummary allTimeSummary;

  /// Recent daily stats (last 7 days)
  final List<DailyStats> recentStats;

  const StatisticsLoaded({
    required this.todayStats,
    required this.weeklySummary,
    required this.monthlySummary,
    required this.allTimeSummary,
    required this.recentStats,
  });

  @override
  List<Object?> get props => [
        todayStats,
        weeklySummary,
        monthlySummary,
        allTimeSummary,
        recentStats,
      ];

  StatisticsLoaded copyWith({
    DailyStats? todayStats,
    StatsSummary? weeklySummary,
    StatsSummary? monthlySummary,
    StatsSummary? allTimeSummary,
    List<DailyStats>? recentStats,
  }) {
    return StatisticsLoaded(
      todayStats: todayStats ?? this.todayStats,
      weeklySummary: weeklySummary ?? this.weeklySummary,
      monthlySummary: monthlySummary ?? this.monthlySummary,
      allTimeSummary: allTimeSummary ?? this.allTimeSummary,
      recentStats: recentStats ?? this.recentStats,
    );
  }
}

/// Error state
class StatisticsError extends StatisticsState {
  final String message;

  const StatisticsError(this.message);

  @override
  List<Object?> get props => [message];
}
