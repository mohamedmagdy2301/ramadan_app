import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ramadan_app/core/constants/app_strings.dart';
import 'package:ramadan_app/core/constants/app_text_style.dart';
import 'package:ramadan_app/core/extensions/context_extensions.dart';

class EmptyFavoritesWidget extends StatelessWidget {
  const EmptyFavoritesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 80.sp,
              color: context.primaryColor.withAlpha(100),
            ),
            SizedBox(height: 24.h),
            Text(
              AppStrings.noFavorites,
              textAlign: TextAlign.center,
              style: StyleText.bold20().copyWith(
                color: context.onPrimaryColor,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              AppStrings.addFavoritesHint,
              textAlign: TextAlign.center,
              style: StyleText.regular14().copyWith(
                color: context.onPrimaryColor.withAlpha(150),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
