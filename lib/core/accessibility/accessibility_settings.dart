import 'package:flutter/material.dart';
import 'package:ramadan_app/core/local_storage/shared_preferences_manager.dart';

/// Font scale options for accessibility
enum FontScale {
  small(0.85, 'صغير'),
  normal(1.0, 'عادي'),
  large(1.15, 'كبير'),
  extraLarge(1.3, 'كبير جداً');

  final double scale;
  final String arabicName;

  const FontScale(this.scale, this.arabicName);

  static FontScale fromScale(double scale) {
    return FontScale.values.firstWhere(
      (e) => e.scale == scale,
      orElse: () => FontScale.normal,
    );
  }
}

/// Manages accessibility settings for the app
class AccessibilitySettings extends ChangeNotifier {
  static const String _fontScaleKey = 'font_scale';
  static const String _highContrastKey = 'high_contrast';

  double _fontScale = 1.0;
  bool _highContrast = false;

  double get fontScale => _fontScale;
  bool get highContrast => _highContrast;
  FontScale get currentFontScale => FontScale.fromScale(_fontScale);

  /// Load settings from storage
  Future<void> loadSettings() async {
    final savedScale = SharedPreferencesManager.getData(key: _fontScaleKey);
    if (savedScale != null && savedScale is double) {
      _fontScale = savedScale;
    }

    final savedContrast = SharedPreferencesManager.getData(key: _highContrastKey);
    if (savedContrast != null && savedContrast is bool) {
      _highContrast = savedContrast;
    }

    notifyListeners();
  }

  /// Set font scale
  Future<void> setFontScale(FontScale scale) async {
    _fontScale = scale.scale;
    await SharedPreferencesManager.setData(
      key: _fontScaleKey,
      value: _fontScale,
    );
    notifyListeners();
  }

  /// Toggle high contrast mode
  Future<void> toggleHighContrast() async {
    _highContrast = !_highContrast;
    await SharedPreferencesManager.setData(
      key: _highContrastKey,
      value: _highContrast,
    );
    notifyListeners();
  }
}
