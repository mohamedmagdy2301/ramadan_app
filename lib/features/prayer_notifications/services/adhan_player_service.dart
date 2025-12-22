import 'package:audioplayers/audioplayers.dart';

import '../domain/entities/adhan_sound.dart';

/// Abstract interface for Adhan player service
abstract class IAdhanPlayerService {
  /// Play an adhan sound
  Future<void> play(AdhanSound adhan);

  /// Stop currently playing adhan
  Future<void> stop();

  /// Check if adhan is currently playing
  bool get isPlaying;

  /// Get the currently playing adhan
  AdhanSound? get currentAdhan;

  /// Dispose resources
  Future<void> dispose();
}

/// Service for playing Adhan sounds
class AdhanPlayerService implements IAdhanPlayerService {
  static AdhanPlayerService? _instance;
  static AdhanPlayerService get instance {
    _instance ??= AdhanPlayerService._internal();
    return _instance!;
  }

  AdhanPlayerService._internal();

  // For testing purposes
  factory AdhanPlayerService.withPlayer(AudioPlayer player) {
    final service = AdhanPlayerService._internal();
    service._audioPlayer = player;
    return service;
  }

  AudioPlayer? _audioPlayer;
  AdhanSound? _currentAdhan;
  bool _isPlaying = false;

  AudioPlayer get _player {
    _audioPlayer ??= AudioPlayer();
    return _audioPlayer!;
  }

  @override
  bool get isPlaying => _isPlaying;

  @override
  AdhanSound? get currentAdhan => _currentAdhan;

  /// Initialize the player and set up listeners
  void _setupListeners() {
    _player.onPlayerComplete.listen((_) {
      _isPlaying = false;
      _currentAdhan = null;
    });

    _player.onPlayerStateChanged.listen((state) {
      _isPlaying = state == PlayerState.playing;
    });
  }

  /// Play an adhan sound from assets
  @override
  Future<void> play(AdhanSound adhan) async {
    try {
      // Stop any currently playing audio
      await stop();

      _setupListeners();
      _currentAdhan = adhan;

      // Play from assets
      await _player.play(AssetSource(adhan.assetPath.replaceFirst('assets/', '')));
      _isPlaying = true;
    } catch (e) {
      _isPlaying = false;
      _currentAdhan = null;
      rethrow;
    }
  }

  /// Stop the currently playing adhan
  @override
  Future<void> stop() async {
    try {
      await _player.stop();
      _isPlaying = false;
      _currentAdhan = null;
    } catch (_) {
      // Ignore stop errors
    }
  }

  /// Pause the currently playing adhan
  Future<void> pause() async {
    try {
      await _player.pause();
      _isPlaying = false;
    } catch (_) {
      // Ignore pause errors
    }
  }

  /// Resume playing the paused adhan
  Future<void> resume() async {
    try {
      await _player.resume();
      _isPlaying = true;
    } catch (_) {
      // Ignore resume errors
    }
  }

  /// Dispose of the audio player
  @override
  Future<void> dispose() async {
    await _player.dispose();
    _audioPlayer = null;
    _isPlaying = false;
    _currentAdhan = null;
  }

  // Static convenience methods
  static Future<void> playStatic(AdhanSound adhan) async {
    await instance.play(adhan);
  }

  static Future<void> stopStatic() async {
    await instance.stop();
  }

  static bool get isPlayingStatic => instance.isPlaying;

  static AdhanSound? get currentAdhanStatic => instance.currentAdhan;
}
