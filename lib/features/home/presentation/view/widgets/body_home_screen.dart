import 'package:flutter/material.dart';
import 'package:ramadan_app/core/extensions/int_extensions.dart';
import 'package:ramadan_app/features/home/presentation/view/widgets/next_prayer_card.dart';
import 'package:ramadan_app/features/home/presentation/view/widgets/prayer_times_card.dart';
import 'package:ramadan_app/features/home/presentation/view/widgets/today_doaa_card.dart';

import '../../../domain/prayer_times_entity.dart';

class BodyHomeScreen extends StatelessWidget {
  const BodyHomeScreen({
    super.key,
    required this.prayerTimes,
    required this.locationName,
  });
  final List<PrayerTimesEntity> prayerTimes;
  final String locationName;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          NextPrayerCard(prayerTimes: prayerTimes, locationName: locationName),
          15.hSpace,
          PrayerTimesCard(prayerTimes: prayerTimes),
          15.hSpace,
          const TodayDoaaCard(),
        ],
      ),
    );
  }
}
