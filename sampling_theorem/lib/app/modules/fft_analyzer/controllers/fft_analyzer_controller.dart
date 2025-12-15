// app/modules/fft_analyzer/controllers/fft_analyzer_controller.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FFTAnalyzerController extends GetxController
    with GetSingleTickerProviderStateMixin {
  // Input signal
  RxList<double> inputSignal = <double>[].obs;
  RxList<double> fftResult = <double>[].obs;
  RxList<double> frequencies = <double>[].obs;

  // Parameters
  RxInt fftSize = 256.obs;
  RxDouble samplingRate = 1000.0.obs;
  RxString windowType = 'hamming'.obs;

  // Animation
  late AnimationController animationController;

  final List<String> windowTypes = [
    'rectangular',
    'hamming',
    'hann',
    'blackman',
    'flattop',
  ];

  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    generateTestSignal();
    computeFFT();

    animationController.addListener(() {
      generateTestSignal();
      computeFFT();
    });
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }

  void generateTestSignal() {
    inputSignal.clear();
    const int N = 256;
    final rand = Random();

    // Generate signal with multiple frequencies
    for (int i = 0; i < N; i++) {
      double t = i / samplingRate.value;
      double value = 1.0 * sin(2 * pi * 50 * t) + // 50 Hz
          0.5 * sin(2 * pi * 120 * t) + // 120 Hz
          0.3 * sin(2 * pi * 200 * t) + // 200 Hz
          0.1 * rand.nextDouble(); // Noise

      // Apply window
      value *= _getWindowValue(i, N);

      inputSignal.add(value);
    }
  }

  double _getWindowValue(int n, int N) {
    switch (windowType.value) {
      case 'hamming':
        return 0.54 - 0.46 * cos(2 * pi * n / (N - 1));
      case 'hann':
        return 0.5 * (1 - cos(2 * pi * n / (N - 1)));
      case 'blackman':
        return 0.42 -
            0.5 * cos(2 * pi * n / (N - 1)) +
            0.08 * cos(4 * pi * n / (N - 1));
      case 'flattop':
        return 1.0 -
            1.93 * cos(2 * pi * n / (N - 1)) +
            1.29 * cos(4 * pi * n / (N - 1)) -
            0.388 * cos(6 * pi * n / (N - 1)) +
            0.028 * cos(8 * pi * n / (N - 1));
      default: // rectangular
        return 1.0;
    }
  }

  void computeFFT() {
    fftResult.clear();
    frequencies.clear();

    int N = inputSignal.length;
    if (N == 0) return;

    // Simple DFT (for educational purposes)
    for (int k = 0; k < N ~/ 2; k++) {
      double real = 0;
      double imag = 0;

      for (int n = 0; n < N; n++) {
        double angle = 2 * pi * k * n / N;
        real += inputSignal[n] * cos(angle);
        imag -= inputSignal[n] * sin(angle);
      }

      double magnitude = sqrt(real * real + imag * imag) / N;
      fftResult.add(magnitude);
      frequencies.add(k * samplingRate.value / N);
    }
  }

  void setWindowType(String type) {
    windowType.value = type;
    generateTestSignal();
    computeFFT();
  }

  // Find peak frequencies
  List<double> findPeaks() {
    List<double> peaks = [];
    if (fftResult.length < 3) return peaks;

    for (int i = 1; i < fftResult.length - 1; i++) {
      if (fftResult[i] > fftResult[i - 1] &&
          fftResult[i] > fftResult[i + 1] &&
          fftResult[i] > 0.1) {
        peaks.add(frequencies[i]);
      }
    }

    return peaks;
  }
}
