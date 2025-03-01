import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ramadan_app/core/constants/app_text_style.dart';

import '../../../../../core/utils/functions/convert_to_12_hour.dart';

class PrayerTimeRow extends StatelessWidget {
  const PrayerTimeRow({
    super.key,
    required this.time,
    required this.title,
    required this.colorText,
  });
  final String time, title;
  final Color colorText;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: StyleText.medium18().copyWith(color: colorText)),
          const Spacer(),
          Text(
            convertTo12HourFormat(
              time,
            ).replaceAll("AM", "ص").replaceAll("PM", " م  "),
            style: StyleText.medium14().copyWith(color: colorText),
          ),
        ],
      ),
    );
  }
}
