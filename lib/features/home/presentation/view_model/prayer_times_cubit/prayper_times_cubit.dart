import 'dart:async';

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
  }

  PrayerTimesRepository prayerTimesRepository = PrayerTimesRepository();
  List<PrayerTimesEntity> prayerTimes = [];
  Timer? _timer; // Timer variable

  Future<void> fetchPrayerTimes() async {
    emit(PrayerTimesLoading());
    try {
      // Check internet connectivity
      final isConnected = await _checkInternetConnection();
      if (!isConnected) {
        emit(PrayerTimesError("لا يوجد اتصال بالانترنت"));
      }

      // Get user location and fetch prayer times
      final position = await _determinePosition();
      final locationName = await _getLocationName(position);

      prayerTimes = await prayerTimesRepository.fetchPrayerTimes(
        location: position,
      );
      emit(PrayerTimesLoaded(prayerTimes, locationName));
    } catch (e) {
      emit(PrayerTimesError(e.toString()));
    }
  }

  Future<bool> _checkInternetConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  void _scheduleDailyFetch() {
    // Calculate the duration until the next midnight
    final now = DateTime.now();
    final nextMidnight = DateTime(now.year, now.month, now.day + 1);
    final durationUntilMidnight = nextMidnight.difference(now);

    // Schedule the timer
    _timer = Timer(durationUntilMidnight, () {
      fetchPrayerTimes(); // Fetch prayer times at midnight
      _scheduleDailyFetch(); // Reschedule for the next day
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel(); // Cancel the timer when closing
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

  Future<Position> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('خدمة تحديد الموقع غير مفعلة');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('الوصول للموقع مرفوض');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'الوصول للموقع مرفوض بشكل دائم، قم بتفعيله من إعدادات الجهاز',
      );
    }

    return await Geolocator.getCurrentPosition();
  }
}
