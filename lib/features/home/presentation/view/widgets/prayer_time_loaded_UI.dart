import 'package:flutter/material.dart';
import 'package:ramadan_app/core/extensions/widget_extensions.dart';
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
      appBar: AppBarHome(prayerTimes: prayerTimes, locationName: locationName),
      body: BodyHomeScreen(
        prayerTimes: prayerTimes,
      ).paddingSymmetric(horizontal: 15, vertical: 10),
    );
  }
}
