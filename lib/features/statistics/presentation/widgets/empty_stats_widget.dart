import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ramadan_app/core/constants/app_strings.dart';
import 'package:ramadan_app/core/constants/app_text_style.dart';
import 'package:ramadan_app/core/extensions/context_extensions.dart';

/// Widget shown when there are no statistics yet
class EmptyStatsWidget extends StatelessWidget {
  const EmptyStatsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bar_chart_outlined,
              size: 100.sp,
              color: context.primaryColor.withAlpha(100),
            ),
            SizedBox(height: 24.h),
            Text(
              AppStrings.noStatsYet,
              style: StyleText.bold20().copyWith(
                color: context.onPrimaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12.h),
            Text(
              AppStrings.startTracking,
              style: StyleText.regular16().copyWith(
                color: context.onPrimaryColor.withAlpha(150),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
