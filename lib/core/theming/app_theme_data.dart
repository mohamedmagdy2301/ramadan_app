import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class AppThemeData {
  static ThemeData darkTheme(Color seedColor) => ThemeData(
    fontFamily: 'Cairo',
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.backgroundDarkColor,
    primaryColor: seedColor,

    colorScheme: ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.dark,
    ),
    iconTheme: const IconThemeData(color: AppColors.textDarkColor),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.backgroundDarkColor,
      elevation: 0,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false,
      showUnselectedLabels: false,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.backgroundDarkColor,
      foregroundColor: AppColors.textDarkColor,
      elevation: 0,
    ),
  );

  static ThemeData lightTheme(Color seedColor) => ThemeData(
    fontFamily: 'Cairo',
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.backgroundLightColor,
    primaryColor: seedColor,
    colorScheme: ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.light,
    ),
    iconTheme: const IconThemeData(color: AppColors.textLightColor),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.backgroundLightColor,
      elevation: 0,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false,
      showUnselectedLabels: false,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.backgroundLightColor,
      foregroundColor: AppColors.textLightColor,
      elevation: 0,
    ),
  );
}
