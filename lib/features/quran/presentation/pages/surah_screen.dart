import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quran_library/quran.dart';
import 'package:ramadan_app/core/extensions/context_extensions.dart';
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
  String selectedValue = 'mahermuaiqly';
  final List<Map<String, String>> _dropdownItems = [
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

    return Scaffold(
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

        onDefaultAyahLongPress: (allBookmarks, details, ayah) {
          final bookmarkId =
              allBookmarks
                  .firstWhereOrNull(
                    (bookmark) => bookmark.ayahId == ayah.ayahUQNumber,
                  )
                  ?.id;

          if (bookmarkId != null) {
            BookmarksCtrl.instance.removeBookmark(bookmarkId);
          } else {
            quranCtrl.toggleAyahSelection(ayah.ayahUQNumber);
            quranCtrl.state.overlayEntry?.remove();
            quranCtrl.state.overlayEntry = null;

            final overlay = Overlay.of(context);
            final newOverlayEntry = OverlayEntry(
              builder: (context) => _popWidgetToolsPar(details, ayah, context),
            );

            quranCtrl.state.overlayEntry = newOverlayEntry;
            overlay.insert(newOverlayEntry);
          }
        },
      ),
    );
  }

  Positioned _popWidgetToolsPar(
    LongPressStartDetails details,
    AyahModel ayah,
    BuildContext context,
  ) {
    return Positioned(
      top: 2.h,
      left: 10.w,
      right: 10.w,

      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          color: const Color.fromARGB(255, 208, 208, 208),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: .3),
              blurRadius: 10,
              spreadRadius: 5,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(6.r)),
            border: Border.all(width: 2.w, color: const Color(0xffe8decb)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ...[0xAAFFD354, 0xAAF36077, 0xAA00CD00].map(
                (colorCode) => BookmarksAyahWidget(
                  ayah: ayah,
                  colorCode: colorCode,
                ).paddingSymmetric(horizontal: 6.w),
              ),
              context.verticalDivider(
                height: 30.h,
                color: context.primaryColor,
              ),
              // ClipboardAyahWidget(ayah: ayah),
              // context.verticalDivider(
              //   height: 30.h,
              //   color: context.primaryColor,
              // ),
              AudioAyahWidget(ayah: ayah, selectedValue: selectedValue),
              context.verticalDivider(
                height: 30.h,
                color: context.primaryColor,
              ),
              SizedBox(
                width: 100.w,
                child: AppDropDownButton(
                  hintText: 'القارئ',

                  value: selectedValue,
                  onChanged: (value) {
                    setState(() {
                      selectedValue = value!;
                    });
                  },
                  items: _dropdownItems,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
