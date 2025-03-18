import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ramadan_app/features/home/presentation/view_model/next_prayer/next_prayer_cubit.dart';
import 'package:ramadan_app/features/home/presentation/view_model/next_prayer/next_prayer_state.dart';
import 'package:ramadan_app/features/home/domain/prayer_times_entity.dart';

class NextPrayerHomeWidget extends StatefulWidget {
  final List<PrayerTimesEntity> prayerTimes;
  final String locationName;

  const NextPrayerHomeWidget({
    super.key,
    required this.prayerTimes,
    required this.locationName,
  });

  @override
  _NextPrayerHomeWidgetState createState() => _NextPrayerHomeWidgetState();
}

class _NextPrayerHomeWidgetState extends State<NextPrayerHomeWidget> {
  String appGroupId = "group.timePrayer";
  String dataKey = "next_prayer_time";

  void updateWidget(String nextPrayerName, String remainingTime) async {
    await HomeWidget.setAppGroupId(appGroupId);
    await HomeWidget.saveWidgetData(
      dataKey,
      "صلاة $nextPrayerName بعد $remainingTime ساعة",
    );
    await HomeWidget.updateWidget(
      androidName: "NextPrayerWidget",
      iOSName: "NextPrayerWidget",
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NextPrayerCubit(prayerTimes: widget.prayerTimes),
      child: BlocBuilder<NextPrayerCubit, NextPrayerState>(
        builder: (context, state) {
          updateWidget(state.nextPrayerName, state.remainingTime);
          return Container(); // This widget doesn't need to display anything in the Flutter app.
        },
      ),
    );
  }
}
