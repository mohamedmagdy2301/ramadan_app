import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ramadan_app/core/extensions/context_extensions.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_style.dart';

class SabhaScreenBodyCircle extends StatelessWidget {
  const SabhaScreenBodyCircle({
    super.key,
    required this.counter,
    required this.selectedSabha,
  });

  final String selectedSabha;
  final int counter;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300.h,
      width: 300.w,
      decoration: BoxDecoration(
        color: context.primaryColor,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: context.primaryColor.withAlpha(200),
            blurRadius: 12,
            spreadRadius: 8,
          ),
        ],
        // boxShadow: [
        //   BoxShadow(
        //     color: ColorsAppLight.primaryColor,
        //     blurRadius: 25.sp,
        //     spreadRadius: 15.sp,
        //   ),
        // ],
        // gradient: const LinearGradient(
        //   colors: [
        //     Color.fromARGB(255, 162, 191, 89),
        //     Color.fromARGB(255, 165, 187, 110),
        //     ColorsAppLight.primaryColor,
        //     Color.fromARGB(255, 110, 125, 73),
        //     Color.fromARGB(255, 97, 110, 65),
        //   ],
        //   begin: Alignment.topLeft,
        //   end: Alignment.bottomRight,
        // ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            counter.toString(),
            maxLines: 1,
            style: StyleText.bold(
              100,
            ).copyWith(color: AppColors.white, fontFamily: "Amiri"),
          ),
          Text(
            selectedSabha,
            textAlign: TextAlign.center,
            style: StyleText.bold(
              40,
            ).copyWith(color: AppColors.white, fontFamily: "Amiri"),
          ),
        ],
      ),
    );
  }
}
