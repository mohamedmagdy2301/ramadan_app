import 'package:flutter/material.dart';
import 'package:quran_library/quran.dart';

class BookmarksAyahWidget extends StatelessWidget {
  const BookmarksAyahWidget({
    super.key,
    required this.colorCode,
    required this.ayah,
  });
  final AyahModel ayah;
  final int colorCode;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (QuranCtrl.instance.state.fontsSelected2.value == 1 ||
            QuranCtrl.instance.state.fontsSelected2.value == 2 ||
            QuranCtrl.instance.state.scaleFactor.value > 1.3) {
          // إضافة العلامة الجديدة
          BookmarksCtrl.instance.saveBookmark(
            surahName:
                QuranCtrl.instance
                    .getSurahDataByAyahUQ(ayah.ayahNumber)
                    .arabicName,
            ayahNumber: ayah.ayahNumber,
            ayahId: ayah.ayahUQNumber,
            page: ayah.page,
            colorCode: colorCode,
          );
        } else {
          BookmarksCtrl.instance.saveBookmark(
            surahName: ayah.arabicName,
            ayahNumber: ayah.ayahNumber,
            ayahId: ayah.ayahUQNumber,
            page: ayah.page,
            colorCode: colorCode,
          );
        }
        QuranCtrl.instance.state.overlayEntry?.remove();
        QuranCtrl.instance.state.overlayEntry = null;
      },
      child: Icon(Icons.bookmark, color: Color(colorCode)),
    );
  }
}
