import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ramadan_app/core/extensions/context_extensions.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_style.dart';

/// Widget for selecting pre-alert time before prayer
class PreAlertSelector extends StatelessWidget {
  const PreAlertSelector({
    super.key,
    required this.selectedMinutes,
    required this.onChanged,
  });

  final int selectedMinutes;
  final ValueChanged<int> onChanged;

  static const List<int> preAlertOptions = [0, 5, 10, 15];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: context.backgroundColor,
        border: Border(
          bottom: BorderSide(
            color: context.onPrimaryColor.withAlpha(30),
            width: 0.5,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            AppStrings.preAlertTime,
            style: StyleText.regular18().copyWith(
              color: context.onPrimaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 6.h),
          // Description
          Text(
            selectedMinutes == 0
                ? AppStrings.noPreAlert
                : '${AppStrings.preAlertDescription} $selectedMinutes ${AppStrings.minutes}',
            style: StyleText.regular14().copyWith(
              color: context.onPrimaryColor.withAlpha(150),
            ),
          ),
          SizedBox(height: 16.h),
          // Options chips
          Row(
            children: preAlertOptions.map((minutes) {
              final isSelected = selectedMinutes == minutes;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: _PreAlertChip(
                    minutes: minutes,
                    isSelected: isSelected,
                    onTap: () => onChanged(minutes),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _PreAlertChip extends StatelessWidget {
  const _PreAlertChip({
    required this.minutes,
    required this.isSelected,
    required this.onTap,
  });

  final int minutes;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.r),
        child: Container(
          height: 44.h,
          decoration: BoxDecoration(
            color: isSelected
                ? context.primaryColor
                : context.primaryColor.withAlpha(20),
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: isSelected
                  ? context.primaryColor
                  : context.primaryColor.withAlpha(50),
              width: 1.5,
            ),
          ),
          child: Center(
            child: Text(
              minutes == 0 ? '0' : '$minutes',
              style: StyleText.semiBold16().copyWith(
                color: isSelected
                    ? Colors.white
                    : context.primaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
