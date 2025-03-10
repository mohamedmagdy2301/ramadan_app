import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ramadan_app/core/constants/app_colors.dart';
import 'package:ramadan_app/core/constants/app_text_style.dart';

import '../../../data/azkar_screen_body_item_model_data.dart';

class AzkarScreenBodyItem extends StatelessWidget {
  const AzkarScreenBodyItem({
    super.key,
    required this.azkarScreenBodyItemModel,
    this.onTap,
  });
  final AzkarScreenBodyItemModel azkarScreenBodyItemModel;

  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        alignment: Alignment.centerRight,
        margin: EdgeInsets.symmetric(vertical: 7.h),
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 38.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.r)),
          image: DecorationImage(
            image: AssetImage(azkarScreenBodyItemModel.image),
            fit: BoxFit.fill,
            // opacity: 0.5,
            colorFilter: const ColorFilter.mode(
              Color.fromARGB(122, 38, 38, 38),
              BlendMode.darken,
            ),
          ),
        ),
        child: Text(
          azkarScreenBodyItemModel.title,
          style: StyleText.medium20().copyWith(color: AppColors.white),
        ),
      ),
    );
  }
}
