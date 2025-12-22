import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ramadan_app/core/constants/app_colors.dart';

class CircleColorPaletteWidget extends StatelessWidget {
  final Color color;
  final bool isSelected;
  final Function(Color) onSelect;

  const CircleColorPaletteWidget({
    super.key,
    required this.color,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onSelect(color),
      child: CircleAvatar(
        backgroundColor: color,
        radius: 27.r,
        child: isSelected ? Icon(Icons.check, color: AppColors.white) : null,
      ),
    );
  }
}
