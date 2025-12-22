import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ramadan_app/core/constants/app_strings.dart';
import 'package:ramadan_app/core/constants/app_text_style.dart';
import 'package:ramadan_app/core/extensions/context_extensions.dart';

/// A card widget displaying streak information
class StreakCard extends StatelessWidget {
  final int currentStreak;
  final int longestStreak;

  const StreakCard({
    super.key,
    required this.currentStreak,
    required this.longestStreak,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            context.primaryColor.withAlpha(40),
            context.primaryColor.withAlpha(20),
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: context.primaryColor.withAlpha(50),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _StreakItem(
              icon: Icons.local_fire_department,
              value: currentStreak,
              label: AppStrings.currentStreak,
              isHighlighted: true,
            ),
          ),
          Container(
            width: 1,
            height: 60.h,
            color: context.primaryColor.withAlpha(50),
          ),
          Expanded(
            child: _StreakItem(
              icon: Icons.emoji_events,
              value: longestStreak,
              label: AppStrings.longestStreak,
              isHighlighted: false,
            ),
          ),
        ],
      ),
    );
  }
}

class _StreakItem extends StatelessWidget {
  final IconData icon;
  final int value;
  final String label;
  final bool isHighlighted;

  const _StreakItem({
    required this.icon,
    required this.value,
    required this.label,
    required this.isHighlighted,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isHighlighted
                  ? Colors.orange
                  : context.primaryColor,
              size: 28.sp,
            ),
            SizedBox(width: 8.w),
            Text(
              '$value',
              style: StyleText.bold28().copyWith(
                color: context.onPrimaryColor,
              ),
            ),
            SizedBox(width: 4.w),
            Text(
              value == 1 ? AppStrings.day : AppStrings.days,
              style: StyleText.regular14().copyWith(
                color: context.onPrimaryColor.withAlpha(150),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Text(
          label,
          style: StyleText.regular14().copyWith(
            color: context.onPrimaryColor.withAlpha(150),
          ),
        ),
      ],
    );
  }
}
