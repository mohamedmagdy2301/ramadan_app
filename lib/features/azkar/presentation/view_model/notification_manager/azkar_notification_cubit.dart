// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ramadan_app/core/extensions/context_extensions.dart';
import 'package:ramadan_app/core/local_storage/shared_preferences_manager.dart';
import 'package:ramadan_app/core/notification_helper/local_notification_manager.dart';
import 'package:ramadan_app/core/utils/widgets/snakbar/snackbar_helper.dart';

import '../../../data/azkar_screen_body_item_model_data.dart';

part 'azkar_notification_state.dart';

class AzkarNotificationCubit extends Cubit<AzkarNotificationState> {
  AzkarNotificationCubit(this.azkarScreenBodyItemModel)
    : super(NoHasAzkarNotification()) {
    timeOfDay0 = getTimeFromPreferences();
    isSwitchEnable = getSwitchIsEnableFromPreferences();
    textButton = getTextButtonFromPreferences();
    isViewNotification = getIsViewNotificationFromPreferences();
  }

  late TimeOfDay timeOfDay0;
  late TimeOfDay? selectedTime;
  final AzkarScreenBodyItemModel azkarScreenBodyItemModel;
  late String textButton;
  late bool isSwitchEnable, isViewNotification;

  viewSettingsNotification(BuildContext context) async {
    isViewNotification = !isViewNotification;
    saveIsViewNotification(isViewNotification);
    emit(ViewNotification());
  }

  onTimeChanged(BuildContext context) async {
    selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: DateTime.now().hour,
        minute: DateTime.now().minute + 1,
      ),

      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme(
              brightness: context.isDark ? Brightness.dark : Brightness.light,
              primary: context.primaryColor,
              onSurface: context.onPrimaryColor,
              onPrimary: context.onPrimaryColor,
              surface: context.backgroundColor,
              error: Colors.red,
              onError: Colors.red,
              secondary: context.primaryColor.withAlpha(100),
              onSecondary: context.onPrimaryColor.withAlpha(100),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: context.primaryColor,
                backgroundColor: context.backgroundColor,
              ),
            ),
          ),
          child: child!,
        );
      },
      initialEntryMode: TimePickerEntryMode.input,
    );

    if (selectedTime != null &&
        selectedTime!.hour >= DateTime.now().hour &&
        selectedTime!.minute > DateTime.now().minute) {
      timeOfDay0 = selectedTime!;
      await saveTimeNotification(timeOfDay0);

      // !Canceling the previous notification
      await LocalNotificationService.cancelNotificationById(
        azkarScreenBodyItemModel.id,
      );

      //! Scheduling the notification
      await LocalNotificationService.showDailyScheduledNotification(
        id: azkarScreenBodyItemModel.id,
        title: azkarScreenBodyItemModel.title,
        body: "موعد ${azkarScreenBodyItemModel.title}",
        selectedHour: timeOfDay0.hour,
        selectedMinute: timeOfDay0.minute,
      );

      //! Updating the UI
      isSwitchEnable = true;
      saveSwitchIsEnableNotification(isSwitchEnable);
      textButton = timeOfDay0.format(context).toString();
      saveTextButtonNotification(textButton);

      // ! Show SnackBar
      showMessage(
        context,
        type: SnackBarType.success,
        message: 'تم تفعيل اشعارات ${azkarScreenBodyItemModel.title}',
      );

      emit(
        HasAzkarNotification(
          isSwitchEnable: isSwitchEnable,
          textButton: textButton,
        ),
      );
    } else {
      // ! Show SnackBar
      showMessage(
        context,
        type: SnackBarType.error,
        message:
            'الوقت غير صالح لتفعيل الاشعارات\nالرجاء اختيار موعد فى المستقبل',
      );

      emit(
        HasAzkarNotification(
          isSwitchEnable: isSwitchEnable,
          textButton: textButton,
        ),
      );
    }
  }

  // Method to cancel notifications
  cancelNotification() async {
    isSwitchEnable = false;
    await saveSwitchIsEnableNotification(isSwitchEnable);
    textButton = "اختيار موعد";
    await saveTextButtonNotification(textButton);
    // !Canceling the previous notification
    await LocalNotificationService.cancelNotificationById(
      azkarScreenBodyItemModel.id,
    );
    emit(NoHasAzkarNotification());
  }

  saveTextButtonNotification(text) async {
    await SharedPreferencesManager.setData(
      key: 'text_button_${azkarScreenBodyItemModel.id}',
      value: text,
    );
  }

  saveSwitchIsEnableNotification(isEnable) async {
    await SharedPreferencesManager.setData(
      key: 'switch_${azkarScreenBodyItemModel.id}_isEnable',
      value: isEnable,
    );
  }

  saveTimeNotification(timeOfDay) async {
    await SharedPreferencesManager.setData(
      key: 'notification_${azkarScreenBodyItemModel.id}_hour',
      value: timeOfDay.hour,
    );
    await SharedPreferencesManager.setData(
      key: 'notification_${azkarScreenBodyItemModel.id}_minute',
      value: timeOfDay.minute,
    );
  }

  saveIsViewNotification(isView) async {
    await SharedPreferencesManager.setData(
      key: 'is_view_notification_${azkarScreenBodyItemModel.id}',
      value: isView,
    );
  }

  bool getIsViewNotificationFromPreferences() {
    return SharedPreferencesManager.getData(
          key: 'is_view_notification_${azkarScreenBodyItemModel.id}',
        ) ??
        false;
  }

  TimeOfDay getTimeFromPreferences() {
    final hour = SharedPreferencesManager.getData(
      key: 'notification_${azkarScreenBodyItemModel.id}_hour',
    );
    final minute = SharedPreferencesManager.getData(
      key: 'notification_${azkarScreenBodyItemModel.id}_minute',
    );
    if (hour != null && minute != null) {
      return TimeOfDay(hour: hour, minute: minute);
    }
    return TimeOfDay.now();
  }

  String getTextButtonFromPreferences() {
    return SharedPreferencesManager.getData(
          key: 'text_button_${azkarScreenBodyItemModel.id}',
        ) ??
        "اختيار موعد";
  }

  bool getSwitchIsEnableFromPreferences() {
    return SharedPreferencesManager.getData(
          key: 'switch_${azkarScreenBodyItemModel.id}_isEnable',
        ) ??
        false;
  }
}
