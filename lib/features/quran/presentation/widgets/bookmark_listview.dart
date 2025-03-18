import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:quran_library/quran.dart';
import 'package:ramadan_app/core/constants/app_text_style.dart';
import 'package:ramadan_app/core/extensions/context_extensions.dart';
import 'package:ramadan_app/features/quran/presentation/pages/surah_screen.dart';

class BookMarkListViewWidget extends StatelessWidget {
  const BookMarkListViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ...BookmarksCtrl.instance.bookmarks.entries.map((entry) {
          final colorCode = entry.key;
          final bookmarks = entry.value;
          return Container(
            width: context.W,
            color: Color(colorCode).withAlpha(20),
            child: ExpansionTile(
              iconColor: context.onPrimaryColor,
              collapsedIconColor: context.onPrimaryColor,
              title: Text(
                colorCode == 0xAAFFD354
                    ? 'العلامات الصفراء'
                    : colorCode == 0xAAF36077
                    ? 'العلامات الحمراء'
                    : 'العلامات الخضراء',
                style: StyleText.medium18().copyWith(
                  color: context.onPrimaryColor,
                ),
              ),
              leading: Icon(Icons.bookmark, color: Color(colorCode)),
              children:
                  bookmarks.map((bookmark) {
                    return ListTile(
                      leading: Container(
                        padding: EdgeInsets.symmetric(horizontal: 1.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.r),
                          border: Border.all(color: Color(colorCode)),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Icon(
                              Icons.bookmark,
                              color: Color(bookmark.colorCode),
                              size: 34.sp,
                            ),
                            Text(
                              bookmark.ayahNumber
                                  .toString()
                                  .convertNumbersAccordingToLang(
                                    languageCode: "ar",
                                  ),
                              style: StyleText.medium14().copyWith(
                                color: context.onPrimaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      title: Text(
                        "سورة ${bookmark.name}",
                        style: StyleText.medium18().copyWith(
                          color: context.onPrimaryColor,
                          fontFamily: "Amiri",
                        ),
                      ),
                      onTap: () {
                        PersistentNavBarNavigator.pushNewScreen(
                          context,
                          withNavBar: false,
                          screen: SurahScreen(),
                        );
                        QuranLibrary().jumpToBookmark(bookmark);
                      },
                    );
                  }).toList(),
            ),
          );
        }),
      ],
    );
  }
}
