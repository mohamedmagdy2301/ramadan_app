import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ramadan_app/core/accessibility/accessibility_settings.dart';
import 'package:ramadan_app/core/constants/app_strings.dart';
import 'package:ramadan_app/core/constants/app_text_style.dart';
import 'package:ramadan_app/core/di/injection_container.dart';
import 'package:ramadan_app/core/extensions/context_extensions.dart';

class FontSizeSelector extends StatefulWidget {
  const FontSizeSelector({super.key});

  @override
  State<FontSizeSelector> createState() => _FontSizeSelectorState();
}

class _FontSizeSelectorState extends State<FontSizeSelector> {
  final AccessibilitySettings _settings = sl<AccessibilitySettings>();

  @override
  void initState() {
    super.initState();
    _settings.addListener(_onSettingsChanged);
  }

  @override
  void dispose() {
    _settings.removeListener(_onSettingsChanged);
    super.dispose();
  }

  void _onSettingsChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      color: context.backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.fontSize,
            style: StyleText.regular18().copyWith(
              color: context.onPrimaryColor,
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: FontScale.values.map((scale) {
              final isSelected = _settings.currentFontScale == scale;
              return Expanded(
                child: GestureDetector(
                  onTap: () => _settings.setFontScale(scale),
                  child: Semantics(
                    label: '${AppStrings.fontSize}: ${scale.arabicName}',
                    selected: isSelected,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 4.w),
                      padding: EdgeInsets.symmetric(
                        vertical: 12.h,
                        horizontal: 8.w,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? context.primaryColor
                            : context.primaryColor.withAlpha(30),
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: context.primaryColor,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Text(
                        scale.arabicName,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12.sp * scale.scale,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected
                              ? Colors.white
                              : context.onPrimaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 8.h),
          Divider(
            color: context.onPrimaryColor.withAlpha(120),
            thickness: .5,
          ),
        ],
      ),
    );
  }
}
