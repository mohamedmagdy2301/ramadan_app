import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ramadan_app/core/constants/app_colors.dart';
import 'package:ramadan_app/core/constants/app_strings.dart';
import 'package:ramadan_app/core/extensions/context_extensions.dart';
import 'package:ramadan_app/core/extensions/widget_extensions.dart';
import 'package:ramadan_app/features/home/presentation/view/widgets/prayer_time_row.dart';

import '../../../../../core/utils/functions/get_status_prayer_name.dart';
import '../../../data/models/prayer_time_model.dart';
import '../../../domain/prayer_times_entity.dart';

class PrayerTimesList extends StatefulWidget {
  const PrayerTimesList({super.key, required this.prayerTimes});
  final List<PrayerTimesEntity> prayerTimes;

  @override
  State<PrayerTimesList> createState() => _PrayerTimesListState();
}

class _PrayerTimesListState extends State<PrayerTimesList> {
  List<PrayerTimeModel> prayerModels = [];

  List nextPrayerTime = findPrayerNames()['nextPrayer']!;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _initializePrayerModels();
    _startTimer();
  }

  void _initializePrayerModels() {
    final times = widget.prayerTimes[0];
    prayerModels = [
      PrayerTimeModel(
        nameEn: "Fajr",
        nameAr: AppStrings.alFajr,
        time: times.fajrTime,
      ),
      PrayerTimeModel(
        nameEn: "Sunrise",
        nameAr: AppStrings.alShoroq,
        time: times.sunriseTime,
      ),
      PrayerTimeModel(
        nameEn: "Dhuhr",
        nameAr: AppStrings.alZaher,
        time: times.dhuhrTime,
      ),
      PrayerTimeModel(
        nameEn: "Asr",
        nameAr: AppStrings.alAsr,
        time: times.asrTime,
      ),
      PrayerTimeModel(
        nameEn: "Maghrib",
        nameAr: AppStrings.alMagreb,
        time: times.maghribTime,
      ),
      PrayerTimeModel(
        nameEn: "Isha",
        nameAr: AppStrings.alEsha,
        time: times.ishaTime,
      ),
    ];
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        nextPrayerTime = findPrayerNames()['nextPrayer']!;
      });
    });
  }

  Color _updatePrayerTimeColor(prayerName, isLightTheme) {
    for (var prayer in nextPrayerTime) {
      if (prayer == prayerName) {
        if (nextPrayerTime[0] == prayerName) {
          return context.primaryColor;
        }
        return context.onPrimaryColor;
      }
    }
    return AppColors.grey;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var model in prayerModels)
          Column(
            children: [
              PrayerTimeRow(
                title: model.nameAr,
                time: model.time,
                colorText: _updatePrayerTimeColor(
                  model.nameEn,
                  !context.isDark,
                ),
              ),
              const Divider(thickness: .4, height: 0),
            ],
          ),
      ],
    ).paddingSymmetric(horizontal: 30).expand();

    //  ListView.builder(
    //   itemCount: prayerModels.length,
    //   shrinkWrap: true,
    //   physics: const NeverScrollableScrollPhysics(),
    //   itemBuilder: (context, index) {
    //     final model = prayerModels[index];
    //     return Column(
    //       children: [
    //         PrayerTimeRow(
    //           title: model.nameAr,
    //           time: model.time,
    //           colorText: _updatePrayerTimeColor(model.nameEn, !context.isDark),
    //         ),
    //         const Divider(thickness: .3, height: 0),
    //       ],
    //     );
    //   },
    // )
  }
}
