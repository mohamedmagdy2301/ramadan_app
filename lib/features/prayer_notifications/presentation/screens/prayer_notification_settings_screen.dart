import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ramadan_app/core/extensions/context_extensions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_style.dart';
import '../../../home/presentation/view_model/prayer_times_cubit/prayer_times_cubit.dart';
import '../../data/datasources/prayer_notification_local_datasource.dart';
import '../../domain/entities/adhan_sound.dart';
import '../../domain/entities/prayer_notification_settings.dart';
import '../cubit/prayer_notification_cubit.dart';
import '../cubit/prayer_notification_state.dart';
import '../widgets/adhan_sound_selector.dart';
import '../widgets/prayer_notification_tile.dart';
import '../widgets/pre_alert_selector.dart';

/// Screen for managing prayer notification settings
class PrayerNotificationSettingsScreen extends StatelessWidget {
  const PrayerNotificationSettingsScreen({super.key});

  static const routeName = '/prayer-notification-settings';

  static Route<void> route() {
    return MaterialPageRoute(
      builder: (context) => FutureBuilder<SharedPreferences>(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return BlocProvider(
            create: (context) => PrayerNotificationCubit(
              localDatasource: PrayerNotificationLocalDatasourceImpl(
                sharedPreferences: snapshot.data!,
              ),
            )..loadSettings(),
            child: const PrayerNotificationSettingsScreen(),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.prayerNotificationsSettings,
          style: StyleText.semiBold18().copyWith(
            color: context.onPrimaryColor,
          ),
        ),
        centerTitle: true,
        backgroundColor: context.backgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: context.onPrimaryColor),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: context.onPrimaryColor),
            onSelected: (value) => _handleMenuAction(context, value),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'enable_all',
                child: Row(
                  children: [
                    Icon(Icons.notifications_active,
                        color: context.primaryColor, size: 20),
                    SizedBox(width: 10.w),
                    Text(AppStrings.enableAllPrayers),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'disable_all',
                child: Row(
                  children: [
                    Icon(Icons.notifications_off,
                        color: Colors.grey, size: 20),
                    SizedBox(width: 10.w),
                    Text(AppStrings.disableAllPrayers),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: BlocConsumer<PrayerNotificationCubit, PrayerNotificationState>(
        listener: (context, state) {
          if (state is PrayerNotificationLoaded && state.message != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message!),
                backgroundColor: context.primaryColor,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
          if (state is PrayerNotificationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is PrayerNotificationLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is PrayerNotificationError && state.settings == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline,
                      size: 48, color: context.onPrimaryColor.withAlpha(100)),
                  SizedBox(height: 16.h),
                  Text(
                    state.message,
                    style: StyleText.regular16().copyWith(
                      color: context.onPrimaryColor.withAlpha(150),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: () {
                      context.read<PrayerNotificationCubit>().loadSettings();
                    },
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            );
          }

          final settings = _getSettings(state);
          if (settings == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final isScheduling = state is PrayerNotificationScheduling;
          final isScheduled = state is PrayerNotificationLoaded &&
              state.notificationsScheduled;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status banner
                _StatusBanner(
                  isScheduled: isScheduled,
                  isScheduling: isScheduling,
                  onSchedule: () => _scheduleNotifications(context),
                ),

                SizedBox(height: 16.h),

                // Section title - Prayer toggles
                _SectionTitle(title: 'الصلوات'),

                // Prayer notification tiles
                ...PrayerType.values.map((prayer) => PrayerNotificationTile(
                      prayerType: prayer,
                      isEnabled: settings.isPrayerEnabled(prayer),
                      onToggle: (enabled) {
                        context
                            .read<PrayerNotificationCubit>()
                            .togglePrayerNotification(prayer, enabled);
                      },
                    )),

                SizedBox(height: 24.h),

                // Section title - Pre-alert
                _SectionTitle(title: AppStrings.preAlertTime),

                // Pre-alert selector
                PreAlertSelector(
                  selectedMinutes: settings.preAlertMinutes,
                  onChanged: (minutes) {
                    context
                        .read<PrayerNotificationCubit>()
                        .setPreAlertMinutes(minutes);
                  },
                ),

                SizedBox(height: 24.h),

                // Section title - Sound settings
                _SectionTitle(title: AppStrings.soundSettings),

                // Adhan sound selector
                AdhanSoundSelector(
                  selectedAdhan: AdhanSound.fromString(settings.selectedAdhan),
                  soundEnabled: settings.soundEnabled,
                  onAdhanChanged: (adhan) {
                    context
                        .read<PrayerNotificationCubit>()
                        .setSelectedAdhan(adhan?.name);
                  },
                  onSoundEnabledChanged: (enabled) {
                    context
                        .read<PrayerNotificationCubit>()
                        .toggleSound(enabled);
                  },
                ),

                SizedBox(height: 32.h),

                // Schedule button
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50.h,
                    child: ElevatedButton(
                      onPressed: isScheduling
                          ? null
                          : () => _scheduleNotifications(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: isScheduling
                          ? SizedBox(
                              height: 24.h,
                              width: 24.w,
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              AppStrings.scheduleNow,
                              style: StyleText.semiBold16().copyWith(
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ),

                SizedBox(height: 24.h),
              ],
            ),
          );
        },
      ),
    );
  }

  PrayerNotificationSettings? _getSettings(PrayerNotificationState state) {
    if (state is PrayerNotificationLoaded) return state.settings;
    if (state is PrayerNotificationScheduling) return state.settings;
    if (state is PrayerNotificationError) return state.settings;
    return null;
  }

  void _handleMenuAction(BuildContext context, String action) {
    final cubit = context.read<PrayerNotificationCubit>();
    switch (action) {
      case 'enable_all':
        cubit.enableAllPrayers();
        break;
      case 'disable_all':
        cubit.disableAllPrayers();
        break;
    }
  }

  void _scheduleNotifications(BuildContext context) {
    try {
      final prayerTimesCubit = context.read<PrayerTimesCubit>();
      final prayerTimesState = prayerTimesCubit.state;

      if (prayerTimesState is PrayerTimesLoaded &&
          prayerTimesState.prayerTimes.isNotEmpty) {
        context.read<PrayerNotificationCubit>().scheduleNotifications(
              prayerTimesState.prayerTimes.first,
            );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('يرجى الانتظار حتى يتم تحميل مواقيت الصلاة'),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('يرجى تحميل مواقيت الصلاة أولاً من الصفحة الرئيسية'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Text(
        title,
        style: StyleText.semiBold14().copyWith(
          color: context.primaryColor,
        ),
      ),
    );
  }
}

class _StatusBanner extends StatelessWidget {
  const _StatusBanner({
    required this.isScheduled,
    required this.isScheduling,
    required this.onSchedule,
  });

  final bool isScheduled;
  final bool isScheduling;
  final VoidCallback onSchedule;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isScheduled
            ? Colors.green.withAlpha(25)
            : Colors.orange.withAlpha(25),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isScheduled
              ? Colors.green.withAlpha(100)
              : Colors.orange.withAlpha(100),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isScheduled
                ? Icons.check_circle_rounded
                : Icons.schedule_rounded,
            color: isScheduled ? Colors.green : Colors.orange,
            size: 28.sp,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isScheduled
                      ? AppStrings.notificationsScheduled
                      : AppStrings.notificationsNotScheduled,
                  style: StyleText.semiBold14().copyWith(
                    color: isScheduled ? Colors.green : Colors.orange,
                  ),
                ),
                if (!isScheduled) ...[
                  SizedBox(height: 4.h),
                  Text(
                    'اضغط على "جدولة الآن" لتفعيل الإشعارات',
                    style: StyleText.regular12().copyWith(
                      color: context.onPrimaryColor.withAlpha(150),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
