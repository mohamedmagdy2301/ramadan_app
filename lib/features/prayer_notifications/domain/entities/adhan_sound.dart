import 'package:ramadan_app/core/constants/app_images.dart';

/// Enum representing available Adhan sounds
enum AdhanSound {
  /// Makkah Adhan - الحرم المكي
  makkah,

  /// Default system sound
  defaultSound;

  /// Get display name in Arabic
  String get arabicName {
    switch (this) {
      case AdhanSound.makkah:
        return 'أذان الحرم المكي';
      case AdhanSound.defaultSound:
        return 'الصوت الافتراضي';
    }
  }

  /// Get asset path for the sound file
  String get assetPath {
    switch (this) {
      case AdhanSound.makkah:
        return AppAssets.adhanMakkah;
      case AdhanSound.defaultSound:
        return AppAssets.adhanReminder;
    }
  }

  /// Get the raw resource name for Android notifications (without extension)
  String get rawResourceName {
    switch (this) {
      case AdhanSound.makkah:
        return 'adan';
      case AdhanSound.defaultSound:
        return 'reminder';
    }
  }

  /// Get AdhanSound from string identifier
  static AdhanSound? fromString(String? value) {
    if (value == null) return null;
    try {
      return AdhanSound.values.firstWhere(
        (e) => e.name == value,
      );
    } catch (_) {
      return null;
    }
  }
}
