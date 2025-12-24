import 'dart:developer';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_widget/home_widget.dart';
import 'package:lock_orientation_screen/lock_orientation_screen.dart';
import 'package:quran_library/quran.dart';
import 'package:ramadan_app/core/constants/app_colors.dart';
import 'package:ramadan_app/core/constants/storage_keys.dart';
import 'package:ramadan_app/core/accessibility/accessibility_settings.dart';
import 'package:ramadan_app/core/di/injection_container.dart';
import 'package:ramadan_app/core/notification_helper/local_notification_manager.dart';
import 'package:ramadan_app/core/notification_helper/smart_notification_manager.dart';
import 'package:ramadan_app/core/router/app_router.dart';
import 'package:ramadan_app/features/azkar/data/azkar_screen_body_item_model_data.dart';
import 'package:ramadan_app/features/azkar/presentation/view/screens/azkar_details_screen.dart';
import 'package:ramadan_app/features/home/presentation/view_model/prayer_times_cubit/prayer_times_cubit.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import 'core/local_storage/shared_preferences_manager.dart';
import 'core/theming/app_theme_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HomeWidget.setAppGroupId('group.timePrayer');
  await Future.wait([
    ScreenUtil.ensureScreenSize(),
    QuranLibrary.init(),
    LocalNotificationService.initialize(),
    SharedPreferencesManager.sharedPreferencesInitialize(),
    initializeDependencies(),
  ]);

  // Load accessibility settings after dependencies are initialized
  await sl<AccessibilitySettings>().loadSettings();

  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  final savedThemeColor = await SharedPreferencesManager.getData(
    key: StorageKeys.themeColor,
  );
  runApp(
    MyApp(savedThemeMode: savedThemeMode, savedThemeColor: savedThemeColor),
  );
}

class MyApp extends StatefulWidget {
  final AdaptiveThemeMode? savedThemeMode;
  final Color? savedThemeColor;

  const MyApp({super.key, this.savedThemeMode, this.savedThemeColor});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late PrayerTimesCubit _prayerTimesCubit;

  @override
  initState() {
    super.initState();
    _prayerTimesCubit = sl<PrayerTimesCubit>();
    _enableWakelock();
    _initializeSmartNotifications();
    listenNotification();
  }

  Future<void> _enableWakelock() async {
    try {
      await WakelockPlus.enable();
    } catch (e) {
      log('Wakelock error: $e');
    }
  }

  Future<void> _initializeSmartNotifications() async {
    try {
      // Initialize smart notification manager
      await SmartNotificationManager.instance.initialize();

      // Listen to prayer time changes for auto-scheduling
      SmartNotificationManager.instance.listenToPrayerTimeChanges(
        _prayerTimesCubit,
      );

      log('Smart notification manager initialized');
    } catch (e) {
      log('Smart notification initialization error: $e');
    }
  }

  @override
  void dispose() {
    SmartNotificationManager.instance.dispose();
    super.dispose();
  }

  void listenNotification() {
    LocalNotificationService.streamController.stream.listen((response) {
      log("Notification Response: $response");
      AppRouter.navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder:
              (context) => AzkarDetailsScreen(
                azkarScreenBodyItemModel:
                    azkarScreenBodyItemModel[response.id!],
              ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return LockOrientation(
      child: ScreenUtilInit(
        designSize: const Size(390, 844),
        minTextAdapt: true,
        splitScreenMode: true,
        child: AdaptiveTheme(
          light: AppThemeData.lightTheme(
            widget.savedThemeColor ?? AppColors.primary,
          ),
          dark: AppThemeData.darkTheme(
            widget.savedThemeColor ?? AppColors.primary,
          ),
          debugShowFloatingThemeButton: false,
          initial: widget.savedThemeMode ?? AdaptiveThemeMode.dark,
          builder:
              (theme, darkTheme) => BlocProvider<PrayerTimesCubit>.value(
                value: _prayerTimesCubit..fetchPrayerTimes(),
                child: MaterialApp.router(
                  theme: theme,
                  debugShowCheckedModeBanner: false,
                  darkTheme: darkTheme,
                  localizationsDelegates: const [
                    GlobalCupertinoLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                  ],
                  supportedLocales: const [Locale("ar", "AE")],
                  locale: const Locale("ar", "AE"),
                  routerConfig: AppRouter.appRouter,
                ),
              ),
        ),
      ),
    );
  }
}
