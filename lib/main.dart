// Copyright © 2020 Birju Vachhani. All rights reserved.
// Use of this source code is governed by an Apache license that can be
// found in the LICENSE file.

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ramadan_app/core/constants/app_colors.dart';
import 'package:ramadan_app/core/extensions/context_extensions.dart';
import 'package:ramadan_app/core/router/app_router.dart';
import 'package:ramadan_app/features/home/presentation/view_model/prayer_times_cubit/prayper_times_cubit.dart';

import 'core/theming/app_theme_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  runApp(MyApp(savedThemeMode: savedThemeMode));
}

class MyApp extends StatefulWidget {
  final AdaptiveThemeMode? savedThemeMode;

  const MyApp({super.key, this.savedThemeMode});

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
        light: AppThemeData.lightTheme(AppColors.primary),
        dark: AppThemeData.darkTheme(AppColors.primary),
        debugShowFloatingThemeButton: true,
        initial: widget.savedThemeMode ?? AdaptiveThemeMode.system,
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

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDark = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox.expand(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Light', style: TextStyle(color: context.primaryColor)),
                  const SizedBox(width: 10),
                  Switch.adaptive(
                    value: AdaptiveTheme.of(context).mode.isDark,
                    onChanged: (value) {
                      if (value) {
                        AdaptiveTheme.of(context).setDark();
                      } else {
                        AdaptiveTheme.of(context).setLight();
                      }
                    },
                  ),
                  const SizedBox(width: 10),
                  Text('Dark', style: TextStyle(color: context.primaryColor)),
                ],
              ),
              const SizedBox(height: 60),
              FilledButton(
                onPressed:
                    () => AdaptiveTheme.of(context).setTheme(
                      light: AppThemeData.lightTheme(Colors.green),
                      dark: AppThemeData.darkTheme(Colors.green),
                    ),
                style: ElevatedButton.styleFrom(
                  visualDensity: const VisualDensity(
                    horizontal: 4,
                    vertical: 2,
                  ),
                ),
                child: const Text('Set Custom Theme'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
