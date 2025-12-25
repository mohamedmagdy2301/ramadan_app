import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:ramadan_app/core/extensions/context_extensions.dart';
import 'package:ramadan_app/core/router/routes.dart';

/// Quick access buttons for common features
class QuickAccessButtons extends StatelessWidget {
  const QuickAccessButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
      decoration: BoxDecoration(
        color: context.isDark
            ? Colors.white.withAlpha(13)
            : context.primaryColor.withAlpha(13),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: context.isDark
              ? Colors.white.withAlpha(26)
              : context.primaryColor.withAlpha(38),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _QuickAccessButton(
            icon: Icons.explore,
            label: 'القبلة',
            color: const Color(0xFF4CAF50),
            onTap: () => context.push(Routes.qibla),
          ),
          _QuickAccessButton(
            icon: Icons.favorite,
            label: 'المفضلة',
            color: const Color(0xFFE91E63),
            onTap: () => context.push(Routes.favorites),
          ),
          _QuickAccessButton(
            icon: Icons.bar_chart,
            label: 'إحصائيات',
            color: const Color(0xFF2196F3),
            onTap: () => context.push(Routes.statistics),
          ),
          _QuickAccessButton(
            icon: Icons.notifications_active,
            label: 'التذكيرات',
            color: const Color(0xFFFF9800),
            onTap: () => context.push(Routes.azkarReminders),
          ),
        ],
      ),
    );
  }
}

class _QuickAccessButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickAccessButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              color: color.withAlpha(26),
              shape: BoxShape.circle,
              border: Border.all(
                color: color.withAlpha(77),
                width: 1.5,
              ),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24.sp,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              fontFamily: 'Tajawal',
              color: context.isDark ? Colors.white70 : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
