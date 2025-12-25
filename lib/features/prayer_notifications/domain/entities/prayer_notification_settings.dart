import 'package:equatable/equatable.dart';

/// Entity representing prayer notification settings
class PrayerNotificationSettings extends Equatable {
  final bool fajrEnabled;
  final bool dhuhrEnabled;
  final bool asrEnabled;
  final bool maghribEnabled;
  final bool ishaEnabled;
  final int preAlertMinutes;
  final bool soundEnabled;
  final String? selectedAdhan;

  const PrayerNotificationSettings({
    this.fajrEnabled = true,
    this.dhuhrEnabled = true,
    this.asrEnabled = true,
    this.maghribEnabled = true,
    this.ishaEnabled = true,
    this.preAlertMinutes = 0,
    this.soundEnabled = true,
    this.selectedAdhan,
  });

  /// Check if a specific prayer notification is enabled
  bool isPrayerEnabled(PrayerType prayer) {
    switch (prayer) {
      case PrayerType.fajr:
        return fajrEnabled;
      case PrayerType.dhuhr:
        return dhuhrEnabled;
      case PrayerType.asr:
        return asrEnabled;
      case PrayerType.maghrib:
        return maghribEnabled;
      case PrayerType.isha:
        return ishaEnabled;
    }
  }

  /// Create a copy with updated values
  PrayerNotificationSettings copyWith({
    bool? fajrEnabled,
    bool? dhuhrEnabled,
    bool? asrEnabled,
    bool? maghribEnabled,
    bool? ishaEnabled,
    int? preAlertMinutes,
    bool? soundEnabled,
    String? selectedAdhan,
  }) {
    return PrayerNotificationSettings(
      fajrEnabled: fajrEnabled ?? this.fajrEnabled,
      dhuhrEnabled: dhuhrEnabled ?? this.dhuhrEnabled,
      asrEnabled: asrEnabled ?? this.asrEnabled,
      maghribEnabled: maghribEnabled ?? this.maghribEnabled,
      ishaEnabled: ishaEnabled ?? this.ishaEnabled,
      preAlertMinutes: preAlertMinutes ?? this.preAlertMinutes,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      selectedAdhan: selectedAdhan ?? this.selectedAdhan,
    );
  }

  /// Toggle a specific prayer notification
  PrayerNotificationSettings togglePrayer(PrayerType prayer, bool enabled) {
    switch (prayer) {
      case PrayerType.fajr:
        return copyWith(fajrEnabled: enabled);
      case PrayerType.dhuhr:
        return copyWith(dhuhrEnabled: enabled);
      case PrayerType.asr:
        return copyWith(asrEnabled: enabled);
      case PrayerType.maghrib:
        return copyWith(maghribEnabled: enabled);
      case PrayerType.isha:
        return copyWith(ishaEnabled: enabled);
    }
  }

  @override
  List<Object?> get props => [
        fajrEnabled,
        dhuhrEnabled,
        asrEnabled,
        maghribEnabled,
        ishaEnabled,
        preAlertMinutes,
        soundEnabled,
        selectedAdhan,
      ];
}

/// Enum representing prayer types
enum PrayerType {
  fajr,
  dhuhr,
  asr,
  maghrib,
  isha;

  /// Get Arabic name for the prayer
  String get arabicName {
    switch (this) {
      case PrayerType.fajr:
        return 'الفجر';
      case PrayerType.dhuhr:
        return 'الظهر';
      case PrayerType.asr:
        return 'العصر';
      case PrayerType.maghrib:
        return 'المغرب';
      case PrayerType.isha:
        return 'العشاء';
    }
  }

  /// Get notification ID for the prayer
  int get notificationId {
    switch (this) {
      case PrayerType.fajr:
        return 1001;
      case PrayerType.dhuhr:
        return 1002;
      case PrayerType.asr:
        return 1003;
      case PrayerType.maghrib:
        return 1004;
      case PrayerType.isha:
        return 1005;
    }
  }

  /// Get pre-alert notification ID for the prayer
  int get preAlertNotificationId {
    switch (this) {
      case PrayerType.fajr:
        return 2001;
      case PrayerType.dhuhr:
        return 2002;
      case PrayerType.asr:
        return 2003;
      case PrayerType.maghrib:
        return 2004;
      case PrayerType.isha:
        return 2005;
    }
  }
}
