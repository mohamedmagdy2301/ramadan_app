import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../../../data/repo/prayer_time_repo_impl.dart';
import '../../../domain/prayer_times_entity.dart';

part 'prayper_times_state.dart';
//   https://api.aladhan.com/v1/timings?latitude=30.5632921&longitude=30.9970544&method=5

class PrayerTimesCubit extends Cubit<PrayerTimesState> {
  PrayerTimesCubit() : super(PrayerTimesInitial()) {
    _scheduleDailyFetch();
    startListeningToConnectivity();
  }

  final PrayerTimesRepository prayerTimesRepository = PrayerTimesRepository();
  List<PrayerTimesEntity> prayerTimes = [];
  Timer? _timer;
  StreamSubscription<List<ConnectivityResult>>? connectivitySubscription;

  Future<void> fetchPrayerTimes() async {
    emit(PrayerTimesLoading());

    try {
      if (!await isInternetAvailable()) {
        emit(PrayerTimesError("لا يوجد اتصال بالإنترنت"));
        return;
      }

      final position = await _determinePosition();
      if (position == null) {
        emit(PrayerTimesError("تعذر الحصول على الموقع"));
        return;
      }

      final locationName = await _getLocationName(position);
      prayerTimes = await prayerTimesRepository.fetchPrayerTimes(
        location: position,
      );

      emit(PrayerTimesLoaded(prayerTimes, locationName));
    } catch (e) {
      emit(PrayerTimesError("حدث خطأ أثناء تحميل أوقات الصلاة"));
    }
  }

  Future<bool> isInternetAvailable() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  void startListeningToConnectivity() {
    connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      List<ConnectivityResult> result,
    ) {
      print("Connectivity changed: $result");
    });
  }

  void _scheduleDailyFetch() {
    final now = DateTime.now();
    final nextMidnight = DateTime(now.year, now.month, now.day + 1);
    final durationUntilMidnight = nextMidnight.difference(now);

    _timer = Timer(durationUntilMidnight, () async {
      try {
        await fetchPrayerTimes();
      } catch (e) {
        emit(PrayerTimesError(e.toString()));
      }
      _scheduleDailyFetch();
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    connectivitySubscription?.cancel();
    return super.close();
  }

  Future<String> _getLocationName(Position position) async {
    try {
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        return '${place.locality}, ${place.country}';
      }
      return 'غير معروف';
    } catch (e) {
      return 'غير معروف';
    }
  }

  Future<Position?> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      emit(PrayerTimesError('خدمة تحديد الموقع غير مفعلة'));
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        emit(PrayerTimesError('الوصول للموقع مرفوض'));
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      emit(
        PrayerTimesError(
          'الوصول للموقع مرفوض بشكل دائم، قم بتفعيله من إعدادات الجهاز',
        ),
      );
      return null;
    }

    return await Geolocator.getCurrentPosition();
  }
}
