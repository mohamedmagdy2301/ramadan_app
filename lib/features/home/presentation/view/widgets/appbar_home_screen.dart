import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ramadan_app/core/constants/app_text_style.dart';
import 'package:ramadan_app/core/extensions/context_extensions.dart';
import 'package:ramadan_app/core/extensions/int_extensions.dart';

import '../../../domain/prayer_times_entity.dart';

class AppBarHome extends StatelessWidget implements PreferredSizeWidget {
  const AppBarHome({super.key, required this.prayerTimes});
  final List<PrayerTimesEntity> prayerTimes;

  @override
  Widget build(BuildContext context) {
    PrayerTimesEntity time = prayerTimes[0];
    return AppBar(
      elevation: 0,
      toolbarHeight: 85.h,
      forceMaterialTransparency: true,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          10.hSpace,
          Text(
            '${time.dayWeek} ${time.dayMonth},${time.month}',
            style: StyleText.bold24().copyWith(color: context.onPrimaryColor),
          ),
          3.hSpace,
          Text(
            ' ${time.dayWeekHijri}  ${time.monthHijri}  ${time.yearHijri}',
            style: StyleText.semiBold16().copyWith(color: context.primaryColor),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(85.h);
}
