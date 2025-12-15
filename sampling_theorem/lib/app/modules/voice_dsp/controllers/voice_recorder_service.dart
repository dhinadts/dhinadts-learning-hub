// voice_recorder_service.dart
import 'dart:io';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as path;

class VoiceRecorderService {
  final AudioRecorder _recorder = AudioRecorder();

  String? _currentPath;
  bool _isRecording = false;

  final Function(String)? onRecordingComplete;
  final Function(bool)? onRecordingStateChanged;
  final Function(String)? onError;

  VoiceRecorderService({
    this.onRecordingComplete,
    this.onRecordingStateChanged,
    this.onError,
  });

  Future<bool> _checkPermissions() async {
    // Check and request microphone permission
    final micStatus = await Permission.microphone.status;
    if (!micStatus.isGranted) {
      final result = await Permission.microphone.request();
      if (!result.isGranted) {
        _handleError('Microphone permission denied');
        return false;
      }
    }

    // Check and request storage permission (for Android)
    if (Platform.isAndroid) {
      final storageStatus = await Permission.storage.status;
      if (!storageStatus.isGranted) {
        await Permission.storage.request();
      }
    }

    return true;
  }

  Future<String?> startRecording() async {
    if (_isRecording) {
      await stopRecording();
      return null;
    }

    try {
      if (!await _checkPermissions()) {
        return null;
      }

      // Get directory for saving recordings
      final appDir = await getApplicationDocumentsDirectory();
      final recordingsDir = Directory('${appDir.path}/recordings');
      if (!await recordingsDir.exists()) {
        await recordingsDir.create(recursive: true);
      }

      _currentPath = path.join(
        recordingsDir.path,
        'recording_${DateTime.now().millisecondsSinceEpoch}.wav',
      );

      // Configure recording settings
      final config = RecordConfig(
        encoder: AudioEncoder.wav, // WAV format for better quality
        bitRate: 128000, // 128 kbps
        sampleRate: 16000, // 16kHz sample rate
        numChannels: 1, // Mono
      );

      _isRecording = true;
      onRecordingStateChanged?.call(true);

      await _recorder.start(config, path: _currentPath!);

      return _currentPath;
    } catch (e) {
      _handleError('Failed to start recording: $e');
      _isRecording = false;
      onRecordingStateChanged?.call(false);
      return null;
    }
  }

  Future<String?> stopRecording() async {
    if (!_isRecording) return null;

    try {
      final path = await _recorder.stop();
      _isRecording = false;
      onRecordingStateChanged?.call(false);

      if (path != null && await File(path).exists()) {
        _currentPath = path;
        onRecordingComplete?.call(path);
        return path;
      }
      return null;
    } catch (e) {
      _handleError('Failed to stop recording: $e');
      _isRecording = false;
      onRecordingStateChanged?.call(false);
      return null;
    }
  }

  Future<bool> pauseRecording() async {
    if (!_isRecording) return false;

    try {
      await _recorder.pause();
      return true;
    } catch (e) {
      _handleError('Failed to pause recording: $e');
      return false;
    }
  }

  Future<bool> resumeRecording() async {
    if (!_isRecording) return false;

    try {
      await _recorder.resume();
      return true;
    } catch (e) {
      _handleError('Failed to resume recording: $e');
      return false;
    }
  }

  bool get isRecording => _isRecording;

  Future<void> dispose() async {
    if (_isRecording) {
      await stopRecording();
    }
    await _recorder.dispose();
  }

  void _handleError(String message) {
    print('VoiceRecorderService Error: $message');
    onError?.call(message);
  }
}
