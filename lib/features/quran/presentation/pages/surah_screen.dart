import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quran_library/quran.dart';
import 'package:ramadan_app/core/extensions/context_extensions.dart';
import 'package:ramadan_app/core/router/router_helper.dart';
import 'package:ramadan_app/core/utils/widgets/app_dropdown_button.dart';
import 'package:ramadan_app/core/utils/widgets/custom_loading_widget.dart';
import 'package:ramadan_app/features/quran/presentation/widgets/audio_ayah_widget.dart';
import 'package:ramadan_app/features/quran/presentation/widgets/bookmarks_ayah_widget.dart';

class SurahScreen extends StatefulWidget {
  const SurahScreen({super.key});

  @override
  State<SurahScreen> createState() => _SurahScreenState();
}

class _SurahScreenState extends State<SurahScreen> {
  String selectedReciter = 'mahermuaiqly';

  final List<Map<String, String>> reciters = [
    {"value": 'mahermuaiqly', "name": "ماهر المعيقلي"},
    {"value": 'abdulsamad', "name": "عبدالباسط عبدالصمد"},
    {"value": 'abdurrahmaansudais', "name": "عبدالرحمن السديس"},
    {"value": 'alafasy', "name": "مشاري العفاسي"},
    {"value": 'ahmedajamy', "name": "أحمد بن علي العجمي"},
    {"value": 'husary', "name": "محمود خليل الحصري"},
    {"value": 'minshawi', "name": "محمد صديق المنشاوي"},
    {"value": 'muhammadjibreel', "name": "محمد جبريل"},
  ];

  @override
  Widget build(BuildContext context) {
    final quranCtrl = Get.find<QuranCtrl>();

    return PopScope(
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop && quranCtrl.state.overlayEntry != null) {
          quranCtrl.state.overlayEntry?.remove();
          quranCtrl.state.overlayEntry = null;
          navigatePop(context);
        }
      },
      child: Scaffold(
        body: QuranLibraryScreen(
          useDefaultAppBar: false,
          ayahIconColor: context.primaryColor,
          ayahSelectedBackgroundColor: context.primaryColor,
          backgroundColor: context.backgroundColor,
          basmalaStyle: BasmalaStyle(basmalaColor: context.primaryColor),
          isDark: context.isDark,
          circularProgressWidget: const Center(child: CustomLoadingWidget()),
          textColor: context.onPrimaryColor,
          languageCode: "ar",
          surahNameStyle: SurahNameStyle(surahNameColor: context.primaryColor),
          onDefaultAyahLongPress: _handleAyahLongPress,
        ),
      ),
    );
  }

  void _handleAyahLongPress(
    List<BookmarkModel> bookmarks,
    LongPressStartDetails details,
    AyahModel ayah,
  ) {
    final quranCtrl = Get.find<QuranCtrl>();
    final bookmarkId =
        bookmarks
            .firstWhereOrNull(
              (bookmark) => bookmark.ayahId == ayah.ayahUQNumber,
            )
            ?.id;

    if (bookmarkId != null) {
      BookmarksCtrl.instance.removeBookmark(bookmarkId);
    } else {
      quranCtrl.toggleAyahSelection(ayah.ayahUQNumber);
      if (quranCtrl.state.overlayEntry != null) {
        quranCtrl.state.overlayEntry?.remove();
        quranCtrl.state.overlayEntry = null;
      }

      final overlay = Overlay.of(context);
      final newOverlayEntry = OverlayEntry(
        builder: (context) => _buildAyahOptionsOverlay(details, ayah, context),
      );
      quranCtrl.state.overlayEntry = newOverlayEntry;
      overlay.insert(newOverlayEntry);
    }
  }

  Positioned _buildAyahOptionsOverlay(
    LongPressStartDetails details,
    AyahModel ayah,
    BuildContext context,
  ) {
    return Positioned(
      top: 0,
      left: 0.w,
      right: 0.w,
      child: Container(
        color: context.backgroundColor,
        child: Container(
          padding: EdgeInsets.only(top: MediaQuery.paddingOf(context).top.h),
          alignment: Alignment.center,
          color: context.primaryColor.withAlpha(context.isDark ? 40 : 200),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ...[0xAAFFD354, 0xAAF36077, 0xAA00CD00].map(
                (colorCode) => BookmarksAyahWidget(
                  ayah: ayah,
                  colorCode: colorCode,
                ).paddingSymmetric(horizontal: 6.w),
              ),
              context.verticalDivider(height: 30.h, color: Colors.white54),
              AudioAyahWidget(ayah: ayah, selectedValue: selectedReciter),
              context.verticalDivider(height: 30.h, color: Colors.white54),
              _buildReciterDropdown(),
            ],
          ).paddingSymmetric(horizontal: 20),
        ),
      ),
    );
  }

  Widget _buildReciterDropdown() {
    return SizedBox(
      width: 130.w,
      child: AppDropDownButton(
        hintText: ' ',
        value: selectedReciter,
        onChanged: (value) {
          if (value != null) {
            setState(() => selectedReciter = value);
          }
        },
        items: reciters,
      ),
    );
  }
}
