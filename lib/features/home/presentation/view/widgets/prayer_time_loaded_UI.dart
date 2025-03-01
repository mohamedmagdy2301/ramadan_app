import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ramadan_app/features/home/presentation/view/widgets/appbar_home_screen.dart';
import 'package:ramadan_app/features/home/presentation/view/widgets/body_home_screen.dart';

import '../../../domain/prayer_times_entity.dart';

class PrayerTimeLoadedUI extends StatelessWidget {
  const PrayerTimeLoadedUI({
    super.key,
    required this.prayerTimes,
    required this.locationName,
  });
  final List<PrayerTimesEntity> prayerTimes;
  final String locationName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarHome(prayerTimes: prayerTimes),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: BodyHomeScreen(
          prayerTimes: prayerTimes,
          locationName: locationName,
        ),
      ),
    );
  }
}
