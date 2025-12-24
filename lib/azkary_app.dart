import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:ramadan_app/core/constants/app_images.dart';
import 'package:ramadan_app/core/constants/app_strings.dart';
import 'package:ramadan_app/core/constants/app_text_style.dart';
import 'package:ramadan_app/core/extensions/context_extensions.dart';
import 'package:ramadan_app/features/home/presentation/view/screens/home_screen.dart';
import 'package:ramadan_app/features/quran/presentation/pages/quran_screen.dart';
import 'package:ramadan_app/features/settings/presentation/view/screens/settings_screen.dart';

import 'features/azkar/presentation/view/screens/azkar_screen.dart';
import 'features/sabha/presentation/view/screens/sabha_screen.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  late PersistentTabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 2);
  }

  List<Widget> _buildScreens() {
    return [
      AzkarScreen(),
      const HomeScreen(),
      const QuranScreen(),
      const SabhaScreen(),
      SettingsScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Semantics(
          label: AppStrings.azkar,
          child: Transform.rotate(
            angle: .2,
            child: Image.asset(
              AppAssets.prayingActive,
              height: 40.sp,
              color: context.primaryColor,
              width: 40.sp,
            ),
          ),
        ),
        inactiveIcon: Semantics(
          label: AppStrings.azkar,
          child: Image.asset(
            AppAssets.prayingInactive,
            height: 32.sp,
            width: 32.sp,
            color: Colors.grey,
          ),
        ),
        title: ' ',
        activeColorPrimary: context.primaryColor,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Semantics(
          label: AppStrings.home,
          child: Transform.rotate(
            angle: .2,
            child: Image.asset(
              AppAssets.crescentActive,
              height: 35.sp,
              color: context.primaryColor,
              width: 35.sp,
            ),
          ),
        ),
        inactiveIcon: Semantics(
          label: AppStrings.home,
          child: Image.asset(
            AppAssets.crescentInactive,
            height: 30.sp,
            width: 30.sp,
            color: Colors.grey,
          ),
        ),
        title: ' ',
        activeColorPrimary: context.primaryColor,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Semantics(
          label: AppStrings.quran,
          child: Image.asset(
            AppAssets.quranActive,
            height: 35.sp,
            width: 35.sp,
          ),
        ),
        inactiveIcon: Semantics(
          label: AppStrings.quran,
          child: Image.asset(
            AppAssets.quranInactive,
            height: 30.sp,
            width: 30.sp,
            color: Colors.grey,
          ),
        ),
        title: ' ',
        activeColorPrimary: context.primaryColor,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Semantics(
          label: AppStrings.sabha,
          child: Transform.rotate(
            angle: -.5,
            child: Image.asset(
              AppAssets.prayerBeads,
              height: 40.sp,
              color: context.primaryColor,
              width: 40.sp,
            ),
          ),
        ),
        inactiveIcon: Semantics(
          label: AppStrings.sabha,
          child: Image.asset(
            AppAssets.arabicInactive,
            height: 35.sp,
            width: 35.sp,
            color: Colors.grey,
          ),
        ),
        title: ' ',
        activeColorPrimary: context.primaryColor,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Semantics(
          label: AppStrings.settings,
          child: Image.asset(
            AppAssets.settingBulbActive,
            height: 34.sp,
            color: context.primaryColor,
            width: 34.sp,
          ),
        ),
        inactiveIcon: Semantics(
          label: AppStrings.settings,
          child: Transform.rotate(
            angle: -8,
            child: Image.asset(
              AppAssets.settingBulbInactive,
              height: 28.sp,
              width: 28.sp,
              color: Colors.grey,
            ),
          ),
        ),
        title: ' ',
        activeColorPrimary: context.primaryColor,
        inactiveColorPrimary: Colors.grey,
      ),
    ];
  }

  Future<bool> _onBackPressed() async {
    // Jump to tab before showing dialog to avoid setState during build
    if (_controller.index != 2) {
      _controller.jumpToTab(2);
      return false;
    }

    return await showDialog(
          context: context,
          builder: (dialogContext) {
            return AlertDialog.adaptive(
              title: Text(
                AppStrings.exitApp,
                style: StyleText.regular22().copyWith(
                  color: context.onPrimaryColor,
                ),
              ),
              content: Text(
                AppStrings.exitAppQuestion,
                textAlign: TextAlign.right,
                style: StyleText.regular18().copyWith(
                  color: context.onPrimaryColor,
                ),
              ),
              actionsAlignment: MainAxisAlignment.spaceEvenly,
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop(false);
                  },
                  child: Text(
                    AppStrings.cancel,
                    style: StyleText.regular18().copyWith(
                      color: context.primaryColor,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(true),
                  child: Text(
                    AppStrings.exit,
                    style: StyleText.regular18().copyWith(
                      color: context.primaryColor,
                    ),
                  ),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        bool shouldExit = await _onBackPressed();
        if (shouldExit) {
          SystemNavigator.pop();
        }
      },
      child: PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),
        confineToSafeArea: true,
        navBarHeight: 70.h,
        backgroundColor: context.backgroundColor,
        handleAndroidBackButtonPress: false,
        resizeToAvoidBottomInset: true,
        stateManagement: true,
        hideNavigationBarWhenKeyboardAppears: true,
        navBarStyle: NavBarStyle.style13,
      ),
    );
  }
}
