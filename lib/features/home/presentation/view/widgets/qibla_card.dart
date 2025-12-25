import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:ramadan_app/core/constants/app_strings.dart';
import 'package:ramadan_app/core/constants/app_text_style.dart';
import 'package:ramadan_app/core/extensions/context_extensions.dart';
import 'package:ramadan_app/core/router/routes.dart';

class QiblaCard extends StatelessWidget {
  const QiblaCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(AppRoutes.qibla),
      child: Semantics(
        label: AppStrings.qiblaCompass,
        button: true,
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                context.primaryColor.withAlpha(30),
                context.primaryColor.withAlpha(15),
              ],
            ),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: context.primaryColor.withAlpha(40),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: context.primaryColor.withAlpha(30),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.explore,
                  color: context.primaryColor,
                  size: 32.sp,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.qiblaCompass,
                      style: StyleText.bold18().copyWith(
                        color: context.onPrimaryColor,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'حدد اتجاه القبلة بسهولة',
                      style: StyleText.regular14().copyWith(
                        color: context.onPrimaryColor.withAlpha(150),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: context.primaryColor.withAlpha(150),
                size: 20.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
