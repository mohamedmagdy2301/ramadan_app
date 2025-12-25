import 'package:flutter/material.dart';
import 'package:ramadan_app/core/responsive/screen_type.dart';

/// Helper class for responsive design
class ResponsiveHelper {
  // Breakpoints
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;

  /// Get the current screen type based on width
  static ScreenType getScreenType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < mobileBreakpoint) {
      return ScreenType.mobile;
    } else if (width < tabletBreakpoint) {
      return ScreenType.tablet;
    } else {
      return ScreenType.desktop;
    }
  }

  /// Check if the current device is mobile
  static bool isMobile(BuildContext context) {
    return getScreenType(context) == ScreenType.mobile;
  }

  /// Check if the current device is tablet
  static bool isTablet(BuildContext context) {
    return getScreenType(context) == ScreenType.tablet;
  }

  /// Check if the current device is desktop
  static bool isDesktop(BuildContext context) {
    return getScreenType(context) == ScreenType.desktop;
  }

  /// Get grid columns count based on screen type
  static int getGridColumns(BuildContext context, {
    int mobile = 1,
    int tablet = 2,
    int desktop = 3,
  }) {
    switch (getScreenType(context)) {
      case ScreenType.mobile:
        return mobile;
      case ScreenType.tablet:
        return tablet;
      case ScreenType.desktop:
        return desktop;
    }
  }

  /// Get responsive value based on screen type
  static T getValue<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    switch (getScreenType(context)) {
      case ScreenType.mobile:
        return mobile;
      case ScreenType.tablet:
        return tablet ?? mobile;
      case ScreenType.desktop:
        return desktop ?? tablet ?? mobile;
    }
  }

  /// Get horizontal padding based on screen type
  static double getHorizontalPadding(BuildContext context) {
    return getValue(
      context,
      mobile: 16.0,
      tablet: 32.0,
      desktop: 48.0,
    );
  }

  /// Get vertical padding based on screen type
  static double getVerticalPadding(BuildContext context) {
    return getValue(
      context,
      mobile: 12.0,
      tablet: 16.0,
      desktop: 24.0,
    );
  }

  /// Get card max width for tablets and desktops
  static double? getMaxContentWidth(BuildContext context) {
    switch (getScreenType(context)) {
      case ScreenType.mobile:
        return null; // Full width
      case ScreenType.tablet:
        return 700;
      case ScreenType.desktop:
        return 900;
    }
  }

  /// Get font scale factor based on screen type
  static double getFontScaleFactor(BuildContext context) {
    return getValue(
      context,
      mobile: 1.0,
      tablet: 1.05,
      desktop: 1.1,
    );
  }

  /// Get icon size based on screen type
  static double getIconSize(BuildContext context, {double baseSize = 24}) {
    return getValue(
      context,
      mobile: baseSize,
      tablet: baseSize * 1.15,
      desktop: baseSize * 1.25,
    );
  }

  /// Get spacing between items based on screen type
  static double getSpacing(BuildContext context) {
    return getValue(
      context,
      mobile: 12.0,
      tablet: 16.0,
      desktop: 20.0,
    );
  }

  /// Get card elevation based on screen type
  static double getCardElevation(BuildContext context) {
    return getValue(
      context,
      mobile: 2.0,
      tablet: 4.0,
      desktop: 6.0,
    );
  }

  /// Check if device is in landscape orientation
  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  /// Get screen width
  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  /// Get screen height
  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  /// Get aspect ratio friendly grid child aspect ratio
  static double getGridAspectRatio(BuildContext context, {
    double mobileRatio = 1.0,
    double tabletRatio = 1.2,
    double desktopRatio = 1.3,
  }) {
    return getValue(
      context,
      mobile: mobileRatio,
      tablet: tabletRatio,
      desktop: desktopRatio,
    );
  }
}
