import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ramadan_app/core/extensions/context_extensions.dart';

import '../../../../../core/constants/app_text_style.dart';

class SettingsRowItem extends StatelessWidget {
  const SettingsRowItem({
    super.key,
    required this.title,
    required this.leading,
  });
  final String title;
  final Widget leading;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 80.h,
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          color:
              context.isDark
                  ? const Color.fromARGB(255, 48, 48, 48)
                  : const Color.fromARGB(255, 218, 218, 218),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: StyleText.regular20().copyWith(
                  color: context.onPrimaryColor,
                ),
              ),
              const Spacer(),
              leading,
            ],
          ),
        ),
        const Divider(
          color: Color.fromARGB(255, 186, 186, 186),
          thickness: 1,
          height: 1,
        ),
      ],
    );
  }
}
