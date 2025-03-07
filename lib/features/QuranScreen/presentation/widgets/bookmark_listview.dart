import 'package:flutter/material.dart';
import 'package:quran_library/quran.dart';

class BookMarkListViewWidget extends StatelessWidget {
  const BookMarkListViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ...BookmarksCtrl.instance.bookmarks.entries.map((entry) {
          final colorCode = entry.key; // اللون
          final bookmarks = entry.value; // قائمة العلامات لهذا اللون
          return ExpansionTile(
            title: Text(
              colorCode == 0xAAFFD354
                  ? 'العلامات الصفراء'
                  : colorCode == 0xAAF36077
                  ? 'العلامات الحمراء'
                  : 'العلامات الخضراء',
              style: QuranLibrary().naskhStyle.copyWith(fontSize: 18),
            ),
            leading: Icon(Icons.bookmark, color: Color(colorCode)),
            children:
                bookmarks.map((bookmark) {
                  return ListTile(
                    leading: Container(
                      padding: EdgeInsets.symmetric(horizontal: 1.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Color(colorCode)),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Icon(
                            Icons.bookmark,
                            color: Color(bookmark.colorCode),
                            size: 34,
                          ),
                          Text(
                            bookmark.ayahNumber
                                .toString()
                                .convertNumbersAccordingToLang(
                                  languageCode: "ar",
                                ),
                            style: QuranLibrary().naskhStyle,
                          ),
                        ],
                      ),
                    ),
                    title: Text(
                      bookmark.name,
                      style: QuranLibrary().naskhStyle.copyWith(fontSize: 17),
                    ),
                    onTap: () {
                      QuranLibrary().jumpToBookmark(bookmark);
                      Scaffold.of(context).closeDrawer();
                    },
                  );
                }).toList(),
          );
        }),
      ],
    );

    // ListView.builder(
    //       itemCount: quranData.length,
    //       itemBuilder: (context, index) {
    //         var surah = quranData[index];
    //         return GestureDetector(
    //           onTap: () {
    //             PersistentNavBarNavigator.pushNewScreen(
    //               context,
    //               withNavBar: false,
    //               screen: AyahScreens(suraNumber: surah.id),
    //             );
    //           },
    //           child: Container(
    //             padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
    //             child: Row(
    //               children: [
    //                 NumberWidget(num: surah.id),
    //                 14.wSpace,
    //                 Text(
    //                   surah.name,
    //                   style: StyleText.medium24().copyWith(
    //                     color: context.onPrimaryColor.withAlpha(200),
    //                     fontFamily: "Amiri",
    //                   ),
    //                 ),
    //                 Spacer(),
    //                 Text(
    //                   "${convertNumberToArabic(surah.totalVerses.toString())} ايات",
    //                   style: StyleText.medium18().copyWith(
    //                     fontFamily: "Amiri",
    //                     color: context.onPrimaryColor.withAlpha(180),
    //                   ),
    //                 ),
    //                 8.wSpace,
    //                 Text(
    //                   "||",
    //                   style: StyleText.medium18().copyWith(
    //                     fontFamily: "Amiri",
    //                     color: context.onPrimaryColor.withAlpha(180),
    //                   ),
    //                 ),
    //                 8.wSpace,
    //                 Image.asset(
    //                   surah.type == "meccan" ? AppAssets.kaaba : AppAssets.mosque,
    //                   width: 30.w,
    //                   height: 30.h,
    //                 ),
    //               ],
    //             ),
    //           ),
    //         );
  }
}
