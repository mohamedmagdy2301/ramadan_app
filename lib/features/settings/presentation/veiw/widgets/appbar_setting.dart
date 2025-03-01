import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ramadan_app/core/constants/app_strings.dart';
import 'package:ramadan_app/core/constants/app_text_style.dart';

class AppBarSettings extends StatelessWidget implements PreferredSizeWidget {
  const AppBarSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(AppStrings.settings, style: StyleText.regular30()),
      centerTitle: true,
      flexibleSpace: Container(),
      elevation: 0,
      toolbarHeight: 60.h,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(60.h);
}
