import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:ramadan_app/core/extensions/context_extensions.dart';
import 'package:ramadan_app/core/extensions/int_extensions.dart';

import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/constants/app_text_style.dart';
import '../../../data/azkar_screen_body_item_model_data.dart';
import '../screens/azkar_details_screen.dart';
import 'azkar_screen_body_item.dart';

class AzkarScreenBody extends StatelessWidget {
  const AzkarScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AzkarScreenBodyItem(
              azkarScreenBodyItemModel: azkarScreenBodyItemModel[0],
              onTap: () {
                PersistentNavBarNavigator.pushNewScreen(
                  context,
                  screen: AzkarDetailsScreen(
                    azkarScreenBodyItemModel: azkarScreenBodyItemModel[0],
                  ),
                );
              },
            ),
            AzkarScreenBodyItem(
              azkarScreenBodyItemModel: azkarScreenBodyItemModel[1],
              onTap: () {
                PersistentNavBarNavigator.pushNewScreen(
                  context,
                  screen: AzkarDetailsScreen(
                    azkarScreenBodyItemModel: azkarScreenBodyItemModel[1],
                  ),
                );
              },
            ),
            4.hSpace,
            Text(
              AppStrings.azkarMtnwa,
              style: StyleText.bold24().copyWith(color: context.onPrimaryColor),
            ),
            10.hSpace,
            AzkarScreenBodyItem(
              azkarScreenBodyItemModel: azkarScreenBodyItemModel[2],
              onTap: () {
                PersistentNavBarNavigator.pushNewScreen(
                  context,
                  screen: AzkarDetailsScreen(
                    azkarScreenBodyItemModel: azkarScreenBodyItemModel[2],
                  ),
                );
              },
            ),
            AzkarScreenBodyItem(
              azkarScreenBodyItemModel: azkarScreenBodyItemModel[3],
              onTap: () {
                PersistentNavBarNavigator.pushNewScreen(
                  context,
                  screen: AzkarDetailsScreen(
                    azkarScreenBodyItemModel: azkarScreenBodyItemModel[3],
                  ),
                );
              },
            ),
            AzkarScreenBodyItem(
              azkarScreenBodyItemModel: azkarScreenBodyItemModel[4],
              onTap: () {
                PersistentNavBarNavigator.pushNewScreen(
                  context,
                  screen: AzkarDetailsScreen(
                    azkarScreenBodyItemModel: azkarScreenBodyItemModel[4],
                  ),
                );
              },
            ),
            AzkarScreenBodyItem(
              azkarScreenBodyItemModel: azkarScreenBodyItemModel[5],
              onTap: () {
                PersistentNavBarNavigator.pushNewScreen(
                  context,
                  screen: AzkarDetailsScreen(
                    azkarScreenBodyItemModel: azkarScreenBodyItemModel[5],
                  ),
                );
              },
            ),
            AzkarScreenBodyItem(
              azkarScreenBodyItemModel: azkarScreenBodyItemModel[6],
              onTap: () {
                PersistentNavBarNavigator.pushNewScreen(
                  context,
                  screen: AzkarDetailsScreen(
                    azkarScreenBodyItemModel: azkarScreenBodyItemModel[6],
                  ),
                );
              },
            ),
            AzkarScreenBodyItem(
              azkarScreenBodyItemModel: azkarScreenBodyItemModel[7],
              onTap: () {
                PersistentNavBarNavigator.pushNewScreen(
                  context,
                  screen: AzkarDetailsScreen(
                    azkarScreenBodyItemModel: azkarScreenBodyItemModel[7],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
