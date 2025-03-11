import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ramadan_app/core/extensions/context_extensions.dart';

import '../../../../../core/constants/app_text_style.dart';
import '../../../../../core/utils/widgets/snakbar/snackbar_helper.dart';
import '../../view_model/notification_manager/azkar_notification_cubit.dart';

class CustomNotificationSettings extends StatelessWidget {
  const CustomNotificationSettings({
    super.key,
    required this.azkarNotificationCubit,
  });
  final AzkarNotificationCubit azkarNotificationCubit;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          color: context.primaryColor.withAlpha(60),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "التنبيهات ",
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w400),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      context.isDark
                          ? const Color.fromARGB(255, 81, 81, 81)
                          : const Color.fromARGB(255, 218, 218, 218),
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: BorderSide(
                      color: Color.fromARGB(255, 153, 153, 153),
                      width: 0.5.w,
                    ),
                  ),
                  elevation: 0,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                ),
                onPressed: () async {
                  await azkarNotificationCubit.onTimeChanged(context);
                },
                child: Text(
                  azkarNotificationCubit.textButton,
                  style: StyleText.regular20().copyWith(
                    color: context.onPrimaryColor,
                  ),
                ),
              ),
              Switch.adaptive(
                inactiveTrackColor: context.onPrimaryColor.withAlpha(100),
                inactiveThumbColor: context.backgroundColor,
                activeTrackColor: context.primaryColor,
                activeColor: context.onPrimaryColor,
                applyCupertinoTheme: true,
                trackOutlineColor: WidgetStateColor.resolveWith(
                  (states) => Colors.transparent,
                ),
                value: azkarNotificationCubit.isSwitchEnable,
                onChanged: (value) {
                  if (azkarNotificationCubit.isSwitchEnable) {
                    azkarNotificationCubit.cancelNotification();
                    showMessage(
                      context,
                      type: SnackBarType.warning,
                      message:
                          'تم الغاء تفعيل اشعارات ${azkarNotificationCubit.azkarScreenBodyItemModel.title}',
                    );
                  } else {
                    showMessage(
                      context,
                      type: SnackBarType.error,
                      message:
                          'اختار الوقت الذي تريد تفعيل اشعارات ${azkarNotificationCubit.azkarScreenBodyItemModel.title}',
                    );
                  }
                },
              ),
            ],
          ),
        ),
        Divider(
          color: context.onPrimaryColor.withAlpha(80),
          thickness: .5.w,
          height: .5.h,
        ),
      ],
    );
  }
}
