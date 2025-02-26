import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ramadan_app/core/constants/app_images.dart';
import 'package:ramadan_app/core/extensions/widget_extensions.dart';

class CustomLoadingWidget extends StatelessWidget {
  const CustomLoadingWidget({super.key, this.width, this.height});
  final double? width, height;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppAssets.loadingGif,
      width: width?.w ?? 50.w,
      height: height?.h ?? 50.h,
    ).center();
  }
}
