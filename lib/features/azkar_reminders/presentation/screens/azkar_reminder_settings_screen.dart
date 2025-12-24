import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ramadan_app/core/extensions/context_extensions.dart';
import 'package:ramadan_app/features/azkar_reminders/data/datasources/azkar_reminder_local_datasource.dart';
import 'package:ramadan_app/features/azkar_reminders/presentation/cubit/azkar_reminder_cubit.dart';
import 'package:ramadan_app/features/azkar_reminders/presentation/cubit/azkar_reminder_state.dart';

/// Screen for configuring azkar reminders
class AzkarReminderSettingsScreen extends StatelessWidget {
  const AzkarReminderSettingsScreen({super.key});

  static const String routeName = '/azkar-reminders';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AzkarReminderCubit(
        localDatasource: AzkarReminderLocalDatasource(),
      )..loadSettings(),
      child: const _AzkarReminderSettingsView(),
    );
  }
}

class _AzkarReminderSettingsView extends StatelessWidget {
  const _AzkarReminderSettingsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'تذكيرات الأذكار',
          style: TextStyle(
            fontFamily: 'Tajawal',
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<AzkarReminderCubit, AzkarReminderState>(
        builder: (context, state) {
          if (state is AzkarReminderLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AzkarReminderError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64.sp,
                    color: Colors.red.withAlpha(128),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 16.sp,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is AzkarReminderLoaded) {
            return _buildSettingsList(context, state);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildSettingsList(BuildContext context, AzkarReminderLoaded state) {
    final cubit = context.read<AzkarReminderCubit>();
    final settings = state.settings;

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Info banner
          _buildInfoBanner(context),
          SizedBox(height: 20.h),

          // Morning Azkar
          _buildSectionTitle(context, 'أذكار الصباح'),
          SizedBox(height: 8.h),
          _buildReminderTile(
            context,
            icon: Icons.wb_sunny,
            iconColor: const Color(0xFFFF9800),
            title: 'تذكير أذكار الصباح',
            subtitle: settings.morningReminderEnabled
                ? 'كل يوم الساعة ${_formatTime(settings.morningReminderTime)}'
                : 'غير مفعل',
            enabled: settings.morningReminderEnabled,
            onToggle: (value) => cubit.toggleMorningReminder(value),
            onTimeTap: settings.morningReminderEnabled
                ? () => _showTimePicker(
                      context,
                      settings.morningReminderTime,
                      (time) => cubit.setMorningReminderTime(time),
                    )
                : null,
          ),
          SizedBox(height: 16.h),

          // Evening Azkar
          _buildSectionTitle(context, 'أذكار المساء'),
          SizedBox(height: 8.h),
          _buildReminderTile(
            context,
            icon: Icons.nights_stay,
            iconColor: const Color(0xFF673AB7),
            title: 'تذكير أذكار المساء',
            subtitle: settings.eveningReminderEnabled
                ? 'كل يوم الساعة ${_formatTime(settings.eveningReminderTime)}'
                : 'غير مفعل',
            enabled: settings.eveningReminderEnabled,
            onToggle: (value) => cubit.toggleEveningReminder(value),
            onTimeTap: settings.eveningReminderEnabled
                ? () => _showTimePicker(
                      context,
                      settings.eveningReminderTime,
                      (time) => cubit.setEveningReminderTime(time),
                    )
                : null,
          ),
          SizedBox(height: 16.h),

          // Sleep Azkar
          _buildSectionTitle(context, 'أذكار النوم'),
          SizedBox(height: 8.h),
          _buildReminderTile(
            context,
            icon: Icons.bedtime,
            iconColor: const Color(0xFF3F51B5),
            title: 'تذكير أذكار النوم',
            subtitle: settings.sleepReminderEnabled
                ? 'كل يوم الساعة ${_formatTime(settings.sleepReminderTime)}'
                : 'غير مفعل',
            enabled: settings.sleepReminderEnabled,
            onToggle: (value) => cubit.toggleSleepReminder(value),
            onTimeTap: settings.sleepReminderEnabled
                ? () => _showTimePicker(
                      context,
                      settings.sleepReminderTime,
                      (time) => cubit.setSleepReminderTime(time),
                    )
                : null,
          ),
          SizedBox(height: 16.h),

          // Istighfar Reminder
          _buildSectionTitle(context, 'تذكير الاستغفار'),
          SizedBox(height: 8.h),
          _buildIstighfarTile(
            context,
            cubit: cubit,
            settings: settings,
          ),
          SizedBox(height: 16.h),

          // Sound settings
          _buildSectionTitle(context, 'إعدادات الصوت'),
          SizedBox(height: 8.h),
          _buildSoundTile(context, cubit, settings),
          SizedBox(height: 24.h),

          // Quick actions
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  context,
                  label: 'تفعيل الكل',
                  icon: Icons.check_circle,
                  color: Colors.green,
                  onTap: cubit.enableAllReminders,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildActionButton(
                  context,
                  label: 'إلغاء الكل',
                  icon: Icons.cancel,
                  color: Colors.red,
                  onTap: cubit.disableAllReminders,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _buildInfoBanner(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: context.primaryColor.withAlpha(26),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: context.primaryColor.withAlpha(51),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: context.primaryColor,
            size: 24.sp,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              'فعّل التذكيرات للحفاظ على أذكارك اليومية',
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 13.sp,
                color: context.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Row(
      children: [
        Container(
          width: 4.w,
          height: 20.h,
          decoration: BoxDecoration(
            color: context.primaryColor,
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          title,
          style: TextStyle(
            fontFamily: 'Tajawal',
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: context.onPrimaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildReminderTile(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool enabled,
    required ValueChanged<bool> onToggle,
    VoidCallback? onTimeTap,
  }) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: context.isDark
            ? Colors.white.withAlpha(13)
            : Colors.black.withAlpha(8),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: enabled
              ? iconColor.withAlpha(77)
              : Colors.transparent,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              color: iconColor.withAlpha(26),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 24.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: context.onPrimaryColor,
                  ),
                ),
                SizedBox(height: 2.h),
                GestureDetector(
                  onTap: onTimeTap,
                  child: Row(
                    children: [
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontFamily: 'Tajawal',
                          fontSize: 12.sp,
                          color: context.isDark
                              ? Colors.white60
                              : Colors.black54,
                        ),
                      ),
                      if (onTimeTap != null) ...[
                        SizedBox(width: 4.w),
                        Icon(
                          Icons.edit,
                          size: 14.sp,
                          color: context.primaryColor,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: enabled,
            onChanged: onToggle,
            activeTrackColor: iconColor.withAlpha(128),
            thumbColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return iconColor;
              }
              return null;
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildIstighfarTile(
    BuildContext context, {
    required AzkarReminderCubit cubit,
    required dynamic settings,
  }) {
    final intervals = [0, 1, 2, 3, 4, 6, 8, 12];
    final intervalLabels = {
      0: 'غير مفعل',
      1: 'كل ساعة',
      2: 'كل ساعتين',
      3: 'كل 3 ساعات',
      4: 'كل 4 ساعات',
      6: 'كل 6 ساعات',
      8: 'كل 8 ساعات',
      12: 'كل 12 ساعة',
    };

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: context.isDark
            ? Colors.white.withAlpha(13)
            : Colors.black.withAlpha(8),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: settings.istighfarReminderEnabled
              ? Colors.teal.withAlpha(77)
              : Colors.transparent,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44.w,
                height: 44.w,
                decoration: BoxDecoration(
                  color: Colors.teal.withAlpha(26),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.repeat,
                  color: Colors.teal,
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'تذكير دوري بالاستغفار',
                      style: TextStyle(
                        fontFamily: 'Tajawal',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: context.onPrimaryColor,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      intervalLabels[settings.istighfarIntervalHours] ?? 'غير مفعل',
                      style: TextStyle(
                        fontFamily: 'Tajawal',
                        fontSize: 12.sp,
                        color: context.isDark
                            ? Colors.white60
                            : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              Switch.adaptive(
                value: settings.istighfarReminderEnabled,
                onChanged: (value) => cubit.toggleIstighfarReminder(value),
                activeTrackColor: Colors.teal.withAlpha(128),
                thumbColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return Colors.teal;
                  }
                  return null;
                }),
              ),
            ],
          ),
          if (settings.istighfarReminderEnabled) ...[
            SizedBox(height: 12.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: intervals.where((i) => i > 0).map((interval) {
                final isSelected = settings.istighfarIntervalHours == interval;
                return GestureDetector(
                  onTap: () => cubit.setIstighfarInterval(interval),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.teal.withAlpha(51)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: isSelected
                            ? Colors.teal
                            : context.isDark
                                ? Colors.white24
                                : Colors.black26,
                      ),
                    ),
                    child: Text(
                      intervalLabels[interval]!,
                      style: TextStyle(
                        fontFamily: 'Tajawal',
                        fontSize: 12.sp,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isSelected
                            ? Colors.teal
                            : context.onPrimaryColor,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSoundTile(
    BuildContext context,
    AzkarReminderCubit cubit,
    dynamic settings,
  ) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: context.isDark
            ? Colors.white.withAlpha(13)
            : Colors.black.withAlpha(8),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              color: context.primaryColor.withAlpha(26),
              shape: BoxShape.circle,
            ),
            child: Icon(
              settings.soundEnabled
                  ? Icons.volume_up
                  : Icons.volume_off,
              color: context.primaryColor,
              size: 24.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'صوت التذكيرات',
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: context.onPrimaryColor,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  settings.soundEnabled ? 'مفعل' : 'صامت',
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: 12.sp,
                    color: context.isDark
                        ? Colors.white60
                        : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: settings.soundEnabled,
            onChanged: (value) => cubit.toggleSound(value),
            activeTrackColor: context.primaryColor.withAlpha(128),
            thumbColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return context.primaryColor;
              }
              return null;
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withAlpha(26),
        foregroundColor: color,
        elevation: 0,
        padding: EdgeInsets.symmetric(vertical: 12.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
          side: BorderSide(color: color.withAlpha(77)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20.sp),
          SizedBox(width: 8.w),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showTimePicker(
    BuildContext context,
    TimeOfDay initialTime,
    ValueChanged<TimeOfDay> onTimeSelected,
  ) async {
    final time = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
    );
    if (time != null) {
      onTimeSelected(time);
    }
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'ص' : 'م';
    return '$hour:$minute $period';
  }
}
