import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ramadan_app/core/constants/app_text_style.dart';
import 'package:ramadan_app/core/extensions/context_extensions.dart';
import 'package:ramadan_app/core/extensions/int_extensions.dart';
import 'package:ramadan_app/core/utils/widgets/custom_loading_widget.dart';
import 'package:ramadan_app/features/home/presentation/view_model/prayer_times_cubit/prayper_times_cubit.dart';

import '../widgets/prayer_time_loaded_UI.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const String routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrayerTimesCubit, PrayerTimesState>(
      builder: (context, state) {
        if (state is PrayerTimesLoaded) {
          return PrayerTimeLoadedUI(
            prayerTimes: state.prayerTimes,
            locationName: state.locationName,
          );
        } else if (state is PrayerTimesError) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    state.message == "لا يوجد اتصال بالإنترنت"
                        ? CupertinoIcons.wifi_exclamationmark
                        : Icons.warning_amber_rounded,
                    size: 200.sp,
                    color: context.onPrimaryColor.withAlpha(100),
                  ),
                  50.hSpace,
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: StyleText.bold26().copyWith(
                      color: context.onPrimaryColor.withAlpha(100),
                    ),
                  ),
                  50.hSpace,

                  InkWell(
                    onTap: () async {
                      context.read<PrayerTimesCubit>().fetchPrayerTimes();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 15.h,
                      ),
                      margin: EdgeInsets.symmetric(horizontal: 60.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        color: context.onPrimaryColor.withAlpha(188),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        state.message == "لا يوجد اتصال بالإنترنت"
                            ? "إعادة الاتصال"
                            : "حاول مرة أخرى",
                        textAlign: TextAlign.center,
                        style: StyleText.bold20().copyWith(
                          color: context.backgroundColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Scaffold(body: Center(child: CustomLoadingWidget()));
        }
      },
    );
  }
}
