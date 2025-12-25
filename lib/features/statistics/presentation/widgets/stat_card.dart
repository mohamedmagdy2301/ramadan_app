import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ramadan_app/core/extensions/context_extensions.dart';

/// A card widget displaying a single statistic
class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color? iconColor;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = iconColor ?? context.primaryColor;

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: context.isDark
            ? const Color.fromARGB(255, 31, 31, 31)
            : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: color.withAlpha(30),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(6.w),
            decoration: BoxDecoration(
              color: color.withAlpha(30),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20.sp,
            ),
          ),
          SizedBox(height: 8.h),
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                  color: context.onPrimaryColor,
                ),
              ),
            ),
          ),
          SizedBox(height: 2.h),
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontFamily: 'Cairo',
                  color: context.onPrimaryColor.withAlpha(150),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
