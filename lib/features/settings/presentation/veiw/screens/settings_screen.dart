import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ramadan_app/core/constants/app_colors.dart';
import 'package:ramadan_app/core/constants/app_strings.dart';
import 'package:ramadan_app/core/extensions/context_extensions.dart';
import 'package:ramadan_app/core/extensions/widget_extensions.dart';

import '../../../../../core/constants/app_text_style.dart';
import '../../../../../core/theming/app_theme_data.dart';
import '../widgets/appbar_setting.dart';
import '../widgets/circle_color_palette_widget.dart';
import '../widgets/custom_row_about_me.dart';
import '../widgets/settings_row_item.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  static const routeName = '/settings';

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Color selectedColor = AppColors.primary;
  final List<Color> darkColors = [
    AppColors.primary,
    Color.fromARGB(255, 99, 136, 3),
    Color.fromARGB(255, 205, 51, 61),
    Color.fromARGB(255, 195, 107, 107),
    Color.fromARGB(255, 112, 166, 178),
    Color(0xFF838073),
    Color.fromARGB(255, 159, 162, 214),
  ];

  final List<Color> lightColors = [
    AppColors.primary,
    Color.fromARGB(255, 99, 136, 3),
    Color(0xFF9b151d),
    Color(0xFFc66e59),
    Color(0xFF496878),
    Color.fromARGB(255, 120, 115, 73),
    Color(0xFF14213D),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarSettings(),
      body: Column(
        children: [
          SettingsRowItem(
            title: AppStrings.themesMode,
            leading: Switch.adaptive(
              value: AdaptiveTheme.of(context).mode.isDark,
              onChanged: (value) {
                if (value) {
                  selectedColor = darkColors[0];
                  AdaptiveTheme.of(context).setDark();
                  AdaptiveTheme.of(context).setTheme(
                    light: AppThemeData.lightTheme(selectedColor),
                    dark: AppThemeData.darkTheme(selectedColor),
                  );
                } else {
                  selectedColor = lightColors[0];
                  AdaptiveTheme.of(context).setLight();
                  AdaptiveTheme.of(context).setTheme(
                    light: AppThemeData.lightTheme(selectedColor),
                    dark: AppThemeData.darkTheme(selectedColor),
                  );
                }
              },
            ),
          ),
          Container(
            width: double.infinity,
            height: 140.h,
            color: context.backgroundColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.colorPalette,
                  style: StyleText.regular20().copyWith(
                    color: context.onPrimaryColor,
                  ),
                ).paddingSymmetric(horizontal: 10.w, vertical: 10.h),
                ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children:
                      (context.isDark ? darkColors : lightColors)
                          .map(
                            (color) => Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4.w),
                              child: CircleColorPaletteWidget(
                                color: color,
                                isSelected: selectedColor == color,
                                onSelect: (selected) {
                                  setState(() {
                                    selectedColor = selected;
                                    AdaptiveTheme.of(context).setTheme(
                                      light: AppThemeData.lightTheme(selected),
                                      dark: AppThemeData.darkTheme(selected),
                                    );
                                  });
                                },
                              ),
                            ),
                          )
                          .toList(),
                ).expand(),
                Divider(
                  color: context.onPrimaryColor.withAlpha(120),
                  thickness: .5,
                  height: 0,
                ),
              ],
            ),
          ),

          CustomRowAboutMe(),
          Spacer(),
          Text(
            "فَاذْكُرُونِي\n\nأَذْكُرْكُمْ",
            textAlign: TextAlign.center,
            style: StyleText.black(60).copyWith(
              fontFamily: "Noto_Nastaliq_Urdu",
              color: context.primaryColor.withAlpha(30),
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }
}
