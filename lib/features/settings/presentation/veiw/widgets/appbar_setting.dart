import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ramadan_app/core/constants/app_strings.dart';
import 'package:ramadan_app/core/constants/app_text_style.dart';
import 'package:ramadan_app/core/extensions/context_extensions.dart';

class AppBarSettings extends StatelessWidget implements PreferredSizeWidget {
  const AppBarSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor:
          context.isDark
              ? const Color.fromARGB(255, 48, 48, 48)
              : const Color.fromARGB(255, 218, 218, 218),
      title: Text(
        AppStrings.settings,
        style: StyleText.regular30().copyWith(color: context.onPrimaryColor),
      ),
      centerTitle: true,
      flexibleSpace: Container(),
      elevation: 0,
      toolbarHeight: 60.h,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(60.h);
}
