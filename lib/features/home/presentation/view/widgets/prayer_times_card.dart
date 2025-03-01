import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ramadan_app/core/extensions/context_extensions.dart';

import '../../../domain/prayer_times_entity.dart';
import 'build_header_prayer_time.dart';
import 'prayer_times_list.dart';

class PrayerTimesCard extends StatelessWidget {
  const PrayerTimesCard({super.key, required this.prayerTimes});
  final List<PrayerTimesEntity> prayerTimes;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 350.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color:
            !context.isDark
                ? Colors.grey.shade100
                : const Color.fromARGB(255, 31, 31, 31),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BuildHeaderPrayerTime(),
          PrayerTimesList(prayerTimes: prayerTimes),
        ],
      ),
    );
  }
}
