import 'package:equatable/equatable.dart';

import '../../domain/entities/prayer_notification_settings.dart';

/// Base state for prayer notification cubit
abstract class PrayerNotificationState extends Equatable {
  const PrayerNotificationState();

  @override
  List<Object?> get props => [];
}

/// Initial state before loading settings
class PrayerNotificationInitial extends PrayerNotificationState {
  const PrayerNotificationInitial();
}

/// Loading state while fetching settings
class PrayerNotificationLoading extends PrayerNotificationState {
  const PrayerNotificationLoading();
}

/// State when settings are loaded successfully
class PrayerNotificationLoaded extends PrayerNotificationState {
  final PrayerNotificationSettings settings;
  final bool notificationsScheduled;
  final String? message;

  const PrayerNotificationLoaded({
    required this.settings,
    this.notificationsScheduled = false,
    this.message,
  });

  @override
  List<Object?> get props => [settings, notificationsScheduled, message];

  PrayerNotificationLoaded copyWith({
    PrayerNotificationSettings? settings,
    bool? notificationsScheduled,
    String? message,
  }) {
    return PrayerNotificationLoaded(
      settings: settings ?? this.settings,
      notificationsScheduled:
          notificationsScheduled ?? this.notificationsScheduled,
      message: message,
    );
  }
}

/// State when notifications are being scheduled
class PrayerNotificationScheduling extends PrayerNotificationState {
  final PrayerNotificationSettings settings;

  const PrayerNotificationScheduling({required this.settings});

  @override
  List<Object?> get props => [settings];
}

/// State when an error occurs
class PrayerNotificationError extends PrayerNotificationState {
  final String message;
  final PrayerNotificationSettings? settings;

  const PrayerNotificationError({
    required this.message,
    this.settings,
  });

  @override
  List<Object?> get props => [message, settings];
}
