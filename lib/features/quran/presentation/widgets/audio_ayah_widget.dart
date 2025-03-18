import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_library/quran.dart';
import 'package:ramadan_app/core/utils/widgets/custom_loading_widget.dart';
import 'package:ramadan_app/core/utils/widgets/snakbar/snackbar_helper.dart';
import 'package:ramadan_app/features/quran/data/ayah_service.dart';

class AudioAyahWidget extends StatefulWidget {
  const AudioAyahWidget({
    super.key,
    required this.ayah,
    required this.selectedValue,
  });

  final AyahModel ayah;
  final String selectedValue;

  @override
  State<AudioAyahWidget> createState() => _AudioAyahWidgetState();
}

class _AudioAyahWidgetState extends State<AudioAyahWidget> {
  final AyahService _ayahService = AyahService();
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  bool _isLoading = false;
  String? _audioUrl;
  bool _hasError = false;

  @override
  void didUpdateWidget(covariant AudioAyahWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedValue != widget.selectedValue) {
      _fetchAudioUrl();
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchAudioUrl();
    _audioPlayer.onPlayerComplete.listen((event) {
      setState(() => _isPlaying = false);
    });
  }

  Future<void> _fetchAudioUrl() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
    try {
      final ayahs = await _ayahService.getAyahData(
        widget.ayah.surahNumber,
        widget.selectedValue,
      );
      if (mounted) {
        setState(() {
          _audioUrl = ayahs[widget.ayah.ayahNumber - 1].audio;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _isLoading = false;
        });
        _showErrorSnackbar("تعذر تشغيل الصوت , حدث خطاء اثناء تحميل الصوت");
      }
    }
  }

  void _toggleAudio() {
    if (_audioUrl == null || _isLoading) return;
    if (_hasError) {
      _showErrorSnackbar("تعذر تشغيل الصوت , حدث خطاء اثناء تحميل الصوت");
      return;
    }
    try {
      if (_isPlaying) {
        _audioPlayer.pause();
      } else {
        _audioPlayer.play(UrlSource(_audioUrl!));
      }
      setState(() => _isPlaying = !_isPlaying);
    } catch (e) {
      setState(() => _hasError = true);
      _showErrorSnackbar("تعذر تشغيل الصوت , حدث خطاء اثناء تحميل الصوت");
    }
  }

  void _showErrorSnackbar(String message) {
    showMessage(context, type: SnackBarType.error, message: message);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed:
          _hasError
              ? () => _showErrorSnackbar("حدث خطاء اثناء تحميل الصوت")
              : _isLoading
              ? null
              : _toggleAudio,
      icon:
          _isLoading
              ? CustomLoadingWidget(width: 24, height: 24)
              : Stack(
                children: [
                  Icon(
                    _isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 30,
                  ),
                  _hasError
                      ? Positioned(
                        bottom: 5.h,
                        right: 0,
                        child: Icon(
                          Icons.warning_rounded,
                          color: Colors.orangeAccent,
                          size: 15,
                        ),
                      )
                      : SizedBox(),
                ],
              ),
    );
  }
}
