// voice_dsp_controller.dart
import 'dart:async';
import 'dart:math';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import 'voice_recorder_service.dart';
import 'audio_player_service.dart';

class VoiceDspController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late VoiceRecorderService _recorderService;
  late AudioPlayerService _playerService;

  RxBool isInitializing = false.obs;
  RxBool isRecording = false.obs;
  RxBool isPlaying = false.obs;
  RxString recordedFilePath = ''.obs;
  RxString statusMessage = 'Ready'.obs;

  // Playback progress
  Rx<Duration> playbackPosition = Duration.zero.obs;
  Rx<Duration> playbackDuration = Duration.zero.obs;
  RxDouble playbackProgress = 0.0.obs;

  // DSP Outputs
  RxList<double> waveformData = <double>[].obs;
  RxList<double> spectrumData = <double>[].obs;
  RxList<double> audioFFT = <double>[].obs;
  RxDouble rmsValue = 0.0.obs;
  RxDouble pitch = 0.0.obs;
  RxDouble zeroCrossingRate = 0.0.obs;
  RxDouble currentVolume = 0.0.obs;
  RxInt sampleRate = 16000.obs;
  RxInt fftSize = 1024.obs;

  // Filters
  RxBool applyLowPass = false.obs;
  RxBool applyHighPass = false.obs;
  RxBool applyEcho = false.obs;
  RxBool applyReverb = false.obs;
  RxBool applyChorus = false.obs;

  RxDouble lowPassCutoff = 2000.0.obs;
  RxDouble highPassCutoff = 200.0.obs;
  RxDouble echoDelay = 0.3.obs;
  RxDouble echoDecay = 0.5.obs;

  // RxString recordedFilePath = ''.obs;

  late AnimationController animationController;

  @override
  void onInit() {
    super.onInit();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    )..repeat();

    _initServices();
  }

  Future<void> _initServices() async {
    try {
      isInitializing.value = true;
      statusMessage.value = 'Initializing audio services...';

      // Initialize recorder service
      _recorderService = VoiceRecorderService(
        onRecordingComplete: _onRecordingComplete,
        onRecordingStateChanged: _onRecordingStateChanged,
        onError: _onRecordingError,
      );

      // Initialize player service
      _playerService = AudioPlayerService(
        onPlaybackStateChanged: _onPlaybackStateChanged,
        onDurationChanged: _onDurationChanged,
        onPositionChanged: _onPositionChanged,
        onPlayerStateChanged: _onPlayerStateChanged,
        onError: _onPlaybackError,
      );

      isInitializing.value = false;
      statusMessage.value = 'Ready to record';
    } catch (e) {
      isInitializing.value = false;
      statusMessage.value = 'Initialization failed: ${e.toString()}';
      Get.snackbar(
        'Initialization Error',
        'Failed to initialize audio services',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void _onRecordingStateChanged(bool recording) {
    isRecording.value = recording;
    if (recording) {
      statusMessage.value = 'Recording...';
      _startWaveformSimulation();
    } else {
      statusMessage.value = 'Recording stopped';
      _stopWaveformSimulation();
    }
  }

  void _onRecordingComplete(String filePath) {
    recordedFilePath.value = filePath;
    statusMessage.value = 'Recording saved: ${filePath.split('/').last}';

    // Analyze the recording
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _analyzeRecordedAudio();
    });
  }

  void _onRecordingError(String error) {
    statusMessage.value = 'Recording error: $error';
    isRecording.value = false;

    Get.snackbar(
      'Recording Error',
      error,
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 3),
    );
  }

  void _onPlaybackStateChanged(bool playing) {
    isPlaying.value = playing;
    if (playing) {
      statusMessage.value = 'Playing...';
    } else {
      statusMessage.value = 'Playback stopped';
    }
  }

  void _onDurationChanged(Duration duration) {
    playbackDuration.value = duration;
  }

  void _onPositionChanged(Duration position) {
    playbackPosition.value = position;
    if (playbackDuration.value.inMilliseconds > 0) {
      playbackProgress.value =
          position.inMilliseconds / playbackDuration.value.inMilliseconds;
    }
  }

  void _onPlayerStateChanged(PlayerState state) {
    // Handle additional player states if needed
  }

  void _onPlaybackError(String error) {
    statusMessage.value = 'Playback error: $error';
    isPlaying.value = false;

    Get.snackbar(
      'Playback Error',
      error,
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 3),
    );
  }

  Timer? _waveformTimer;

  void _startWaveformSimulation() {
    _stopWaveformSimulation();

    _waveformTimer = Timer.periodic(Duration(milliseconds: 50), (timer) {
      final simulatedData = List<double>.generate(100, (index) {
        final time = index / 100.0;
        final noise = Random().nextDouble() * 0.1;
        return sin(time * 10 * pi) * 0.5 + sin(time * 25 * pi) * 0.3 + noise;
      });
      waveformData.assignAll(simulatedData);
    });
  }

  void _stopWaveformSimulation() {
    _waveformTimer?.cancel();
    _waveformTimer = null;
  }

  Future<void> startRecording() async {
    if (isInitializing.value) {
      Get.snackbar('Please wait', 'Audio services are initializing...');
      return;
    }

    if (isRecording.value) {
      await stopRecording();
      return;
    }

    if (isPlaying.value) {
      await stopPlayback();
      await Future.delayed(Duration(milliseconds: 200));
    }

    try {
      await _recorderService.startRecording();
    } catch (e) {
      statusMessage.value = 'Failed to start recording';
      Get.snackbar(
        'Recording Failed',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> stopRecording() async {
    try {
      await _recorderService.stopRecording();
    } catch (e) {
      statusMessage.value = 'Error stopping recording';
      Get.snackbar(
        'Error',
        'Failed to stop recording: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> pauseRecording() async {
    if (isRecording.value) {
      await _recorderService.pauseRecording();
    }
  }

  Future<void> resumeRecording() async {
    if (isRecording.value) {
      await _recorderService.resumeRecording();
    }
  }

  Future<void> playRecording() async {
    if (recordedFilePath.value.isEmpty) {
      Get.snackbar(
        'No Recording',
        'Please record something first',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (isRecording.value) {
      await stopRecording();
      await Future.delayed(Duration(milliseconds: 300));
    }

    if (isPlaying.value) {
      await stopPlayback();
      return;
    }

    try {
      final file = File(recordedFilePath.value);
      if (!await file.exists()) {
        Get.snackbar(
          'File Not Found',
          'Recording file does not exist',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      await _playerService.playFile(recordedFilePath.value);
    } catch (e) {
      statusMessage.value = 'Playback failed';
      Get.snackbar(
        'Playback Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> stopPlayback() async {
    try {
      await _playerService.stop();
    } catch (e) {
      print('Error stopping playback: $e');
    }
  }

  Future<void> pausePlayback() async {
    if (isPlaying.value) {
      await _playerService.pause();
    }
  }

  Future<void> resumePlayback() async {
    if (!isPlaying.value && recordedFilePath.value.isNotEmpty) {
      await _playerService.resume();
    }
  }

  Future<void> seekPlayback(double progress) async {
    if (playbackDuration.value.inMilliseconds > 0) {
      final position = Duration(
          milliseconds:
              (progress * playbackDuration.value.inMilliseconds).toInt());
      await _playerService.seek(position);
    }
  }

  Future<void> _analyzeRecordedAudio() async {
    try {
      final file = File(recordedFilePath.value);
      if (!await file.exists()) {
        print('File does not exist: ${recordedFilePath.value}');
        return;
      }

      final bytes = await file.readAsBytes();
      if (bytes.length < 44) {
        print('File too small to be a valid WAV file');
        return;
      }

      // Skip WAV header (44 bytes)
      final pcm = bytes.sublist(44);

      final samples = <double>[];
      for (int i = 0; i < pcm.length - 1; i += 2) {
        int s = (pcm[i + 1] << 8) | pcm[i];
        if (s > 32767) s -= 65536;
        samples.add(s / 32768.0);
      }

      _processSamples(samples);
    } catch (e) {
      print('Error analyzing audio: $e');
    }
  }

  void _processSamples(List<double> samples) {
    if (samples.isEmpty) return;

    // Take first 100 samples for waveform visualization
    final displaySamples = samples.take(100).toList();
    waveformData.assignAll(displaySamples);

    // Calculate RMS
    double sum = 0;
    for (final s in samples) {
      sum += s * s;
    }
    rmsValue.value = sqrt(sum / samples.length);
    currentVolume.value = rmsValue.value;

    // Calculate Zero Crossing Rate
    int zc = 0;
    for (int i = 1; i < samples.length; i++) {
      if (samples[i] * samples[i - 1] < 0) zc++;
    }
    zeroCrossingRate.value = zc / samples.length;

    // Compute FFT
    _computeFFT(samples);
  }

  void _computeFFT(List<double> samples) {
    final N = min(samples.length, fftSize.value);
    if (N < 2) return;

    final result = <double>[];

    for (int k = 0; k < N ~/ 2; k++) {
      double real = 0, imag = 0;
      for (int n = 0; n < N; n++) {
        final angle = 2 * pi * k * n / N;
        real += samples[n] * cos(angle);
        imag -= samples[n] * sin(angle);
      }
      result.add(sqrt(real * real + imag * imag) / N);
    }

    audioFFT.assignAll(result);

    // Prepare spectrum data for visualization
    final visual = result.take(50).toList();
    if (visual.isNotEmpty) {
      final maxVal = visual.reduce(max);
      if (maxVal > 0) {
        spectrumData.assignAll(
          visual.map((v) => v / maxVal).toList(),
        );
      }
    }
  }

  // ... rest of your existing methods (getPeakFrequencies, exportAudioAnalysis, resetSettings)

  @override
  void onClose() {
    _waveformTimer?.cancel();
    animationController.dispose();
    _recorderService.dispose();
    _playerService.dispose();
    super.onClose();
  }
}
