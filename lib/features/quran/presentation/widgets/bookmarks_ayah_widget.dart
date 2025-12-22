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
        BookmarksCtrl.instance.saveBookmark(
          surahName: ayah.arabicName ?? '',
          ayahNumber: ayah.ayahNumber,
          ayahId: ayah.ayahUQNumber,
          page: ayah.page,
          colorCode: colorCode,
        );
        QuranCtrl.instance.state.overlayEntry?.remove();
        QuranCtrl.instance.state.overlayEntry = null;
      },
      child: Icon(Icons.bookmark, color: Color(colorCode)),
    );
  }
}
