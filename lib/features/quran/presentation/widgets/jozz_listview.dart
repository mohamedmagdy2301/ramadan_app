import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:quran_library/quran.dart';
import 'package:ramadan_app/core/constants/app_text_style.dart';
import 'package:ramadan_app/core/extensions/context_extensions.dart';
import 'package:ramadan_app/core/extensions/widget_extensions.dart';
import 'package:ramadan_app/features/quran/presentation/pages/surah_screen.dart';

class JozzListViewWidget extends StatelessWidget {
  const JozzListViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final jozzList = QuranLibrary().allJoz;
    final hizbList = QuranLibrary().allHizb;

    return ListView.builder(
      itemCount: jozzList.length,
      itemBuilder: (context, jozzIndex) {
        return Container(
          width: context.W,
          color:
              jozzIndex.isEven
                  ? context.primaryColor.withAlpha(20)
                  : Colors.transparent,
          child: ExpansionTile(
            iconColor: context.onPrimaryColor,
            collapsedIconColor: context.onPrimaryColor,
            title: Text(
              jozzList[jozzIndex],
              style: StyleText.medium20().copyWith(
                color: context.onPrimaryColor,
              ),
            ),
            children: List.generate(2, (index) {
              final hizbIndex = jozzIndex * 2 + index;
              return Column(
                children: [
                  if (index == 0)
                    Divider(
                      height: 1,
                      thickness: .4,
                      color: context.onPrimaryColor.withAlpha(100),
                    ),
                  InkWell(
                    onTap: () {
                      PersistentNavBarNavigator.pushNewScreen(
                        context,
                        withNavBar: false,
                        screen: SurahScreen(),
                      );
                      QuranLibrary().jumpToHizb(hizbIndex + 1);
                    },
                    child: Container(
                      width: context.W,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      color:
                          index.isEven
                              ? context.onPrimaryColor.withAlpha(10)
                              : context.onPrimaryColor.withAlpha(30),
                      child: Text(
                        "◉  ${hizbList[hizbIndex]}",
                        style: StyleText.regular16().copyWith(
                          color: context.onPrimaryColor,
                        ),
                      ).paddingSymmetric(horizontal: 40.w),
                    ),
                  ),
                ],
              );
            }),
          ),
        );
      },
    );
  }
}
