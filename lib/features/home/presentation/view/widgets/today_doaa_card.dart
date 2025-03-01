import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ramadan_app/core/constants/app_strings.dart';
import 'package:ramadan_app/core/constants/app_text_style.dart';
import 'package:ramadan_app/core/extensions/context_extensions.dart';
import 'package:ramadan_app/core/extensions/int_extensions.dart';
import 'package:ramadan_app/core/extensions/widget_extensions.dart';

import '../../../../azkar/data/azkar_data.dart';

class TodayDoaaCard extends StatefulWidget {
  const TodayDoaaCard({super.key});

  @override
  State<TodayDoaaCard> createState() => _TodayDoaaCardState();
}

class _TodayDoaaCardState extends State<TodayDoaaCard> {
  List<Map<String, String>> azkarList = azkarData["أدعية الأنبياء"]!;

  // Function to display random Zikr
  displayRandomZikr() {
    Random random = Random();
    int randomIndex = random.nextInt(azkarList.length);
    String randomAzkarContent = azkarList[randomIndex]["content"]!;
    return randomAzkarContent.split(".").first;
  }

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(hours: 1), (Timer t) => displayRandomZikr());
    displayRandomZikr();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color:
          !context.isDark
              ? Colors.grey.shade100
              : const Color.fromARGB(255, 31, 31, 31),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.bookmark, color: context.primaryColor, size: 20.sp),
              5.wSpace,
              Text(
                AppStrings.daiaToday,
                style: StyleText.semiBold16().copyWith(
                  color: context.primaryColor,
                ),
              ),
            ],
          ),
          15.hSpace,
          Text(
            displayRandomZikr(),
            style: StyleText.medium18().copyWith(
              height: 2.h,
              wordSpacing: 1.w,
              color: !context.isDark ? Colors.black : Colors.white,
              fontFamily: "Amiri",
            ),
          ),
        ],
      ).paddingSymmetric(horizontal: 15, vertical: 10),
    );
  }
}
