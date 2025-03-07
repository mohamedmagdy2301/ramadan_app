import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:quran_library/quran.dart';
import 'package:ramadan_app/core/constants/app_images.dart';
import 'package:ramadan_app/core/constants/app_text_style.dart';
import 'package:ramadan_app/core/extensions/context_extensions.dart';
import 'package:ramadan_app/core/extensions/int_extensions.dart' as ext;
import 'package:ramadan_app/core/extensions/widget_extensions.dart';
import 'package:ramadan_app/core/utils/functions/convert_num_to_ar.dart';
import 'package:ramadan_app/features/quran/presentation/pages/surah_screen.dart';
import 'package:ramadan_app/features/quran/presentation/widgets/number_widget.dart';

class SuraListViewWidget extends StatefulWidget {
  const SuraListViewWidget({super.key});

  @override
  _SuraListViewWidgetState createState() => _SuraListViewWidgetState();
}

class _SuraListViewWidgetState extends State<SuraListViewWidget> {
  final TextEditingController _searchController = TextEditingController();
  late List<String> surahs;
  late List<String> filteredSurahs;

  @override
  void initState() {
    super.initState();
    surahs = QuranLibrary().getAllSurahs();
    filteredSurahs = List.from(surahs);
  }

  String _removeDiacritics(String text) {
    final diacritics = RegExp(r'[\u064B-\u0652]');
    return text.replaceAll(diacritics, '');
  }

  void _filterSurahs(String query) {
    String normalizedQuery = _removeDiacritics(query);
    setState(() {
      filteredSurahs =
          surahs
              .where(
                (surah) => _removeDiacritics(surah).contains(normalizedQuery),
              )
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _searchController,
          onChanged: _filterSurahs,
          decoration: InputDecoration(
            hintText: "ابحث عن سورة",
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(width: .4.w, color: context.primaryColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(width: .4.w, color: context.primaryColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(width: .7.w, color: context.primaryColor),
            ),
          ),
        ).paddingAll(8),
        Expanded(
          child: ListView.builder(
            itemCount: filteredSurahs.length,
            itemBuilder: (context, index) {
              final surahIndex = surahs.indexOf(filteredSurahs[index]);
              final surahInfo = QuranLibrary().getSurahInfo(
                surahNumber: surahIndex,
              );
              return InkWell(
                onTap: () {
                  PersistentNavBarNavigator.pushNewScreen(
                    context,
                    withNavBar: false,
                    screen: SurahScreen(),
                  );
                  QuranLibrary().jumpToSurah(surahIndex + 1);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 8.h,
                    horizontal: 10.w,
                  ),
                  color:
                      index.isEven
                          ? context.primaryColor.withAlpha(50)
                          : Colors.transparent,
                  child: Row(
                    children: [
                      NumberWidget(num: surahInfo.number),
                      12.wSpace,
                      Text(
                        filteredSurahs[index],
                        style: StyleText.medium16().copyWith(
                          fontFamily: "Amiri",
                          color: context.onPrimaryColor.withAlpha(180),
                        ),
                      ),
                      Spacer(),
                      Text(
                        "${convertNumberToArabic(surahInfo.ayahsNumber.toString())} ايات",
                        style: StyleText.medium16().copyWith(
                          fontFamily: "Amiri",
                          color: context.onPrimaryColor.withAlpha(180),
                        ),
                      ),
                      8.wSpace,
                      Image.asset(
                        surahInfo.revelationType == "مكية"
                            ? AppAssets.kaaba
                            : AppAssets.mosque,
                        width: 30.w,
                        height: 30.h,
                      ),
                      8.wSpace,
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
