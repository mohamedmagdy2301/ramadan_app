import 'package:flutter/cupertino.dart';
import 'package:ramadan_app/core/extensions/context_extensions.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../view_model/notification_manager/azkar_notification_cubit.dart';

class CustomIconBell extends StatelessWidget {
  const CustomIconBell({super.key, required this.azkarNotificationCubit});

  final AzkarNotificationCubit azkarNotificationCubit;

  @override
  Widget build(BuildContext context) {
    return Icon(
      azkarNotificationCubit.isViewNotification
          ? azkarNotificationCubit.isSwitchEnable
              ? CupertinoIcons.bell_fill
              : CupertinoIcons.bell_slash
          : azkarNotificationCubit.isSwitchEnable
          ? CupertinoIcons.bell_fill
          : CupertinoIcons.bell_slash,
      color:
          azkarNotificationCubit.isViewNotification
              ? azkarNotificationCubit.isSwitchEnable
                  ? context.primaryColor
                  : AppColors.grey
              : azkarNotificationCubit.isSwitchEnable
              ? context.primaryColor
              : AppColors.grey,
    );
  }
}
