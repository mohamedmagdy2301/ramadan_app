import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:quran_library/quran.dart';
import 'package:ramadan_app/core/utils/widgets/custom_loading_widget.dart';
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
    setState(() => _isLoading = true);
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
  }

  void _toggleAudio() {
    if (_audioUrl == null || _isLoading) return;
    if (_isPlaying) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play(UrlSource(_audioUrl!));
    }
    setState(() => _isPlaying = !_isPlaying);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: _isLoading ? null : _toggleAudio,
      icon:
          _isLoading
              ? CustomLoadingWidget(width: 24, height: 24)
              : Icon(
                _isPlaying ? Icons.pause : Icons.play_arrow,
                color:
                    _audioUrl != null
                        ? Colors.grey
                        : Colors.grey.withAlpha(150),
              ),
    );
  }
}
