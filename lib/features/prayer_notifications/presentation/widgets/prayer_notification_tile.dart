import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ramadan_app/core/extensions/context_extensions.dart';

import '../../../../core/constants/app_text_style.dart';
import '../../domain/entities/prayer_notification_settings.dart';

/// A tile widget for toggling prayer notifications
class PrayerNotificationTile extends StatelessWidget {
  const PrayerNotificationTile({
    super.key,
    required this.prayerType,
    required this.isEnabled,
    required this.onToggle,
  });

  final PrayerType prayerType;
  final bool isEnabled;
  final ValueChanged<bool> onToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65.h,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: context.backgroundColor,
        border: Border(
          bottom: BorderSide(
            color: context.onPrimaryColor.withAlpha(30),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          // Prayer icon
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: isEnabled
                  ? context.primaryColor.withAlpha(25)
                  : context.onPrimaryColor.withAlpha(15),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              _getPrayerIcon(prayerType),
              color: isEnabled
                  ? context.primaryColor
                  : context.onPrimaryColor.withAlpha(100),
              size: 22.sp,
            ),
          ),
          SizedBox(width: 14.w),
          // Prayer name
          Expanded(
            child: Text(
              prayerType.arabicName,
              style: StyleText.regular18().copyWith(
                color: isEnabled
                    ? context.onPrimaryColor
                    : context.onPrimaryColor.withAlpha(120),
                fontWeight: isEnabled ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ),
          // Toggle switch
          Switch.adaptive(
            value: isEnabled,
            onChanged: onToggle,
            activeColor: context.primaryColor,
          ),
        ],
      ),
    );
  }

  IconData _getPrayerIcon(PrayerType prayer) {
    switch (prayer) {
      case PrayerType.fajr:
        return Icons.wb_twilight_rounded;
      case PrayerType.dhuhr:
        return Icons.wb_sunny_rounded;
      case PrayerType.asr:
        return Icons.wb_sunny_outlined;
      case PrayerType.maghrib:
        return Icons.nights_stay_outlined;
      case PrayerType.isha:
        return Icons.nights_stay_rounded;
    }
  }
}
