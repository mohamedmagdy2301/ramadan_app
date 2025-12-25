import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ramadan_app/core/constants/app_colors.dart';
import 'package:ramadan_app/core/extensions/context_extensions.dart';
import 'package:ramadan_app/features/sabha/presentation/view/widgets/animated_background.dart';
import 'package:ramadan_app/features/sabha/presentation/view/widgets/celebration_overlay.dart';
import 'package:ramadan_app/features/sabha/presentation/view/widgets/dhikr_counter_circle.dart';
import 'package:ramadan_app/features/sabha/presentation/view/widgets/dhikr_selector.dart';
import 'package:ramadan_app/features/sabha/presentation/view/widgets/target_selector.dart';
import 'package:ramadan_app/features/sabha/presentation/view_model/sabha_cubit.dart';
import 'package:ramadan_app/features/sabha/presentation/view_model/sabha_state.dart';

class SabhaScreen extends StatefulWidget {
  const SabhaScreen({super.key});
  static const String routeName = '/sabha';

  @override
  State<SabhaScreen> createState() => _SabhaScreenState();
}

class _SabhaScreenState extends State<SabhaScreen> {
  late SabhaCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = SabhaCubit()..initialize();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocBuilder<SabhaCubit, SabhaState>(
        builder: (context, state) {
          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: _buildAppBar(context, state),
            body: Stack(
              children: [
                // Animated background
                AnimatedBackground(
                  primaryColor: state.selectedDhikr.color,
                  isDark: context.isDark,
                  child: SafeArea(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final isSmallScreen = constraints.maxHeight < 600;

                        return Column(
                          children: [
                            SizedBox(height: isSmallScreen ? 10.h : 16.h),

                            // Selected dhikr display
                            _buildSelectedDhikrDisplay(context, state),

                            SizedBox(height: isSmallScreen ? 8.h : 12.h),

                            // Target selector
                            TargetSelector(
                              currentTarget: state.target,
                              color: state.selectedDhikr.color,
                              onTargetChanged: _cubit.setTarget,
                            ),

                            // Main counter circle
                            Expanded(
                              child: Center(
                                child: DhikrCounterCircle(
                                  counter: state.counter,
                                  progress: state.progress,
                                  color: state.selectedDhikr.color,
                                  target: state.target,
                                  isAnimating: state.isAnimating,
                                  onTap: _cubit.increment,
                                  dhikrText: state.selectedDhikr.text,
                                ),
                              ),
                            ),

                            // Dhikr selector section
                            _buildSectionTitle(context, 'اختر الذكر'),
                            SizedBox(height: 6.h),
                            DhikrSelector(
                              selectedDhikr: state.selectedDhikr,
                              onDhikrSelected: _cubit.selectDhikr,
                            ),

                            SizedBox(height: isSmallScreen ? 12.h : 20.h),
                          ],
                        );
                      },
                    ),
                  ),
                ),

                // Celebration overlay
                CelebrationOverlay(
                  isVisible: state.showCelebration,
                  primaryColor: state.selectedDhikr.color,
                  targetReached: state.target.value,
                  onDismiss: _cubit.dismissCelebration,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, SabhaState state) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      toolbarHeight: 50.h,
      title: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.brightness_7,
              color: state.selectedDhikr.color,
              size: 22.sp,
            ),
            SizedBox(width: 6.w),
            Text(
              'السبحة',
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                fontFamily: 'Tajawal',
                color: context.isDark ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
      ),
      actions: [
        // Sound toggle
        IconButton(
          onPressed: _cubit.toggleSound,
          icon: Icon(
            state.soundEnabled ? Icons.volume_up : Icons.volume_off,
            color: context.isDark ? Colors.white70 : Colors.black54,
            size: 22.sp,
          ),
          tooltip: state.soundEnabled ? 'كتم الصوت' : 'تفعيل الصوت',
        ),

        // Reset button
        if (state.counter > 0)
          IconButton(
            onPressed: () => _showResetDialog(context),
            icon: Icon(
              Icons.refresh,
              color: context.isDark ? Colors.white70 : Colors.black54,
              size: 22.sp,
            ),
            tooltip: 'إعادة تعيين',
          ),

        SizedBox(width: 4.w),
      ],
    );
  }

  Widget _buildSelectedDhikrDisplay(BuildContext context, SabhaState state) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            state.selectedDhikr.color.withAlpha(38),
            state.selectedDhikr.color.withAlpha(13),
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: state.selectedDhikr.color.withAlpha(77),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              state.selectedDhikr.text,
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                fontFamily: 'Amiri',
                color: state.selectedDhikr.color,
              ),
            ),
          ),
          SizedBox(height: 2.h),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              state.selectedDhikr.subtitle,
              style: TextStyle(
                fontSize: 12.sp,
                fontFamily: 'Poppins',
                color: context.isDark ? Colors.white60 : Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: [
          Container(
            width: 3.w,
            height: 16.h,
            decoration: BoxDecoration(
              color: context.primaryColor,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(width: 6.w),
          Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              fontFamily: 'Tajawal',
              color: context.isDark ? Colors.white70 : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: AppColors.red,
              size: 24.sp,
            ),
            SizedBox(width: 8.w),
            Flexible(
              child: Text(
                'إعادة تعيين',
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          'هل تريد إعادة تعيين العداد؟',
          style: TextStyle(
            fontFamily: 'Tajawal',
            fontSize: 14.sp,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'إلغاء',
              style: TextStyle(
                fontFamily: 'Tajawal',
                color: Colors.grey,
                fontSize: 14.sp,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _cubit.reset();
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            ),
            child: Text(
              'إعادة تعيين',
              style: TextStyle(
                fontFamily: 'Tajawal',
                color: Colors.white,
                fontSize: 14.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
