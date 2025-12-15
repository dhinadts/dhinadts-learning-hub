// app/modules/fft_analyzer/views/fft_analyzer_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sampling_theorem/app/data/utils/custom_app_bar.dart';
import 'package:sampling_theorem/app/modules/fft_analyzer/views/fft_painter.dart';

import '../controllers/fft_analyzer_controller.dart';

class FFTAnalyzerView extends GetView<FFTAnalyzerController> {
  const FFTAnalyzerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'FFT Spectrum Analyzer',
        showBackButton: true,
      ),
      body: Column(
        children: [
          // Signal and Spectrum Views
          Expanded(
            flex: 2,
            child: Row(
              children: [
                // Time Domain
                Expanded(
                    child: _buildSignalCard(
                  'Time Domain',
                  controller.inputSignal,
                  Colors.blue,
                )),

                // Frequency Domain
                Expanded(
                  child: _buildSignalCard(
                    'Frequency Domain',
                    controller.fftResult,
                    Colors.green,
                    isFrequency: true,
                  ),
                ),
              ],
            ),
          ),

          // Controls and Information
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Window Type Selector
                  _buildWindowSelector(),
                  const SizedBox(height: 16),

                  // Peak Frequencies
                  Obx(() {
                    final peaks = controller.findPeaks();
                    return _buildPeakFrequencies(peaks);
                  }),

                  // FFT Information
                  _buildFFTInfo(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignalCard(
    String title,
    List<double> data,
    Color color, {
    bool isFrequency = false,
  }) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CustomPaint(
                painter: FFTPainter(
                  data: data,
                  color: color,
                  isFrequencyDomain: isFrequency,
                ),
                child: Container(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWindowSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Window Function',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: controller.windowTypes.map((type) {
            return Obx(() {
              final isSelected = controller.windowType.value == type;
              return ChoiceChip(
                label: Text(type.toUpperCase()),
                selected: isSelected,
                onSelected: (_) => controller.setWindowType(type),
                backgroundColor: Colors.grey[200],
                selectedColor: Colors.deepPurple,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              );
            });
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPeakFrequencies(List<double> peaks) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.deepPurple.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Detected Peak Frequencies',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.deepPurple,
            ),
          ),
          const SizedBox(height: 8),
          peaks.isEmpty
              ? const Text(
                  'No significant peaks detected',
                  style: TextStyle(color: Colors.grey),
                )
              : Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: peaks.map((peak) {
                    return Chip(
                      label: Text('${peak.toStringAsFixed(1)} Hz'),
                      backgroundColor: Colors.green.withOpacity(0.2),
                    );
                  }).toList(),
                ),
        ],
      ),
    );
  }

  Widget _buildFFTInfo() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'FFT Size: ${controller.fftSize.value}',
                style: const TextStyle(fontSize: 12),
              ),
              Text(
                'Sampling Rate: ${controller.samplingRate.value} Hz',
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Frequency Resolution: ${(controller.samplingRate.value / controller.fftSize.value).toStringAsFixed(2)} Hz',
                style: const TextStyle(fontSize: 12),
              ),
              Text(
                'Nyquist Frequency: ${(controller.samplingRate.value / 2).toStringAsFixed(0)} Hz',
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
