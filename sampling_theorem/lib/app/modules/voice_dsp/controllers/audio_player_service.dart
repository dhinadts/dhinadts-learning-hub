// audio_player_service.dart
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class AudioPlayerService {
  final AudioPlayer _player = AudioPlayer();
  String? _currentFilePath;

  final Function(bool)? onPlaybackStateChanged;
  final Function(Duration)? onDurationChanged;
  final Function(Duration)? onPositionChanged;
  final Function(PlayerState)? onPlayerStateChanged;
  final Function(String)? onError;

  AudioPlayerService({
    this.onPlaybackStateChanged,
    this.onDurationChanged,
    this.onPositionChanged,
    this.onPlayerStateChanged,
    this.onError,
  }) {
    _setupListeners();
  }

  void _setupListeners() {
    _player.onDurationChanged.listen((duration) {
      onDurationChanged?.call(duration);
    });

    _player.onPositionChanged.listen((position) {
      onPositionChanged?.call(position);
    });

    _player.onPlayerStateChanged.listen((state) {
      onPlayerStateChanged?.call(state);
      onPlaybackStateChanged?.call(state == PlayerState.playing);
    });

    _player.onPlayerComplete.listen((_) {
      onPlaybackStateChanged?.call(false);
    });

    _player.onLog.listen((message) {
      if (kDebugMode) print('AudioPlayer Log: $message');
    });
  }

  Future<bool> playFile(String filePath) async {
    try {
      if (_currentFilePath != filePath) {
        await _player.stop();
        _currentFilePath = filePath;
      }

      await _player.play(DeviceFileSource(filePath));
      return true;
    } catch (e) {
      _handleError('Failed to play audio: $e');
      return false;
    }
  }

  Future<bool> playUrl(String url) async {
    try {
      await _player.play(UrlSource(url));
      return true;
    } catch (e) {
      _handleError('Failed to play URL: $e');
      return false;
    }
  }

  Future<void> pause() async {
    try {
      await _player.pause();
    } catch (e) {
      _handleError('Failed to pause: $e');
    }
  }

  Future<void> resume() async {
    try {
      await _player.resume();
    } catch (e) {
      _handleError('Failed to resume: $e');
    }
  }

  Future<void> stop() async {
    try {
      await _player.stop();
      onPlaybackStateChanged?.call(false);
    } catch (e) {
      _handleError('Failed to stop: $e');
    }
  }

  Future<void> seek(Duration position) async {
    try {
      await _player.seek(position);
    } catch (e) {
      _handleError('Failed to seek: $e');
    }
  }

  Future<void> setVolume(double volume) async {
    try {
      await _player.setVolume(volume);
    } catch (e) {
      _handleError('Failed to set volume: $e');
    }
  }

  Future<void> dispose() async {
    await _player.dispose();
  }

  bool get isPlaying => _player.state == PlayerState.playing;
  PlayerState get playerState => _player.state;
  String? get currentFilePath => _currentFilePath;

  void _handleError(String message) {
    print('AudioPlayerService Error: $message');
    onError?.call(message);
  }
}
