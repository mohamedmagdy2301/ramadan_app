import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ramadan_app/core/constants/app_strings.dart';
import 'package:ramadan_app/core/constants/app_text_style.dart';
import 'package:ramadan_app/core/extensions/context_extensions.dart';
import 'package:ramadan_app/features/hijri_calendar/data/hijri_date_converter.dart';
import 'package:ramadan_app/features/hijri_calendar/data/islamic_events.dart';

class HijriDateCard extends StatelessWidget {
  const HijriDateCard({super.key});

  @override
  Widget build(BuildContext context) {
    final today = HijriDateConverter.today();
    final weekday = HijriDateConverter.getWeekdayName(today);
    final upcomingEvents = IslamicEvents.getUpcomingEvents(limit: 3);
    final todayEvents = IslamicEvents.getTodayEvents();

    return Semantics(
      label: '${AppStrings.hijriDate}: ${today.formattedWithLabel}',
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              context.primaryColor.withAlpha(25),
              context.primaryColor.withAlpha(10),
            ],
          ),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: context.primaryColor.withAlpha(40),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: context.primaryColor.withAlpha(30),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    Icons.calendar_today,
                    color: context.primaryColor,
                    size: 24.sp,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.hijriDate,
                        style: StyleText.regular14().copyWith(
                          color: context.onPrimaryColor.withAlpha(150),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        weekday,
                        style: StyleText.bold16().copyWith(
                          color: context.onPrimaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            // Main Date Display
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
              decoration: BoxDecoration(
                color: context.primaryColor.withAlpha(15),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                children: [
                  Text(
                    '${today.day}',
                    style: StyleText.bold(48).copyWith(
                      color: context.primaryColor,
                      height: 1,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    today.monthName,
                    style: StyleText.bold20().copyWith(
                      color: context.onPrimaryColor,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    '${today.year} هـ',
                    style: StyleText.regular16().copyWith(
                      color: context.onPrimaryColor.withAlpha(180),
                    ),
                  ),
                ],
              ),
            ),
            // Today's Events (if any)
            if (todayEvents.isNotEmpty) ...[
              SizedBox(height: 16.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.green.withAlpha(20),
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: Colors.green.withAlpha(50)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.celebration,
                      color: Colors.green,
                      size: 20.sp,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        todayEvents.first.name,
                        style: StyleText.bold14().copyWith(
                          color: Colors.green.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            // Upcoming Events
            if (upcomingEvents.isNotEmpty) ...[
              SizedBox(height: 16.h),
              Text(
                AppStrings.upcomingEvents,
                style: StyleText.bold14().copyWith(
                  color: context.onPrimaryColor,
                ),
              ),
              SizedBox(height: 8.h),
              ...upcomingEvents.map(
                (event) => _buildEventTile(context, event),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEventTile(BuildContext context, IslamicEvent event) {
    final daysUntil = event.daysUntil();
    final isToday = daysUntil == 0;

    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        children: [
          Container(
            width: 6.w,
            height: 6.w,
            decoration: BoxDecoration(
              color: isToday ? Colors.green : context.primaryColor,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              event.name,
              style: StyleText.regular14().copyWith(
                color: context.onPrimaryColor,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: isToday
                  ? Colors.green.withAlpha(30)
                  : context.primaryColor.withAlpha(20),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Text(
              isToday
                  ? AppStrings.today
                  : '$daysUntil ${AppStrings.daysRemaining}',
              style: StyleText.regular12().copyWith(
                color: isToday ? Colors.green : context.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
