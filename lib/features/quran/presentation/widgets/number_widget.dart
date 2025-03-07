import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ramadan_app/core/constants/app_text_style.dart';
import 'package:ramadan_app/core/extensions/context_extensions.dart';

import '../../../../core/constants/app_images.dart';
import '../../../../core/utils/functions/convert_num_to_ar.dart';

class NumberWidget extends StatelessWidget {
  const NumberWidget({super.key, required this.num});

  final int num;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 41.h,
      width: 30.w,
      child: Stack(
        children: [
          Positioned(
            child: ImageIcon(
              size: 50.r,
              color: context.onPrimaryColor.withAlpha(200),

              AssetImage(AppAssets.sura),
            ),
          ),
          num <= 9
              ? Positioned(
                left: 10.w,
                top: 5.h,
                child: Text(
                  convertNumberToArabic(num.toString()),
                  style: StyleText.semiBold16().copyWith(
                    fontFamily: 'Noto_Nastaliq_Urdu',
                    color: context.onPrimaryColor.withAlpha(200),
                  ),
                ),
              )
              : num <= 99 && num >= 10
              ? Positioned(
                left: 6.w,
                top: 6.h,
                child: Text(
                  convertNumberToArabic(num.toString()),
                  style: StyleText.semiBold(15).copyWith(
                    fontFamily: 'Noto_Nastaliq_Urdu',
                    color: context.onPrimaryColor.withAlpha(200),
                  ),
                ),
              )
              : Positioned(
                left: 4.w,
                top: 9.h,
                child: Text(
                  convertNumberToArabic(num.toString()),
                  style: StyleText.semiBold(12).copyWith(
                    fontFamily: 'Noto_Nastaliq_Urdu',
                    color: context.onPrimaryColor.withAlpha(200),
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
