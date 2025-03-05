import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ramadan_app/core/extensions/context_extensions.dart';

import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/constants/app_text_style.dart';

class AppBarQuran extends StatelessWidget implements PreferredSizeWidget {
  const AppBarQuran({super.key});

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
      centerTitle: true,
      forceMaterialTransparency: true,
      flexibleSpace: Container(),
      elevation: 0,
      toolbarHeight: 80.h,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(80.h);
}
