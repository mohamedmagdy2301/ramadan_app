import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ramadan_app/core/constants/app_text_style.dart';
import 'package:ramadan_app/core/extensions/context_extensions.dart';
import 'package:ramadan_app/core/extensions/int_extensions.dart';
import 'package:ramadan_app/features/home/presentation/view/widgets/next_prayer_card.dart';

import '../../../domain/prayer_times_entity.dart';

class AppBarHome extends StatelessWidget implements PreferredSizeWidget {
  const AppBarHome({
    super.key,
    required this.prayerTimes,
    required this.locationName,
  });
  final List<PrayerTimesEntity> prayerTimes;
  final String locationName;

  @override
  Widget build(BuildContext context) {
    PrayerTimesEntity time = prayerTimes[0];
    return AppBar(
      elevation: 0,
      toolbarHeight: 220.h,
      centerTitle: true,
      forceMaterialTransparency: true,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          10.hSpace,
          Text(
            '${time.dayWeek} ${time.dayMonth},${time.month}',
            style: StyleText.bold22().copyWith(color: context.onPrimaryColor),
          ),
          3.hSpace,
          Text(
            ' ${time.dayWeekHijri}  ${time.monthHijri}  ${time.yearHijri}',
            style: StyleText.semiBold18().copyWith(color: context.primaryColor),
          ),
          15.hSpace,

          NextPrayerCard(prayerTimes: prayerTimes, locationName: locationName),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(220.h);
}
