import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ramadan_app/core/extensions/context_extensions.dart';
import 'package:ramadan_app/features/sabha/data/models/dhikr_model.dart';

class TargetSelector extends StatelessWidget {
  final SabhaTarget currentTarget;
  final Color color;
  final ValueChanged<SabhaTarget> onTargetChanged;

  const TargetSelector({
    super.key,
    required this.currentTarget,
    required this.color,
    required this.onTargetChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        itemCount: SabhaTarget.values.length,
        itemBuilder: (context, index) {
          final target = SabhaTarget.values[index];
          final isSelected = target == currentTarget;

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: GestureDetector(
              onTap: () => onTargetChanged(target),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? color.withAlpha(51)
                      : context.isDark
                          ? Colors.white.withAlpha(13)
                          : Colors.black.withAlpha(8),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: isSelected ? color : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      target.arabicLabel,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        fontFamily: 'Amiri',
                        color: isSelected
                            ? color
                            : context.isDark
                                ? Colors.white70
                                : Colors.black87,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
