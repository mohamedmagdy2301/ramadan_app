import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ramadan_app/core/constants/app_text_style.dart';

class AppDropDownButton extends StatelessWidget {
  const AppDropDownButton({
    super.key,
    required this.hintText,
    required this.onChanged,
    required this.items,
    this.value,
  });

  final String hintText;
  final void Function(String?) onChanged;
  final List<Map<String, String>> items;
  final String? value;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color.fromARGB(0, 163, 162, 162),
      child: DropdownButtonFormField2<String>(
        value: value,
        isDense: true,
        onChanged: onChanged,
        dropdownStyleData: DropdownStyleData(
          maxHeight: 300.h,
          width: 200.w,
          useSafeArea: true,
          padding: EdgeInsets.only(top: 20),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 208, 208, 208),
            border: Border.all(style: BorderStyle.solid),
            borderRadius: BorderRadius.all(Radius.circular(20.r)),
          ),
        ),
        alignment: Alignment.center,
        decoration: secondryFormFieldDecoration(),
        iconStyleData: IconStyleData(iconEnabledColor: Colors.black),
        isExpanded: true,
        hint: Text(
          hintText,
          style: StyleText.medium16().copyWith(
            color: Colors.black,
            height: 1.2,
          ),
        ),
        items:
            items.map((item) {
              return DropdownMenuItem<String>(
                value: item['value'],
                child: Text(
                  item['name']!,
                  style: StyleText.medium16().copyWith(color: Colors.black),
                ),
              );
            }).toList(),
      ),
    );
  }
}

InputDecoration secondryFormFieldDecoration({
  String? hintText,
  Widget? suffixIcon,
  Widget? prefixIcon,
  Color? borderColor,
}) {
  return InputDecoration(
    hintText: hintText,
    hintStyle: StyleText.medium16().copyWith(height: 1.2, color: Colors.grey),
    border: InputBorder.none,
    enabledBorder: InputBorder.none,
    focusedBorder: InputBorder.none,
    filled: false,
    errorBorder: InputBorder.none,
    disabledBorder: InputBorder.none,
    focusedErrorBorder: InputBorder.none,
    contentPadding: const EdgeInsets.all(1).w,
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
  );
}
