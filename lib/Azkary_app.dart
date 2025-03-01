import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:ramadan_app/core/extensions/context_extensions.dart';

import 'core/constants/app_colors.dart';
import 'main.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  _MainScaffoldState createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  late PersistentTabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
  }

  List<Widget> _buildScreens() {
    return [
      // const AzkarScreen(),
      HomeScreen(),
      HomeScreen(),
      HomeScreen(),
      HomeScreen(),
      // const SabhaScreen(),
      // const SettingsScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Image.asset(
          'assets/images/praying2.png',
          height: 35,
          color: AppColors.primary,
          width: 35,
        ),
        inactiveIcon: Image.asset(
          'assets/images/praying.png',
          height: 35,
          width: 35,
        ),
        title: (" "),
        activeColorPrimary: AppColors.primary,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Image.asset(
          'assets/images/crescent2.png',
          height: 30,
          color: AppColors.primary,
          width: 30,
        ),
        inactiveIcon: Image.asset(
          'assets/images/crescent.png',
          height: 30,
          width: 30,
        ),
        title: (" "),
        activeColorPrimary: AppColors.primary,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Image.asset(
          "assets/images/prayer-beads.png",
          height: 35,
          color: AppColors.primary,
          width: 35,
        ),
        inactiveIcon: Image.asset(
          'assets/images/arabic2.png',
          height: 35,
          width: 35,
        ),
        title: (" "),
        activeColorPrimary: AppColors.primary,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Image.asset(
          'assets/images/setting-bulb2.png',
          height: 30,
          color: AppColors.primary,
          width: 30,
        ),
        inactiveIcon: Image.asset(
          'assets/images/setting-bulb.png',
          height: 30,
          width: 30,
        ),
        title: (" "),
        activeColorPrimary: AppColors.primary,
        inactiveColorPrimary: Colors.grey,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      navBarHeight: 70.h,
      backgroundColor: context.isDark ? Colors.black : AppColors.white,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      hideNavigationBarWhenKeyboardAppears: true,
      navBarStyle: NavBarStyle.style13,
      onWillPop: (context) async {
        return true;
      },
    );
  }
}
