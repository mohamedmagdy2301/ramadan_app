import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_library/quran.dart';
import 'package:ramadan_app/core/extensions/context_extensions.dart';

import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/constants/app_text_style.dart';

class AppBarQuran extends StatefulWidget implements PreferredSizeWidget {
  const AppBarQuran({super.key});

  @override
  State<AppBarQuran> createState() => _AppBarQuranState();

  @override
  Size get preferredSize => Size.fromHeight(140.h);
}

class _AppBarQuranState extends State<AppBarQuran> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        AppStrings.quran,
        style: StyleText.extraBold34().copyWith(
          color: context.onPrimaryColor,
          fontFamily: "Amiri",
        ),
      ),
      leading: Builder(
        builder:
            (context) => IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
      ),
      actions: [
        Builder(
          builder:
              (context) => IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (ctx) =>
                              QuranLibrarySearchScreen(isDark: context.isDark),
                    ),
                  );
                },
              ),
        ),
      ],
      centerTitle: true,
      forceMaterialTransparency: true,
      flexibleSpace: Container(),
      elevation: 0,
      toolbarHeight: 80.h,
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(50), // Height of BottomNavBar
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          elevation: 0,
          selectedItemColor: context.primaryColor,
          unselectedItemColor: context.onPrimaryColor,
          backgroundColor: context.backgroundColor,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: [
            BottomNavigationBarItem(icon: Text("السور"), label: 'السور'),
            BottomNavigationBarItem(icon: Text("اجزاء"), label: 'اجزاء'),
            BottomNavigationBarItem(
              icon: Text("المحفوظات"),
              label: 'المحفوظات',
            ),
          ],
        ),
      ),
    );
  }
}
