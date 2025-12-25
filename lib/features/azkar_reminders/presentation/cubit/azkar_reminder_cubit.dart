import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ramadan_app/features/azkar_reminders/data/datasources/azkar_reminder_local_datasource.dart';
import 'package:ramadan_app/features/azkar_reminders/domain/entities/azkar_reminder_settings.dart';
import 'package:ramadan_app/features/azkar_reminders/services/azkar_reminder_service.dart';

import 'azkar_reminder_state.dart';

/// Cubit for managing azkar reminder settings
class AzkarReminderCubit extends Cubit<AzkarReminderState> {
  final AzkarReminderLocalDatasource _localDatasource;
  final AzkarReminderService _service;

  AzkarReminderCubit({
    AzkarReminderLocalDatasource? localDatasource,
    AzkarReminderService? service,
  })  : _localDatasource = localDatasource ?? AzkarReminderLocalDatasource(),
        _service = service ?? AzkarReminderService.instance,
        super(const AzkarReminderInitial());

  /// Load saved settings
  Future<void> loadSettings() async {
    emit(const AzkarReminderLoading());

    try {
      final settings = await _localDatasource.getSettings();
      emit(AzkarReminderLoaded(settings: settings));
    } catch (e) {
      emit(AzkarReminderError(
        message: 'فشل في تحميل إعدادات التذكيرات: $e',
      ));
    }
  }

  /// Toggle morning reminder
  Future<void> toggleMorningReminder(bool enabled) async {
    final currentState = state;
    if (currentState is! AzkarReminderLoaded) return;

    try {
      await _localDatasource.toggleMorningReminder(enabled);
      final newSettings = currentState.settings.copyWith(
        morningReminderEnabled: enabled,
      );
      emit(currentState.copyWith(settings: newSettings));
      await _rescheduleReminders(newSettings);
    } catch (e) {
      emit(AzkarReminderError(
        message: 'فشل في تحديث تذكير الصباح: $e',
        settings: currentState.settings,
      ));
    }
  }

  /// Set morning reminder time
  Future<void> setMorningReminderTime(TimeOfDay time) async {
    final currentState = state;
    if (currentState is! AzkarReminderLoaded) return;

    try {
      await _localDatasource.setMorningReminderTime(time);
      final newSettings = currentState.settings.copyWith(
        morningReminderTime: time,
      );
      emit(currentState.copyWith(settings: newSettings));
      if (newSettings.morningReminderEnabled) {
        await _rescheduleReminders(newSettings);
      }
    } catch (e) {
      emit(AzkarReminderError(
        message: 'فشل في تحديث وقت تذكير الصباح: $e',
        settings: currentState.settings,
      ));
    }
  }

  /// Toggle evening reminder
  Future<void> toggleEveningReminder(bool enabled) async {
    final currentState = state;
    if (currentState is! AzkarReminderLoaded) return;

    try {
      await _localDatasource.toggleEveningReminder(enabled);
      final newSettings = currentState.settings.copyWith(
        eveningReminderEnabled: enabled,
      );
      emit(currentState.copyWith(settings: newSettings));
      await _rescheduleReminders(newSettings);
    } catch (e) {
      emit(AzkarReminderError(
        message: 'فشل في تحديث تذكير المساء: $e',
        settings: currentState.settings,
      ));
    }
  }

  /// Set evening reminder time
  Future<void> setEveningReminderTime(TimeOfDay time) async {
    final currentState = state;
    if (currentState is! AzkarReminderLoaded) return;

    try {
      await _localDatasource.setEveningReminderTime(time);
      final newSettings = currentState.settings.copyWith(
        eveningReminderTime: time,
      );
      emit(currentState.copyWith(settings: newSettings));
      if (newSettings.eveningReminderEnabled) {
        await _rescheduleReminders(newSettings);
      }
    } catch (e) {
      emit(AzkarReminderError(
        message: 'فشل في تحديث وقت تذكير المساء: $e',
        settings: currentState.settings,
      ));
    }
  }

  /// Toggle sleep reminder
  Future<void> toggleSleepReminder(bool enabled) async {
    final currentState = state;
    if (currentState is! AzkarReminderLoaded) return;

    try {
      await _localDatasource.toggleSleepReminder(enabled);
      final newSettings = currentState.settings.copyWith(
        sleepReminderEnabled: enabled,
      );
      emit(currentState.copyWith(settings: newSettings));
      await _rescheduleReminders(newSettings);
    } catch (e) {
      emit(AzkarReminderError(
        message: 'فشل في تحديث تذكير النوم: $e',
        settings: currentState.settings,
      ));
    }
  }

  /// Set sleep reminder time
  Future<void> setSleepReminderTime(TimeOfDay time) async {
    final currentState = state;
    if (currentState is! AzkarReminderLoaded) return;

    try {
      await _localDatasource.setSleepReminderTime(time);
      final newSettings = currentState.settings.copyWith(
        sleepReminderTime: time,
      );
      emit(currentState.copyWith(settings: newSettings));
      if (newSettings.sleepReminderEnabled) {
        await _rescheduleReminders(newSettings);
      }
    } catch (e) {
      emit(AzkarReminderError(
        message: 'فشل في تحديث وقت تذكير النوم: $e',
        settings: currentState.settings,
      ));
    }
  }

  /// Toggle after prayer reminder
  Future<void> toggleAfterPrayerReminder(bool enabled) async {
    final currentState = state;
    if (currentState is! AzkarReminderLoaded) return;

    try {
      await _localDatasource.toggleAfterPrayerReminder(enabled);
      final newSettings = currentState.settings.copyWith(
        afterPrayerReminderEnabled: enabled,
      );
      emit(currentState.copyWith(settings: newSettings));
      // Note: After prayer reminders need prayer times to be scheduled
      // This is handled by SmartNotificationManager
    } catch (e) {
      emit(AzkarReminderError(
        message: 'فشل في تحديث تذكير بعد الصلاة: $e',
        settings: currentState.settings,
      ));
    }
  }

  /// Toggle istighfar reminder
  Future<void> toggleIstighfarReminder(bool enabled) async {
    final currentState = state;
    if (currentState is! AzkarReminderLoaded) return;

    try {
      await _localDatasource.toggleIstighfarReminder(enabled);
      final newSettings = currentState.settings.copyWith(
        istighfarReminderEnabled: enabled,
      );
      emit(currentState.copyWith(settings: newSettings));
      await _rescheduleReminders(newSettings);
    } catch (e) {
      emit(AzkarReminderError(
        message: 'فشل في تحديث تذكير الاستغفار: $e',
        settings: currentState.settings,
      ));
    }
  }

  /// Set istighfar interval
  Future<void> setIstighfarInterval(int hours) async {
    final currentState = state;
    if (currentState is! AzkarReminderLoaded) return;

    try {
      await _localDatasource.setIstighfarInterval(hours);
      final newSettings = currentState.settings.copyWith(
        istighfarIntervalHours: hours,
      );
      emit(currentState.copyWith(settings: newSettings));
      if (newSettings.istighfarReminderEnabled) {
        await _rescheduleReminders(newSettings);
      }
    } catch (e) {
      emit(AzkarReminderError(
        message: 'فشل في تحديث فترة تذكير الاستغفار: $e',
        settings: currentState.settings,
      ));
    }
  }

  /// Toggle sound
  Future<void> toggleSound(bool enabled) async {
    final currentState = state;
    if (currentState is! AzkarReminderLoaded) return;

    try {
      await _localDatasource.toggleSound(enabled);
      final newSettings = currentState.settings.copyWith(
        soundEnabled: enabled,
      );
      emit(currentState.copyWith(settings: newSettings));
    } catch (e) {
      emit(AzkarReminderError(
        message: 'فشل في تحديث إعداد الصوت: $e',
        settings: currentState.settings,
      ));
    }
  }

  /// Enable all reminders
  Future<void> enableAllReminders() async {
    final currentState = state;
    if (currentState is! AzkarReminderLoaded) return;

    try {
      await _localDatasource.toggleMorningReminder(true);
      await _localDatasource.toggleEveningReminder(true);
      await _localDatasource.toggleSleepReminder(true);

      final newSettings = currentState.settings.copyWith(
        morningReminderEnabled: true,
        eveningReminderEnabled: true,
        sleepReminderEnabled: true,
      );
      emit(currentState.copyWith(settings: newSettings));
      await _rescheduleReminders(newSettings);
    } catch (e) {
      emit(AzkarReminderError(
        message: 'فشل في تفعيل جميع التذكيرات: $e',
        settings: currentState.settings,
      ));
    }
  }

  /// Disable all reminders
  Future<void> disableAllReminders() async {
    final currentState = state;
    if (currentState is! AzkarReminderLoaded) return;

    try {
      await _localDatasource.toggleMorningReminder(false);
      await _localDatasource.toggleEveningReminder(false);
      await _localDatasource.toggleSleepReminder(false);
      await _localDatasource.toggleAfterPrayerReminder(false);
      await _localDatasource.toggleIstighfarReminder(false);

      await _service.cancelAllReminders();

      final newSettings = currentState.settings.copyWith(
        morningReminderEnabled: false,
        eveningReminderEnabled: false,
        sleepReminderEnabled: false,
        afterPrayerReminderEnabled: false,
        istighfarReminderEnabled: false,
      );
      emit(currentState.copyWith(
        settings: newSettings,
        message: 'تم إلغاء جميع التذكيرات',
      ));
    } catch (e) {
      emit(AzkarReminderError(
        message: 'فشل في إلغاء التذكيرات: $e',
        settings: currentState.settings,
      ));
    }
  }

  /// Reschedule all reminders based on current settings
  Future<void> _rescheduleReminders(AzkarReminderSettings settings) async {
    await _service.scheduleAllReminders(settings);
  }
}
