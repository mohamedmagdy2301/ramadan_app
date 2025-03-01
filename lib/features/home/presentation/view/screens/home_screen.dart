import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ramadan_app/core/constants/app_colors.dart';
import 'package:ramadan_app/core/constants/app_text_style.dart';
import 'package:ramadan_app/core/utils/widgets/custom_loading_widget.dart';

import '../../view_model/prayer_times_cubit/prayper_times_cubit.dart';
import '../widgets/prayer_time_loaded_UI.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  static const String routeName = '/home';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrayerTimesCubit, PrayerTimesState>(
      builder: (context, state) {
        if (state is PrayerTimesLoaded) {
          return PrayerTimeLoadedUI(
            prayerTimes: state.prayerTimes,
            locationName: state.locationName,
          );
        } else if (state is PrayerTimesError) {
          return Scaffold(
            body: Center(
              child: Text(
                state.message,
                textAlign: TextAlign.center,
                style: StyleText.bold18().copyWith(color: AppColors.grey),
              ),
            ),
          );
        } else {
          return Scaffold(body: Center(child: CustomLoadingWidget()));
        }
      },
    );
  }
}
