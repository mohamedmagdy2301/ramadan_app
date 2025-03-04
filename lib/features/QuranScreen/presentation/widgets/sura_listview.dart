// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
// import 'package:ramadan_app/core/constants/app_text_style.dart';
// import 'package:ramadan_app/core/extensions/context_extensions.dart';
// import 'package:ramadan_app/core/extensions/int_extensions.dart' as ext;
// import 'package:ramadan_app/core/utils/functions/convert_num_to_ar.dart';
// import 'package:ramadan_app/features/QuranScreen/presentation/widgets/AyahPage.dart';
// import 'package:ramadan_app/features/QuranScreen/presentation/widgets/QuranPageWidgets/number_widget.dart';

// import '../../../../core/constants/app_images.dart';
// import '../../data/models/quran_chapter_model.dart';

// class SuraListViewWidget extends StatelessWidget {
//   const SuraListViewWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
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
//       },
//     );
//   }
// }
