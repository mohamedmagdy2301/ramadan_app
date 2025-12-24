import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ramadan_app/core/extensions/context_extensions.dart';
import 'package:ramadan_app/features/sabha/data/models/dhikr_model.dart';

class DhikrSelector extends StatelessWidget {
  final DhikrModel selectedDhikr;
  final ValueChanged<DhikrModel> onDhikrSelected;

  const DhikrSelector({
    super.key,
    required this.selectedDhikr,
    required this.onDhikrSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: DhikrModel.defaultDhikrList.length,
        itemBuilder: (context, index) {
          final dhikr = DhikrModel.defaultDhikrList[index];
          final isSelected = dhikr.id == selectedDhikr.id;

          return Padding(
            padding: EdgeInsets.only(right: 10.w),
            child: DhikrCard(
              dhikr: dhikr,
              isSelected: isSelected,
              onTap: () => onDhikrSelected(dhikr),
            ),
          );
        },
      ),
    );
  }
}

class DhikrCard extends StatelessWidget {
  final DhikrModel dhikr;
  final bool isSelected;
  final VoidCallback onTap;

  const DhikrCard({
    super.key,
    required this.dhikr,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 85.w,
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 6.w),
        decoration: BoxDecoration(
          color: isSelected
              ? dhikr.color.withAlpha(50)
              : context.isDark
                  ? Colors.white.withAlpha(13)
                  : Colors.black.withAlpha(8),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: isSelected ? dhikr.color : Colors.transparent,
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: dhikr.color.withAlpha(77),
                    blurRadius: 10,
                    spreadRadius: 0,
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon with background
            Container(
              width: 28.w,
              height: 28.w,
              decoration: BoxDecoration(
                color: isSelected
                    ? dhikr.color.withAlpha(77)
                    : dhikr.color.withAlpha(26),
                shape: BoxShape.circle,
              ),
              child: Icon(
                dhikr.icon,
                color: isSelected ? dhikr.color : dhikr.color.withAlpha(179),
                size: 16.sp,
              ),
            ),
            SizedBox(height: 6.h),

            // Dhikr text - Flexible to prevent overflow
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  dhikr.text,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    fontFamily: 'Tajawal',
                    color: isSelected
                        ? dhikr.color
                        : context.isDark
                            ? Colors.white70
                            : Colors.black87,
                  ),
                ),
              ),
            ),

            SizedBox(height: 4.h),

            // Target badge
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: dhikr.color.withAlpha(isSelected ? 51 : 26),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                '${dhikr.defaultTarget}',
                style: TextStyle(
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w600,
                  color: dhikr.color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
