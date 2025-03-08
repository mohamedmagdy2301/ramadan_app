import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ramadan_app/core/constants/app_strings.dart';
import 'package:ramadan_app/core/constants/app_text_style.dart';
import 'package:ramadan_app/core/extensions/context_extensions.dart';
import 'package:ramadan_app/core/extensions/widget_extensions.dart';
import 'package:ramadan_app/core/utils/functions/convert_num_to_ar.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/local_storage/shared_preferences_manager.dart';
import '../widgets/sabha_screen_body_circle.dart';

class SabhaScreen extends StatefulWidget {
  const SabhaScreen({super.key});
  static const String routeName = '/sabha';

  @override
  State<SabhaScreen> createState() => _SabhaScreenState();
}

class _SabhaScreenState extends State<SabhaScreen> {
  int counter = SharedPreferencesManager.getData(key: 'counter') ?? 0;
  String selectedSabha = "سبحان الله";
  bool isAnimating = false; // Animation state

  final List<String> sabhaTypes = [
    "سبحان الله",
    "الحمد لله",
    "الله أكبر",
    "لا إله إلا الله",
    "سبحان الله وبحمده",
    "سبحان الله العظيم",
    "أستغفر الله",
  ];

  void incrementCounter() {
    setState(() {
      counter++;
      SharedPreferencesManager.setData(key: 'counter', value: counter);
    });
  }

  void clearCounter() {
    setState(() {
      counter = 0;
      SharedPreferencesManager.setData(key: 'counter', value: counter);
    });
  }

  void animateCircle() {
    setState(() {
      isAnimating = true;
    });

    Future.delayed(Duration(milliseconds: 150), () {
      setState(() {
        isAnimating = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body:
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
                padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 10.h),
                decoration: BoxDecoration(
                  border: Border.all(color: context.primaryColor, width: .8.w),
                  color: context.primaryColor.withAlpha(40),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: DropdownButton<String>(
                  value: selectedSabha,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedSabha = newValue!;
                      clearCounter();
                    });
                  },
                  items:
                      sabhaTypes.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: StyleText.extraBold20().copyWith(
                              color: context.onPrimaryColor,
                            ),
                          ),
                        );
                      }).toList(),
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: context.onPrimaryColor,
                    size: 33.sp,
                  ),
                  dropdownColor: context.primaryColor.withAlpha(100),
                  isExpanded: true,
                  elevation: 0,
                ),
              ),
              Spacer(),
              Text(
                counter == 0
                    ? "اضغط على الدائرة لبدء السبحة..."
                    : convertNumberToArabic(counter.toString()),
                maxLines: 1,
                textAlign: TextAlign.center,
                style: StyleText.bold(
                  counter == 0
                      ? 28.sp
                      : counter.toString().length <= 2
                      ? 180.sp
                      : counter.toString().length <= 3
                      ? 150.sp
                      : 90.sp,
                ).copyWith(color: context.primaryColor, fontFamily: "Amiri"),
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  incrementCounter();
                  animateCircle();
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 50.h),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 150),
                    width: isAnimating ? 200.w : 180.w, // Expanding effect
                    height: isAnimating ? 200.w : 180.w,
                    child: SabhaScreenBodyCircle(
                      counter: counter,
                      selectedSabha: selectedSabha,
                    ),
                  ),
                ),
              ),
            ],
          ).center(),
    );
  }

  AppBar appBar() {
    return AppBar(
      title: Text(
        AppStrings.sabha,
        style: StyleText.bold36().copyWith(color: AppColors.white),
      ),
      centerTitle: true,
      flexibleSpace: Container(),
      elevation: 4,
      toolbarHeight: 80.h,
      backgroundColor: context.primaryColor.withAlpha(200),
      actions: [
        counter != 0
            ? IconButton(
              onPressed: () => clearCounter(),
              icon: Icon(Icons.refresh, color: AppColors.white, size: 30.sp),
              tooltip: 'اعادة تعيين العداد',
            )
            : SizedBox(),
      ],
    );
  }
}
