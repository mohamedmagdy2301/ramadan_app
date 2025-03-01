import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ramadan_app/core/constants/app_colors.dart';
import 'package:ramadan_app/core/constants/app_text_style.dart';
import 'package:ramadan_app/core/extensions/context_extensions.dart';

import '../../../../../core/constants/app_strings.dart';

class BuildHeaderPrayerTime extends StatelessWidget {
  const BuildHeaderPrayerTime({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160.w,
      height: 40.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10.r),
          topRight: Radius.circular(10.r),
        ),
        color: context.primaryColor,
      ),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(Icons.watch_later_outlined, color: AppColors.white),
          Text(
            AppStrings.prayerTimes,
            style: StyleText.medium18().copyWith(color: AppColors.white),
          ),
        ],
      ),
    );
  }
}
