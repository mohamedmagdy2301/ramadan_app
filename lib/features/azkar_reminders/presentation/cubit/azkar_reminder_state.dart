import 'package:equatable/equatable.dart';
import 'package:ramadan_app/features/azkar_reminders/domain/entities/azkar_reminder_settings.dart';

/// Base state for azkar reminder cubit
abstract class AzkarReminderState extends Equatable {
  const AzkarReminderState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class AzkarReminderInitial extends AzkarReminderState {
  const AzkarReminderInitial();
}

/// Loading state
class AzkarReminderLoading extends AzkarReminderState {
  const AzkarReminderLoading();
}

/// Loaded state with settings
class AzkarReminderLoaded extends AzkarReminderState {
  final AzkarReminderSettings settings;
  final String? message;

  const AzkarReminderLoaded({
    required this.settings,
    this.message,
  });

  @override
  List<Object?> get props => [settings, message];

  AzkarReminderLoaded copyWith({
    AzkarReminderSettings? settings,
    String? message,
  }) {
    return AzkarReminderLoaded(
      settings: settings ?? this.settings,
      message: message,
    );
  }
}

/// Error state
class AzkarReminderError extends AzkarReminderState {
  final String message;
  final AzkarReminderSettings? settings;

  const AzkarReminderError({
    required this.message,
    this.settings,
  });

  @override
  List<Object?> get props => [message, settings];
}
