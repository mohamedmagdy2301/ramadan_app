import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ramadan_app/core/constants/app_text_style.dart';
import 'package:ramadan_app/core/extensions/context_extensions.dart';
import 'package:ramadan_app/core/extensions/int_extensions.dart';
import 'package:ramadan_app/core/extensions/widget_extensions.dart';

class AzkarDetailsLiseviewItemCard extends StatelessWidget {
  final int index;
  final List<Map<String, String>>? dataList;
  final int counter;
  final VoidCallback onCounterChanged;

  const AzkarDetailsLiseviewItemCard({
    super.key,
    required this.index,
    required this.dataList,
    required this.counter,
    required this.onCounterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.h),
      child: GestureDetector(
        onTap: onCounterChanged,
        child: Card(
          elevation: 4,
          color:
              !context.isDark
                  ? const Color.fromARGB(255, 207, 207, 207)
                  : Colors.grey.shade900,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Container(
                height: 50.h,
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.r),
                    topRight: Radius.circular(10.r),
                  ),
                  color:
                      !context.isDark
                          ? const Color.fromARGB(255, 225, 225, 225)
                          : const Color.fromARGB(255, 68, 68, 68),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "الذكر ${index + 1}",
                      style: StyleText.bold18().copyWith(
                        color: context.onPrimaryColor,
                      ),
                    ),
                    counter == (int.parse(dataList?[index]["count"] ?? "0"))
                        ? Icon(
                          Icons.check_circle_outline,
                          color: context.onPrimaryColor,
                        )
                        : Text(
                          "التكرار : $counter / ${dataList?[index]["count"]}",
                          style: StyleText.bold18().copyWith(
                            color: context.onPrimaryColor,
                          ),
                        ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  10.hSpace,
                  Text(
                    dataList?[index]['content'] ?? "",
                    style: StyleText.regular26().copyWith(
                      height: 2.h,
                      wordSpacing: 2.w,
                      fontFamily: "Amiri",
                      color: context.onPrimaryColor,
                    ),
                  ),
                ],
              ).paddingSymmetric(horizontal: 16, vertical: 15),
            ],
          ),
        ),
      ),
    );
  }
}
