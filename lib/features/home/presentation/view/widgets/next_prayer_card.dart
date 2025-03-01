import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ramadan_app/core/constants/app_colors.dart';
import 'package:ramadan_app/core/constants/app_text_style.dart';
import 'package:ramadan_app/core/extensions/context_extensions.dart';
import 'package:ramadan_app/core/extensions/int_extensions.dart';

import '../../../domain/prayer_times_entity.dart';
import '../../view_model/next_prayer/next_prayer_cubit.dart';
import '../../view_model/next_prayer/next_prayer_state.dart';

class NextPrayerCard extends StatelessWidget {
  const NextPrayerCard({
    super.key,
    required this.prayerTimes,
    required this.locationName,
  });
  final List<PrayerTimesEntity> prayerTimes;
  final String locationName;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NextPrayerCubit(prayerTimes: prayerTimes),
      child: BlocBuilder<NextPrayerCubit, NextPrayerState>(
        builder: (context, state) {
          return Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  context.primaryColor.withAlpha(context.isDark ? 150 : 200),
                  context.primaryColor.withAlpha(context.isDark ? 200 : 225),
                  context.primaryColor.withAlpha(context.isDark ? 250 : 250),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.1, 0.7, 1],
              ),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 30.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      color: Colors.white,
                      size: 20.sp,
                    ),
                    Text(
                      locationName,
                      style: StyleText.medium18().copyWith(
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'متبقي علي',
                          style: StyleText.medium16().copyWith(
                            color: AppColors.white,
                          ),
                        ),
                        Text(
                          'صلاة ${state.nextPrayerName}',
                          style: StyleText.black26().copyWith(
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          state.remainingTime,
                          style: StyleText.black26().copyWith(
                            color: AppColors.white,
                          ),
                        ),
                        5.wSpace,
                        Text(
                          'ساعة',
                          style: StyleText.regular16().copyWith(
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
