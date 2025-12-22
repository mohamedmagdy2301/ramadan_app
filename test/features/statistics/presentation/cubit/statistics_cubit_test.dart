import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ramadan_app/features/statistics/data/statistics_local_datasource.dart';
import 'package:ramadan_app/features/statistics/domain/entities/daily_stats.dart';
import 'package:ramadan_app/features/statistics/domain/entities/stats_summary.dart';
import 'package:ramadan_app/features/statistics/presentation/cubit/statistics_cubit.dart';
import 'package:ramadan_app/features/statistics/presentation/cubit/statistics_state.dart';

class MockStatisticsLocalDatasource extends Mock
    implements IStatisticsLocalDatasource {}

void main() {
  late MockStatisticsLocalDatasource mockDatasource;
  late StatisticsCubit cubit;

  setUp(() {
    mockDatasource = MockStatisticsLocalDatasource();
    cubit = StatisticsCubit(mockDatasource);
  });

  tearDown(() {
    cubit.close();
  });

  final testDate = DateTime.now();
  final testDateStr =
      '${testDate.year}-${testDate.month.toString().padLeft(2, '0')}-${testDate.day.toString().padLeft(2, '0')}';

  final todayStats = DailyStats(
    date: testDateStr,
    azkarCompleted: 5,
    azkarCount: 100,
    quranPagesRead: 10,
    quranSurahsRead: 2,
    sabhaCount: 500,
    lastUpdated: testDate,
  );

  final weeklySummary = const StatsSummary(
    totalAzkarCompleted: 20,
    totalAzkarCount: 400,
    totalQuranPages: 30,
    totalQuranSurahs: 7,
    totalSabhaCount: 2000,
    currentStreak: 3,
    longestStreak: 5,
    activeDays: 5,
    totalDays: 7,
  );

  final monthlySummary = const StatsSummary(
    totalAzkarCompleted: 80,
    totalAzkarCount: 1600,
    totalQuranPages: 120,
    totalQuranSurahs: 30,
    totalSabhaCount: 8000,
    currentStreak: 3,
    longestStreak: 10,
    activeDays: 20,
    totalDays: 30,
  );

  final allTimeSummary = const StatsSummary(
    totalAzkarCompleted: 200,
    totalAzkarCount: 4000,
    totalQuranPages: 300,
    totalQuranSurahs: 60,
    totalSabhaCount: 20000,
    currentStreak: 3,
    longestStreak: 15,
    activeDays: 50,
    totalDays: 90,
  );

  group('StatisticsCubit', () {
    test('initial state should be StatisticsInitial', () {
      expect(cubit.state, const StatisticsInitial());
    });

    blocTest<StatisticsCubit, StatisticsState>(
      'loadStatistics should emit loading then loaded',
      build: () {
        when(() => mockDatasource.getTodayStats())
            .thenAnswer((_) async => todayStats);
        when(() => mockDatasource.getWeeklySummary())
            .thenAnswer((_) async => weeklySummary);
        when(() => mockDatasource.getMonthlySummary())
            .thenAnswer((_) async => monthlySummary);
        when(() => mockDatasource.getStatsSummary())
            .thenAnswer((_) async => allTimeSummary);
        when(() => mockDatasource.getStatsRange(any(), any()))
            .thenAnswer((_) async => [todayStats]);
        return cubit;
      },
      act: (cubit) => cubit.loadStatistics(),
      expect: () => [
        const StatisticsLoading(),
        isA<StatisticsLoaded>()
            .having((s) => s.todayStats, 'todayStats', todayStats)
            .having((s) => s.weeklySummary, 'weeklySummary', weeklySummary)
            .having((s) => s.monthlySummary, 'monthlySummary', monthlySummary)
            .having(
                (s) => s.allTimeSummary, 'allTimeSummary', allTimeSummary),
      ],
      verify: (_) {
        verify(() => mockDatasource.getTodayStats()).called(1);
        verify(() => mockDatasource.getWeeklySummary()).called(1);
        verify(() => mockDatasource.getMonthlySummary()).called(1);
        verify(() => mockDatasource.getStatsSummary()).called(1);
      },
    );

    blocTest<StatisticsCubit, StatisticsState>(
      'loadStatistics should emit error on exception',
      build: () {
        when(() => mockDatasource.getTodayStats())
            .thenThrow(Exception('Test error'));
        return cubit;
      },
      act: (cubit) => cubit.loadStatistics(),
      expect: () => [
        const StatisticsLoading(),
        isA<StatisticsError>(),
      ],
    );

    blocTest<StatisticsCubit, StatisticsState>(
      'incrementAzkarCompleted should call datasource',
      build: () {
        when(() => mockDatasource.incrementAzkarCompleted(count: any(named: 'count')))
            .thenAnswer((_) async {});
        return cubit;
      },
      act: (cubit) => cubit.incrementAzkarCompleted(count: 1),
      verify: (_) {
        verify(() => mockDatasource.incrementAzkarCompleted(count: 1)).called(1);
      },
    );

    blocTest<StatisticsCubit, StatisticsState>(
      'incrementQuranSurahs should call datasource',
      build: () {
        when(() => mockDatasource.incrementQuranSurahs(count: any(named: 'count')))
            .thenAnswer((_) async {});
        return cubit;
      },
      act: (cubit) => cubit.incrementQuranSurahs(count: 1),
      verify: (_) {
        verify(() => mockDatasource.incrementQuranSurahs(count: 1)).called(1);
      },
    );

    blocTest<StatisticsCubit, StatisticsState>(
      'incrementSabhaCount should call datasource',
      build: () {
        when(() => mockDatasource.incrementSabhaCount(count: any(named: 'count')))
            .thenAnswer((_) async {});
        return cubit;
      },
      act: (cubit) => cubit.incrementSabhaCount(count: 100),
      verify: (_) {
        verify(() => mockDatasource.incrementSabhaCount(count: 100)).called(1);
      },
    );

    blocTest<StatisticsCubit, StatisticsState>(
      'clearAllStatistics should clear and reload',
      build: () {
        when(() => mockDatasource.clearAllStats())
            .thenAnswer((_) async {});
        when(() => mockDatasource.getTodayStats())
            .thenAnswer((_) async => DailyStats.empty(testDateStr));
        when(() => mockDatasource.getWeeklySummary())
            .thenAnswer((_) async => StatsSummary.empty());
        when(() => mockDatasource.getMonthlySummary())
            .thenAnswer((_) async => StatsSummary.empty());
        when(() => mockDatasource.getStatsSummary())
            .thenAnswer((_) async => StatsSummary.empty());
        when(() => mockDatasource.getStatsRange(any(), any()))
            .thenAnswer((_) async => []);
        return cubit;
      },
      act: (cubit) => cubit.clearAllStatistics(),
      expect: () => [
        const StatisticsLoading(),
        isA<StatisticsLoaded>(),
      ],
      verify: (_) {
        verify(() => mockDatasource.clearAllStats()).called(1);
      },
    );
  });
}
