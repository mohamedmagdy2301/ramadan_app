import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ramadan_app/core/constants/app_strings.dart';
import 'package:ramadan_app/core/constants/app_text_style.dart';
import 'package:ramadan_app/core/di/injection_container.dart';
import 'package:ramadan_app/core/extensions/context_extensions.dart';
import 'package:ramadan_app/core/utils/widgets/custom_loading_widget.dart';
import 'package:ramadan_app/features/statistics/presentation/cubit/statistics_cubit.dart';
import 'package:ramadan_app/features/statistics/presentation/cubit/statistics_state.dart';
import 'package:ramadan_app/features/statistics/presentation/widgets/empty_stats_widget.dart';
import 'package:ramadan_app/features/statistics/presentation/widgets/stat_card.dart';
import 'package:ramadan_app/features/statistics/presentation/widgets/streak_card.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  static const String routeName = '/statistics';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<StatisticsCubit>()..loadStatistics(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppStrings.statistics,
            style: StyleText.bold20().copyWith(
              color: context.onPrimaryColor,
            ),
          ),
          centerTitle: true,
        ),
        body: BlocBuilder<StatisticsCubit, StatisticsState>(
          builder: (context, state) {
            if (state is StatisticsLoading) {
              return const Center(child: CustomLoadingWidget());
            }

            if (state is StatisticsError) {
              return Center(
                child: Text(
                  state.message,
                  style: StyleText.regular16().copyWith(
                    color: context.onPrimaryColor,
                  ),
                ),
              );
            }

            if (state is StatisticsLoaded) {
              if (!state.allTimeSummary.totalDays.isNaN &&
                  state.allTimeSummary.totalDays == 0 &&
                  !state.todayStats.hasActivity) {
                return const EmptyStatsWidget();
              }

              return SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Streak Card
                    StreakCard(
                      currentStreak: state.allTimeSummary.currentStreak,
                      longestStreak: state.allTimeSummary.longestStreak,
                    ),
                    SizedBox(height: 24.h),

                    // Today's Stats Section
                    _buildSectionHeader(context, AppStrings.todayStats),
                    SizedBox(height: 12.h),
                    _buildTodayStatsGrid(context, state),
                    SizedBox(height: 24.h),

                    // Weekly Summary Section
                    _buildSectionHeader(context, AppStrings.weeklySummary),
                    SizedBox(height: 12.h),
                    _buildSummaryGrid(context, state.weeklySummary.totalAzkarCompleted,
                        state.weeklySummary.totalQuranSurahs,
                        state.weeklySummary.totalSabhaCount),
                    SizedBox(height: 24.h),

                    // All Time Summary Section
                    _buildSectionHeader(context, AppStrings.allTimeSummary),
                    SizedBox(height: 12.h),
                    _buildAllTimeSummary(context, state),
                    SizedBox(height: 24.h),
                  ],
                ),
              );
            }

            return const EmptyStatsWidget();
          },
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: StyleText.bold18().copyWith(
        color: context.onPrimaryColor,
      ),
    );
  }

  Widget _buildTodayStatsGrid(BuildContext context, StatisticsLoaded state) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12.h,
      crossAxisSpacing: 12.w,
      childAspectRatio: 1.2,
      children: [
        StatCard(
          title: AppStrings.azkarCompleted,
          value: '${state.todayStats.azkarCompleted}',
          icon: Icons.check_circle_outline,
          iconColor: Colors.green,
        ),
        StatCard(
          title: AppStrings.quranSurahsRead,
          value: '${state.todayStats.quranSurahsRead}',
          icon: Icons.menu_book,
          iconColor: Colors.blue,
        ),
        StatCard(
          title: AppStrings.sabhaCountStats,
          value: '${state.todayStats.sabhaCount}',
          icon: Icons.radio_button_checked,
          iconColor: Colors.purple,
        ),
        StatCard(
          title: AppStrings.azkarCount,
          value: '${state.todayStats.azkarCount}',
          icon: Icons.format_list_numbered,
          iconColor: Colors.orange,
        ),
      ],
    );
  }

  Widget _buildSummaryGrid(BuildContext context, int azkar, int quran, int sabha) {
    return Row(
      children: [
        Expanded(
          child: _buildMiniStat(
            context,
            Icons.check_circle_outline,
            '$azkar',
            AppStrings.azkarCompleted,
            Colors.green,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildMiniStat(
            context,
            Icons.menu_book,
            '$quran',
            AppStrings.quranSurahsRead,
            Colors.blue,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildMiniStat(
            context,
            Icons.radio_button_checked,
            '$sabha',
            AppStrings.sabhaCountStats,
            Colors.purple,
          ),
        ),
      ],
    );
  }

  Widget _buildMiniStat(
    BuildContext context,
    IconData icon,
    String value,
    String label,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: context.isDark
            ? const Color.fromARGB(255, 31, 31, 31)
            : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24.sp),
          SizedBox(height: 8.h),
          Text(
            value,
            style: StyleText.bold18().copyWith(
              color: context.onPrimaryColor,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: StyleText.regular10().copyWith(
              color: context.onPrimaryColor.withAlpha(150),
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildAllTimeSummary(BuildContext context, StatisticsLoaded state) {
    final summary = state.allTimeSummary;
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: context.isDark
            ? const Color.fromARGB(255, 31, 31, 31)
            : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          _buildSummaryRow(
            context,
            AppStrings.activeDays,
            '${summary.activeDays} ${AppStrings.day}',
            Icons.calendar_today,
          ),
          Divider(color: context.onPrimaryColor.withAlpha(30)),
          _buildSummaryRow(
            context,
            AppStrings.consistency,
            '${summary.consistencyPercentage.toStringAsFixed(0)}%',
            Icons.trending_up,
          ),
          Divider(color: context.onPrimaryColor.withAlpha(30)),
          _buildSummaryRow(
            context,
            AppStrings.azkarCompleted,
            '${summary.totalAzkarCompleted}',
            Icons.check_circle_outline,
          ),
          Divider(color: context.onPrimaryColor.withAlpha(30)),
          _buildSummaryRow(
            context,
            AppStrings.quranSurahsRead,
            '${summary.totalQuranSurahs}',
            Icons.menu_book,
          ),
          Divider(color: context.onPrimaryColor.withAlpha(30)),
          _buildSummaryRow(
            context,
            AppStrings.sabhaCountStats,
            '${summary.totalSabhaCount}',
            Icons.radio_button_checked,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Icon(
            icon,
            color: context.primaryColor,
            size: 20.sp,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              label,
              style: StyleText.regular14().copyWith(
                color: context.onPrimaryColor,
              ),
            ),
          ),
          Text(
            value,
            style: StyleText.bold16().copyWith(
              color: context.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
