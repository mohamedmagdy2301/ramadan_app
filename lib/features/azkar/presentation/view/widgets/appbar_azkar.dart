import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ramadan_app/core/extensions/context_extensions.dart';

import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/constants/app_text_style.dart';

class AppBarAzkar extends StatelessWidget implements PreferredSizeWidget {
  const AppBarAzkar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        AppStrings.appName,
        style: StyleText.extraBold34().copyWith(
          color: context.onPrimaryColor,
          fontFamily: "Amiri",
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
