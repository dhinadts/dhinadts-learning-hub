// app/modules/signal_generator/controllers/signal_generator_controller.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignalGeneratorController extends GetxController
    with GetSingleTickerProviderStateMixin {
  // Signal parameters
  RxDouble frequency = 1.0.obs;
  RxDouble amplitude = 1.0.obs;
  RxDouble phase = 0.0.obs;
  RxString signalType = 'sine'.obs;
  RxDouble sampleRate = 100.0.obs;
  RxDouble noiseLevel = 0.0.obs;

  // Animation
  late AnimationController animationController;
  RxDouble time = 0.0.obs;

  // Generated signal data
  RxList<double> signalData = <double>[].obs;
  RxList<double> timeData = <double>[].obs;

  // Available signal types
  final List<String> signalTypes = [
    'sine',
    'cosine',
    'square',
    'triangle',
    'sawtooth',
    'noise',
    'chirp',
  ];

  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    // Generate initial signal
    generateSignal();

    // Update signal continuously
    animationController.addListener(() {
      time.value = animationController.value * 2 * pi;
      generateSignal();
    });
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }

  void generateSignal() {
    const int points = 500;
    signalData.clear();
    timeData.clear();

    for (int i = 0; i < points; i++) {
      double t = (i / points) * 4 * pi;
      timeData.add(t);

      double value = 0;

      switch (signalType.value) {
        case 'sine':
          value = amplitude.value * sin(frequency.value * t + phase.value);
          break;
        case 'cosine':
          value = amplitude.value * cos(frequency.value * t + phase.value);
          break;
        case 'square':
          value = amplitude.value * sin(frequency.value * t + phase.value) > 0
              ? 1.0
              : -1.0;
          break;
        case 'triangle':
          value = amplitude.value *
              (2 * asin(sin(frequency.value * t + phase.value)) / pi);
          break;
        case 'sawtooth':
          value = amplitude.value *
              (2 *
                  (t * frequency.value / (2 * pi) -
                      (0.5 + t * frequency.value / (2 * pi)).floor()));
          break;
        case 'noise':
          value = amplitude.value * (Random().nextDouble() * 2 - 1);
          break;
        case 'chirp':
          double chirpFreq = frequency.value * (1 + 0.5 * sin(t));
          value = amplitude.value * sin(chirpFreq * t + phase.value);
          break;
      }

      // Add noise
      if (noiseLevel.value > 0) {
        value += noiseLevel.value * (Random().nextDouble() * 2 - 1);
      }

      signalData.add(value);
    }
  }

  void setSignalType(String type) {
    signalType.value = type;
    generateSignal();
  }

  void resetSignal() {
    frequency.value = 1.0;
    amplitude.value = 1.0;
    phase.value = 0.0;
    noiseLevel.value = 0.0;
    generateSignal();
  }

  // Export signal data
  String exportCSV() {
    String csv = 'Time,Amplitude\n';
    for (int i = 0; i < signalData.length; i++) {
      csv += '${timeData[i]},${signalData[i]}\n';
    }
    return csv;
  }
}
