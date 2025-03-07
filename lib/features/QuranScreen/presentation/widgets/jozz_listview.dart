import 'package:flutter/material.dart';
import 'package:quran_library/quran.dart';
import 'package:ramadan_app/core/utils/functions/convert_num_to_ar.dart';

class JozzListViewWidget extends StatelessWidget {
  const JozzListViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final jozzList = QuranLibrary().allJoz;
    final hizbList = QuranLibrary().allHizb;

    return ListView(
      children: List.generate(
        jozzList.length,
        (jozzIndex) => Container(
          width: MediaQuery.sizeOf(context).width,
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          color:
              jozzIndex.isEven
                  ? const Color(0xfff6d09d).withValues(alpha: .1)
                  : Colors.transparent,
          child: ExpansionTile(
            title: Text(
              jozzList[jozzIndex],
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            children: List.generate(2, (index) {
              final hizbIndex =
                  (index == 0 && jozzIndex == 0)
                      ? 0
                      : ((jozzIndex * 2 + index));
              return InkWell(
                onTap: () {
                  QuranLibrary().jumpToHizb(hizbIndex + 1);
                  Scaffold.of(context).closeDrawer();
                },
                child: Container(
                  width: MediaQuery.sizeOf(context).width,
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 38,
                  ),
                  color:
                      index.isEven
                          ? const Color(0xfff6d09d).withValues(alpha: .1)
                          : Colors.transparent,
                  child: Text(
                    "${convertNumberToArabic("${hizbIndex + 1}")} ${hizbList[hizbIndex]}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
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
