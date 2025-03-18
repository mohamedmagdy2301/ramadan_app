import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ramadan_app/core/utils/helper/home_widget_helper.dart';
import 'package:ramadan_app/features/home/domain/prayer_times_entity.dart';
import 'package:ramadan_app/features/home/presentation/view_model/next_prayer/next_prayer_state.dart';
import '../../../../../core/utils/functions/get_current_prayer_arbic.dart';
import '../../../../../core/utils/functions/get_status_prayer_time.dart';

class NextPrayerCubit extends Cubit<NextPrayerState> {
  late Timer timer;
  final List<PrayerTimesEntity> prayerTimes;

  NextPrayerCubit({required this.prayerTimes})
    : super(NextPrayerState(remainingTime: '', nextPrayerName: '')) {
    _startTimer();
    _updatePrayerTime();
  }

  void _startTimer() {
    timer = Timer.periodic(
      const Duration(seconds: 30),
      (Timer t) => _updatePrayerTime(),
    );
  }

  void _updatePrayerTime() {
    final remainingTime = findPrayerTimes();
    final nextPrayerName = getCurrentPrayerByArabic()[0];

    emit(
      NextPrayerState(
        remainingTime: remainingTime,
        nextPrayerName: nextPrayerName,
      ),
    );

    HomeWidgetHelper.updateNextPrayerWidget(nextPrayerName, remainingTime);
  }

  @override
  Future<void> close() {
    timer.cancel();
    return super.close();
  }
}
