import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ramadan_app/core/constants/app_strings.dart';
import 'package:ramadan_app/features/settings/presentation/veiw/widgets/settings_row_item.dart';

class CustomRowAboutMe extends StatelessWidget {
  const CustomRowAboutMe({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          barrierColor: Colors.black.withOpacity(0.8),
          barrierDismissible: true,
          builder:
              (context) => AlertDialog(
                elevation: 5,
                contentPadding: EdgeInsets.all(20.w),
                title: const Text(
                  AppStrings.aboutApp,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                content: Text(
                  AppStrings.aboutAppContent,
                  style: TextStyle(fontSize: 17.sp),
                ),
              ),
        );
      },
      child: SettingsRowItem(
        title: AppStrings.aboutApp,
        leading: const Icon(Icons.info),
      ),
    );
  }
}
