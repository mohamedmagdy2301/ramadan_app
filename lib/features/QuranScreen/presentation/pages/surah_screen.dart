import 'package:flutter/material.dart';
import 'package:quran_library/quran.dart';
import 'package:ramadan_app/core/extensions/context_extensions.dart';
import 'package:ramadan_app/core/utils/widgets/custom_loading_widget.dart';

class SurahScreen extends StatelessWidget {
  const SurahScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return QuranLibraryScreen(
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
    );
  }
}
