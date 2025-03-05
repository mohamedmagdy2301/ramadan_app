import 'package:flutter/material.dart';
import 'package:quran_library/quran.dart';
import 'package:ramadan_app/core/extensions/context_extensions.dart';
import 'package:ramadan_app/core/utils/widgets/custom_loading_widget.dart';
import 'package:ramadan_app/features/QuranScreen/presentation/widgets/appbar_quran.dart';
import 'package:ramadan_app/features/QuranScreen/presentation/widgets/drawar_quran.dart';

class QuranScreen extends StatelessWidget {
  const QuranScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarQuran(),
      drawer: DefaultDrawer("ar", context.isDark),
      body: QuranLibraryScreen(
        useDefaultAppBar: false,
        ayahIconColor: context.primaryColor,
        ayahSelectedBackgroundColor: context.primaryColor,
        backgroundColor: context.backgroundColor,
        basmalaStyle: BasmalaStyle(basmalaColor: context.primaryColor),
        isDark: context.isDark,
        circularProgressWidget: const Center(child: CustomLoadingWidget()),
        textColor: context.onPrimaryColor,
        surahNameStyle: SurahNameStyle(surahNameColor: context.primaryColor),
      ),
    );
  }
}
