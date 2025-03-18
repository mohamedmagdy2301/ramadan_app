import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ramadan_app/core/constants/app_text_style.dart';
import 'package:ramadan_app/core/extensions/context_extensions.dart';
import 'package:ramadan_app/core/extensions/int_extensions.dart' as ext;
import 'package:ramadan_app/core/extensions/widget_extensions.dart';
import 'package:ramadan_app/core/utils/functions/convert_num_to_ar.dart';

class AzkarDetailsLiseviewItemCard extends StatefulWidget {
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
  State<AzkarDetailsLiseviewItemCard> createState() =>
      _AzkarDetailsLiseviewItemCardState();
}

class _AzkarDetailsLiseviewItemCardState
    extends State<AzkarDetailsLiseviewItemCard> {
  bool isAnimating = false; // Animation state

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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: GestureDetector(
        onTap: () {
          widget.onCounterChanged();
          widget.counter ==
                  (int.parse(widget.dataList?[widget.index]["count"] ?? "0"))
              ? () {}
              : animateCircle();
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 150),
          child: Card(
            elevation: 4,
            color:
                context.isDark
                    ? Colors.grey.shade900
                    : const Color.fromARGB(255, 207, 207, 207),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
              side: BorderSide(
                color: context.primaryColor,
                width:
                    isAnimating
                        ? .6.w
                        : widget.counter ==
                            (int.parse(
                              widget.dataList?[widget.index]["count"] ?? "0",
                            ))
                        ? .6.w
                        : 0.1.w,
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 10.h,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.r),
                      topRight: Radius.circular(10.r),
                    ),
                    border: Border.symmetric(
                      vertical: BorderSide(
                        color: context.primaryColor,
                        width: .6.w,
                      ),
                      horizontal: BorderSide(
                        color: context.primaryColor,
                        width: .5.w,
                      ),
                    ),
                    color:
                        context.isDark
                            ? const Color.fromARGB(255, 25, 25, 25)
                            : const Color.fromARGB(255, 225, 225, 225),
                  ),
                  child: Row(
                    children: [
                      Text(
                        "الذكر  ${convertNumberToArabic((widget.index + 1).toString())}",
                        style: StyleText.bold18().copyWith(
                          color:
                              widget.counter ==
                                      (int.parse(
                                        widget.dataList?[widget
                                                .index]["count"] ??
                                            "0",
                                      ))
                                  ? context.primaryColor
                                  : context.onPrimaryColor,
                        ),
                      ),
                      Spacer(),
                      widget.counter ==
                              (int.parse(
                                widget.dataList?[widget.index]["count"] ?? "0",
                              ))
                          ? Icon(
                            Icons.check_circle_outline,
                            color: context.primaryColor,
                          )
                          : Text(
                            "${convertNumberToArabic(removeZeroFromStart(widget.counter.toString()))}  /  ${convertNumberToArabic((widget.dataList?[widget.index]["count"]).toString())}",
                            style: StyleText.extraBold20().copyWith(
                              color: context.onPrimaryColor,
                            ),
                          ),
                      5.wSpace,
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    10.hSpace,
                    Text(
                      widget.dataList?[widget.index]['content'] ?? "",
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
      ),
    );
  }
}

String removeZeroFromStart(String s) {
  if (s.length == 2 && s[0] == "0") {
    s = s[1];
  }
  return s;
}
