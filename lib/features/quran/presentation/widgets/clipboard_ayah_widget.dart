import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quran_library/quran.dart';
import 'package:ramadan_app/core/utils/widgets/snakbar/snackbar_helper.dart';

class ClipboardAyahWidget extends StatelessWidget {
  const ClipboardAyahWidget({super.key, required this.ayah});
  final AyahModel ayah;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Clipboard.setData(ClipboardData(text: ayah.text));
        showMessage(
          context,
          type: SnackBarType.success,
          message: "تم النسخ الى الحافظة",
        );
        QuranCtrl.instance.state.overlayEntry?.remove();
        QuranCtrl.instance.state.overlayEntry = null;
      },
      child: const Icon(Icons.copy_rounded, color: Colors.grey),
    );
  }
}
