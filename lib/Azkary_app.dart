import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:ramadan_app/core/extensions/context_extensions.dart';
import 'package:ramadan_app/features/home/presentation/view/screens/home_screen.dart';
import 'package:ramadan_app/features/quran/presentation/pages/quran_screen.dart';
import 'package:ramadan_app/features/settings/presentation/veiw/screens/settings_screen.dart';

import 'features/azkar/presentation/view/screens/azkar_screen.dart';
import 'features/sabha/presentation/veiw/screens/sabha_screen.dart';

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
        icon: Image.asset(
          'assets/images/praying2.png',
          height: 35.sp,
          color: context.primaryColor,
          width: 35.sp,
        ),
        inactiveIcon: Image.asset(
          'assets/images/praying.png',
          height: 35.sp,
          width: 35.sp,
        ),
        title: (" "),
        activeColorPrimary: context.primaryColor,
        inactiveColorPrimary: Colors.grey,
      ),

      PersistentBottomNavBarItem(
        icon: Image.asset(
          'assets/images/crescent2.png',
          height: 30.sp,
          color: context.primaryColor,
          width: 30.sp,
        ),
        inactiveIcon: Image.asset(
          'assets/images/crescent.png',
          height: 30.sp,
          width: 30.sp,
        ),
        title: (" "),
        activeColorPrimary: context.primaryColor,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Image.asset(
          'assets/images/quran.png',
          height: 40.sp,
          // color: context.primaryColor,
          width: 38.sp,
        ),
        inactiveIcon: Image.asset(
          'assets/images/quran.png',
          height: 38.sp,
          color: Colors.grey,
          width: 38.sp,
        ),
        title: (" "),
        activeColorPrimary: context.primaryColor,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Image.asset(
          "assets/images/prayer-beads.png",
          height: 35.sp,
          color: context.primaryColor,
          width: 35.sp,
        ),
        inactiveIcon: Image.asset(
          'assets/images/arabic2.png',
          height: 35.sp,
          width: 35.sp,
        ),
        title: (" "),
        activeColorPrimary: context.primaryColor,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Image.asset(
          'assets/images/setting-bulb2.png',
          height: 30.sp,
          color: context.primaryColor,
          width: 30.sp,
        ),
        inactiveIcon: Image.asset(
          'assets/images/setting-bulb.png',
          height: 28.sp,
          width: 28.sp,
        ),
        title: (" "),
        activeColorPrimary: context.primaryColor,
        inactiveColorPrimary: Colors.grey,
      ),
    ];
  }

  Future<bool> _onBackPressed() async {
    return await showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text("الخروج من التطبيق"),
                content: const Text("هل ترغب بالخروج من التطبيق؟"),
                actionsAlignment: MainAxisAlignment.center,
                actions: [
                  TextButton(
                    onPressed: () {
                      _controller.jumpToTab(2);
                      Navigator.of(context).pop(false);
                    },
                    child: const Text("الغاء"),
                  ),

                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text("الخروج"),
                  ),
                ],
              ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
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
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        stateManagement: true,
        hideNavigationBarWhenKeyboardAppears: true,
        navBarStyle: NavBarStyle.style13,
      ),
    );
  }
}
