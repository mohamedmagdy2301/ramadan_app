import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_library/quran.dart';
import 'package:ramadan_app/core/extensions/context_extensions.dart';
import 'package:ramadan_app/core/router/router_helper.dart';
import 'package:ramadan_app/core/utils/widgets/custom_loading_widget.dart';

class SurahScreen extends StatelessWidget {
  const SurahScreen({super.key});

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
          parentContext: context,
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
      ),
    );
  }
}
