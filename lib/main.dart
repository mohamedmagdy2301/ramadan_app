import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_library/quran.dart';
import 'package:ramadan_app/core/constants/app_colors.dart';
import 'package:ramadan_app/core/notification_helper/awesome_notification_manager.dart';
import 'package:ramadan_app/core/router/app_router.dart';
import 'package:ramadan_app/features/home/presentation/view_model/prayer_times_cubit/prayper_times_cubit.dart';

import 'core/local_storage/shared_preferences_manager.dart';
import 'core/theming/app_theme_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.wait([
    ScreenUtil.ensureScreenSize(), QuranLibrary().init(),

    // AwesomeNotificationManager.initialize(),
    LocalNotificationService.initialize(),
    SharedPreferencesManager.sharedPreferencesInitialize(),
  ]);

  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  final savedThemeColor = await SharedPreferencesManager.getData(
    key: 'theme_color',
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
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
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
            (theme, darkTheme) => BlocProvider<PrayerTimesCubit>(
              create: (context) => PrayerTimesCubit()..fetchPrayerTimes(),
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
    );
  }
}
