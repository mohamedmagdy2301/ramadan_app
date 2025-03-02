import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ramadan_app/features/home/presentation/view/widgets/next_prayer_card.dart';
import 'package:ramadan_app/features/home/presentation/view/widgets/prayer_times_card.dart';
import 'package:ramadan_app/features/home/presentation/view/widgets/today_doaa_card.dart';

import '../../../domain/prayer_times_entity.dart';

class BodyHomeScreen extends StatelessWidget {
  const BodyHomeScreen({super.key, required this.prayerTimes});
  final List<PrayerTimesEntity> prayerTimes;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        spacing: 15.h,
        children: [
          PrayerTimesCard(prayerTimes: prayerTimes),
          const TodayDoaaCard(),
        ],
      ),
    );
  }
}
