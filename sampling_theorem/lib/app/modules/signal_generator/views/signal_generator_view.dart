// app/modules/signal_generator/views/signal_generator_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sampling_theorem/app/data/utils/custom_app_bar.dart';
import 'package:sampling_theorem/app/modules/signal_generator/views/signal_wave_generator.dart';
import '../controllers/signal_generator_controller.dart';

class SignalGeneratorView extends GetView<SignalGeneratorController> {
  const SignalGeneratorView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Signal Generator',
        showBackButton: true,
      ),
      body: Column(
        children: [
          // Signal Visualization
          Expanded(
            flex: 3,
            child: Obx(() {
              return Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CustomPaint(
                    painter: SignalWavePainter(
                      signalData: controller.signalData,
                      timeData: controller.timeData,
                      signalType: controller.signalType.value,
                      time: controller.time.value,
                    ),
                    child: Container(),
                  ),
                ),
              );
            }),
          ),

          // Controls
          Expanded(
            flex: 4,
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
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Signal Type Selector
                    _buildSignalTypeSelector(),
                    const SizedBox(height: 16),

                    // Frequency Control
                    Obx(
                      () => _buildControlSlider(
                        label: 'Frequency',
                        value: controller.frequency.value,
                        min: 0.1,
                        max: 10.0,
                        onChanged: (value) {
                          controller.frequency.value = value;
                          controller.generateSignal();
                        },
                        unit: 'Hz',
                      ),
                    ),

                    // Amplitude Control
                    Obx(
                      () => _buildControlSlider(
                        label: 'Amplitude',
                        value: controller.amplitude.value,
                        min: 0.1,
                        max: 2.0,
                        onChanged: (value) {
                          controller.amplitude.value = value;
                          controller.generateSignal();
                        },
                        unit: 'V',
                      ),
                    ),

                    // Noise Control
                    _buildControlSlider(
                      label: 'Noise Level',
                      value: controller.noiseLevel.value,
                      min: 0.0,
                      max: 0.5,
                      onChanged: (value) {
                        controller.noiseLevel.value = value;
                        controller.generateSignal();
                      },
                      unit: '',
                    ),

                    // Action Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: controller.resetSignal,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Reset'),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            // Export functionality
                            Get.snackbar(
                              'Export',
                              'Signal data exported as CSV',
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          },
                          icon: const Icon(Icons.download),
                          label: const Text('Export'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignalTypeSelector() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: controller.signalTypes.map((type) {
        return Obx(() {
          final isSelected = controller.signalType.value == type;
          return ChoiceChip(
            label: Text(type.toUpperCase()),
            selected: isSelected,
            onSelected: (_) => controller.setSignalType(type),
            backgroundColor: Colors.grey[200],
            selectedColor: Colors.deepPurple,
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.w500,
            ),
          );
        });
      }).toList(),
    );
  }

  Widget _buildControlSlider({
    required String label,
    required double value,
    required double min,
    required double max,
    required Function(double) onChanged,
    required String unit,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
              Text(
                '${value.toStringAsFixed(2)} $unit',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            ],
          ),
          Slider(
            value: value,
            min: min,
            max: max,
            divisions: 100,
            onChanged: onChanged,
            activeColor: Colors.deepPurple,
            inactiveColor: Colors.deepPurple.withOpacity(0.2),
          ),
        ],
      ),
    );
  }
}
