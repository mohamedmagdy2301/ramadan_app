import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  Color selectedColor = Color.fromARGB(255, 99, 136, 3);
  final List<Color> darkColors = [
    Color.fromARGB(255, 99, 136, 3),
    Color.fromARGB(255, 159, 162, 214),
    Color(0xFFba9e72),
    Color(0xFFc195a0),
    Color(0xFF838073),
    Color(0xFF8e9acb),
    Color(0xFFabb270),
  ];

  final List<Color> lightColors = [
    Color.fromARGB(255, 99, 136, 3),
    Color(0xFF9b151d),
    Color(0xFFc66e59),
    Color(0xFF6A994E),
    Color(0xFF0e106d),
    Color(0xFF14213D),
    Color(0xFF496878),
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
                  AdaptiveTheme.of(context).setDark();
                } else {
                  AdaptiveTheme.of(context).setLight();
                }
              },
            ),
          ),
          Container(
            width: double.infinity,
            height: 140.h,
            color:
                context.isDark
                    ? const Color.fromARGB(255, 48, 48, 48)
                    : const Color.fromARGB(255, 218, 218, 218),
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
                const Divider(
                  color: Color.fromARGB(255, 186, 186, 186),
                  thickness: 1,
                  height: 1,
                ),
              ],
            ),
          ),

          CustomRowAboutMe(),
        ],
      ),
    );
  }
}
