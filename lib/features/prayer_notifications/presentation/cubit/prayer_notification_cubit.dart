import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../home/domain/prayer_times_entity.dart';
import '../../data/datasources/prayer_notification_local_datasource.dart';
import '../../domain/entities/prayer_notification_settings.dart';
import '../../services/prayer_notification_service.dart';
import 'prayer_notification_state.dart';

/// Cubit for managing prayer notification settings and scheduling
class PrayerNotificationCubit extends Cubit<PrayerNotificationState> {
  final PrayerNotificationLocalDatasource localDatasource;
  final IPrayerNotificationService? _notificationService;

  PrayerNotificationCubit({
    required this.localDatasource,
    IPrayerNotificationService? notificationService,
  })  : _notificationService = notificationService,
        super(const PrayerNotificationInitial());

  /// Load saved settings from local storage
  Future<void> loadSettings() async {
    emit(const PrayerNotificationLoading());

    try {
      final settings = await localDatasource.getSettings();
      final isScheduled =
          await localDatasource.areNotificationsScheduledForToday();

      emit(PrayerNotificationLoaded(
        settings: settings,
        notificationsScheduled: isScheduled,
      ));
    } catch (e) {
      emit(PrayerNotificationError(
        message: 'فشل في تحميل إعدادات الإشعارات: $e',
      ));
    }
  }

  /// Toggle notification for a specific prayer
  Future<void> togglePrayerNotification(
      PrayerType prayer, bool enabled) async {
    final currentState = state;
    if (currentState is! PrayerNotificationLoaded) return;

    try {
      // Update local storage
      await localDatasource.togglePrayerNotification(prayer, enabled);

      // Update state
      final newSettings = currentState.settings.togglePrayer(prayer, enabled);
      emit(currentState.copyWith(
        settings: newSettings,
        notificationsScheduled: false, // Need to reschedule
      ));

      // Cancel this specific prayer notification if disabled
      if (!enabled) {
        await _cancelPrayerNotification(prayer);
      }
    } catch (e) {
      emit(PrayerNotificationError(
        message: 'فشل في تحديث إعداد ${prayer.arabicName}: $e',
        settings: currentState.settings,
      ));
    }
  }

  /// Set pre-alert minutes (0, 5, 10, or 15)
  Future<void> setPreAlertMinutes(int minutes) async {
    final currentState = state;
    if (currentState is! PrayerNotificationLoaded) return;

    try {
      await localDatasource.setPreAlertMinutes(minutes);

      final newSettings = currentState.settings.copyWith(
        preAlertMinutes: minutes,
      );

      emit(currentState.copyWith(
        settings: newSettings,
        notificationsScheduled: false, // Need to reschedule
      ));
    } catch (e) {
      emit(PrayerNotificationError(
        message: 'فشل في تحديث وقت التنبيه المسبق: $e',
        settings: currentState.settings,
      ));
    }
  }

  /// Toggle sound
  Future<void> toggleSound(bool enabled) async {
    final currentState = state;
    if (currentState is! PrayerNotificationLoaded) return;

    try {
      await localDatasource.toggleSound(enabled);

      final newSettings = currentState.settings.copyWith(
        soundEnabled: enabled,
      );

      emit(currentState.copyWith(settings: newSettings));
    } catch (e) {
      emit(PrayerNotificationError(
        message: 'فشل في تحديث إعداد الصوت: $e',
        settings: currentState.settings,
      ));
    }
  }

  /// Set selected adhan sound
  Future<void> setSelectedAdhan(String? adhan) async {
    final currentState = state;
    if (currentState is! PrayerNotificationLoaded) return;

    try {
      await localDatasource.setSelectedAdhan(adhan);

      final newSettings = currentState.settings.copyWith(
        selectedAdhan: adhan,
      );

      emit(currentState.copyWith(settings: newSettings));
    } catch (e) {
      emit(PrayerNotificationError(
        message: 'فشل في تحديث صوت الأذان: $e',
        settings: currentState.settings,
      ));
    }
  }

  /// Schedule all prayer notifications based on current settings
  Future<void> scheduleNotifications(PrayerTimesEntity prayerTimes) async {
    final currentState = state;
    if (currentState is! PrayerNotificationLoaded) return;

    emit(PrayerNotificationScheduling(settings: currentState.settings));

    try {
      await _scheduleAllPrayerNotifications(
        prayerTimes: prayerTimes,
        settings: currentState.settings,
      );

      await localDatasource.markNotificationsAsScheduled();

      emit(PrayerNotificationLoaded(
        settings: currentState.settings,
        notificationsScheduled: true,
        message: 'تم جدولة إشعارات الصلاة بنجاح',
      ));
    } catch (e) {
      emit(PrayerNotificationError(
        message: 'فشل في جدولة الإشعارات: $e',
        settings: currentState.settings,
      ));
    }
  }

  /// Cancel all prayer notifications
  Future<void> cancelAllNotifications() async {
    final currentState = state;
    if (currentState is! PrayerNotificationLoaded) return;

    try {
      await _cancelAllPrayerNotifications();
      await localDatasource.clearScheduledStatus();

      emit(currentState.copyWith(
        notificationsScheduled: false,
        message: 'تم إلغاء جميع إشعارات الصلاة',
      ));
    } catch (e) {
      emit(PrayerNotificationError(
        message: 'فشل في إلغاء الإشعارات: $e',
        settings: currentState.settings,
      ));
    }
  }

  /// Enable all prayer notifications
  Future<void> enableAllPrayers() async {
    final currentState = state;
    if (currentState is! PrayerNotificationLoaded) return;

    try {
      for (final prayer in PrayerType.values) {
        await localDatasource.togglePrayerNotification(prayer, true);
      }

      final newSettings = PrayerNotificationSettings(
        fajrEnabled: true,
        dhuhrEnabled: true,
        asrEnabled: true,
        maghribEnabled: true,
        ishaEnabled: true,
        preAlertMinutes: currentState.settings.preAlertMinutes,
        soundEnabled: currentState.settings.soundEnabled,
        selectedAdhan: currentState.settings.selectedAdhan,
      );

      emit(currentState.copyWith(
        settings: newSettings,
        notificationsScheduled: false,
      ));
    } catch (e) {
      emit(PrayerNotificationError(
        message: 'فشل في تفعيل جميع الإشعارات: $e',
        settings: currentState.settings,
      ));
    }
  }

  /// Disable all prayer notifications
  Future<void> disableAllPrayers() async {
    final currentState = state;
    if (currentState is! PrayerNotificationLoaded) return;

    try {
      for (final prayer in PrayerType.values) {
        await localDatasource.togglePrayerNotification(prayer, false);
      }

      await _cancelAllPrayerNotifications();
      await localDatasource.clearScheduledStatus();

      final newSettings = PrayerNotificationSettings(
        fajrEnabled: false,
        dhuhrEnabled: false,
        asrEnabled: false,
        maghribEnabled: false,
        ishaEnabled: false,
        preAlertMinutes: currentState.settings.preAlertMinutes,
        soundEnabled: currentState.settings.soundEnabled,
        selectedAdhan: currentState.settings.selectedAdhan,
      );

      emit(currentState.copyWith(
        settings: newSettings,
        notificationsScheduled: false,
      ));
    } catch (e) {
      emit(PrayerNotificationError(
        message: 'فشل في تعطيل جميع الإشعارات: $e',
        settings: currentState.settings,
      ));
    }
  }

  // Private helper methods that use either injected service or singleton instance

  IPrayerNotificationService get _service =>
      _notificationService ?? PrayerNotificationService.instance;

  Future<void> _cancelPrayerNotification(PrayerType prayer) async {
    await _service.cancelPrayerNotification(prayer);
  }

  Future<void> _cancelAllPrayerNotifications() async {
    await _service.cancelAllPrayerNotifications();
  }

  Future<void> _scheduleAllPrayerNotifications({
    required PrayerTimesEntity prayerTimes,
    required PrayerNotificationSettings settings,
  }) async {
    await _service.scheduleAllPrayerNotifications(
      prayerTimes: prayerTimes,
      settings: settings,
    );
  }
}
