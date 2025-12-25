import 'dart:async';
import 'package:ramadan_app/features/home/domain/prayer_times_entity.dart';
import 'package:ramadan_app/features/home/presentation/view_model/prayer_times_cubit/prayer_times_cubit.dart';
import 'package:ramadan_app/features/prayer_notifications/domain/entities/prayer_notification_settings.dart';
import 'package:ramadan_app/features/prayer_notifications/services/prayer_notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// SmartNotificationManager handles automatic scheduling of prayer notifications
/// It listens to prayer time changes and automatically updates notifications
class SmartNotificationManager {
  static SmartNotificationManager? _instance;
  static SmartNotificationManager get instance {
    _instance ??= SmartNotificationManager._internal();
    return _instance!;
  }

  SmartNotificationManager._internal();

  StreamSubscription? _prayerTimesSubscription;
  PrayerTimesEntity? _lastPrayerTimes;
  bool _isInitialized = false;

  // Storage keys
  static const String _autoScheduleEnabledKey = 'smart_notification_auto_schedule_enabled';
  static const String _lastScheduledDateKey = 'smart_notification_last_scheduled_date';

  SharedPreferences? _prefs;

  Future<SharedPreferences> get _sharedPrefs async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  /// Initialize the smart notification manager
  Future<void> initialize() async {
    if (_isInitialized) return;
    await PrayerNotificationService.initializeStatic();
    _prefs = await SharedPreferences.getInstance();
    _isInitialized = true;
  }

  /// Check if auto-scheduling is enabled
  Future<bool> isAutoScheduleEnabled() async {
    final prefs = await _sharedPrefs;
    return prefs.getBool(_autoScheduleEnabledKey) ?? true;
  }

  /// Enable or disable auto-scheduling
  Future<void> setAutoScheduleEnabled(bool enabled) async {
    final prefs = await _sharedPrefs;
    await prefs.setBool(_autoScheduleEnabledKey, enabled);
  }

  /// Start listening to prayer time changes from a cubit
  void listenToPrayerTimeChanges(PrayerTimesCubit cubit) {
    _prayerTimesSubscription?.cancel();
    _prayerTimesSubscription = cubit.stream.listen((state) async {
      if (state is PrayerTimesLoaded && state.prayerTimes.isNotEmpty) {
        await _onPrayerTimesUpdated(state.prayerTimes.first);
      }
    });
  }

  /// Stop listening to prayer time changes
  void stopListening() {
    _prayerTimesSubscription?.cancel();
    _prayerTimesSubscription = null;
  }

  /// Called when prayer times are updated
  Future<void> _onPrayerTimesUpdated(PrayerTimesEntity prayerTimes) async {
    // Check if auto-scheduling is enabled
    if (!await isAutoScheduleEnabled()) return;

    // Check if we already scheduled for today
    final today = DateTime.now().toString().split(' ').first;
    final prefs = await _sharedPrefs;
    final lastScheduledDate = prefs.getString(_lastScheduledDateKey);

    // If times haven't changed and we already scheduled today, skip
    if (lastScheduledDate == today && _isSamePrayerTimes(prayerTimes)) {
      return;
    }

    // Schedule notifications
    await scheduleNotificationsForPrayerTimes(prayerTimes);

    // Update last scheduled date
    await prefs.setString(_lastScheduledDateKey, today);
    _lastPrayerTimes = prayerTimes;
  }

  /// Check if prayer times are the same as last scheduled
  bool _isSamePrayerTimes(PrayerTimesEntity newTimes) {
    if (_lastPrayerTimes == null) return false;
    return _lastPrayerTimes!.fajrTime == newTimes.fajrTime &&
           _lastPrayerTimes!.dhuhrTime == newTimes.dhuhrTime &&
           _lastPrayerTimes!.asrTime == newTimes.asrTime &&
           _lastPrayerTimes!.maghribTime == newTimes.maghribTime &&
           _lastPrayerTimes!.ishaTime == newTimes.ishaTime;
  }

  /// Schedule notifications for given prayer times
  Future<void> scheduleNotificationsForPrayerTimes(PrayerTimesEntity prayerTimes) async {
    await initialize();

    // Get notification settings from SharedPreferences
    final prefs = await _sharedPrefs;
    final settings = PrayerNotificationSettings(
      fajrEnabled: prefs.getBool('prayer_notification_fajr') ?? true,
      dhuhrEnabled: prefs.getBool('prayer_notification_dhuhr') ?? true,
      asrEnabled: prefs.getBool('prayer_notification_asr') ?? true,
      maghribEnabled: prefs.getBool('prayer_notification_maghrib') ?? true,
      ishaEnabled: prefs.getBool('prayer_notification_isha') ?? true,
      preAlertMinutes: prefs.getInt('prayer_notification_pre_alert') ?? 0,
      soundEnabled: prefs.getBool('prayer_notification_sound') ?? true,
      selectedAdhan: prefs.getString('prayer_notification_adhan'),
    );

    // Check if any prayer notification is enabled
    if (!_hasAnyPrayerEnabled(settings)) return;

    // Schedule all enabled prayer notifications
    await PrayerNotificationService.scheduleAllPrayerNotificationsStatic(
      prayerTimes: prayerTimes,
      settings: settings,
    );

    // Mark as scheduled
    final today = DateTime.now();
    final todayString = '${today.year}-${today.month}-${today.day}';
    await prefs.setString('prayer_notifications_last_date', todayString);
    await prefs.setBool('prayer_notifications_scheduled', true);
  }

  /// Check if any prayer notification is enabled
  bool _hasAnyPrayerEnabled(PrayerNotificationSettings settings) {
    return settings.fajrEnabled ||
           settings.dhuhrEnabled ||
           settings.asrEnabled ||
           settings.maghribEnabled ||
           settings.ishaEnabled;
  }

  /// Force reschedule all notifications (called when settings change)
  Future<void> forceReschedule(PrayerTimesEntity prayerTimes) async {
    // Clear last scheduled date to force rescheduling
    final prefs = await _sharedPrefs;
    await prefs.setString(_lastScheduledDateKey, '');
    _lastPrayerTimes = null;
    await scheduleNotificationsForPrayerTimes(prayerTimes);
  }

  /// Cancel all prayer notifications
  Future<void> cancelAllNotifications() async {
    await PrayerNotificationService.cancelAllPrayerNotificationsStatic();
  }

  /// Dispose resources
  void dispose() {
    _prayerTimesSubscription?.cancel();
    _prayerTimesSubscription = null;
  }
}
