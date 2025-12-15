// tutorial_screen.dart
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:get/get.dart';

class TutorialPage extends StatefulWidget {
  const TutorialPage({super.key});

  @override
  State<TutorialPage> createState() => _TutorialPageState();
}

class _TutorialPageState extends State<TutorialPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _frequency = 1.0;
  double _samplingRate = 10.0;
  double _nyquistRate = 2.0;
  bool _showReconstruction = false;
  bool _showAliasing = false;

  @override
  void initState() {
    super.initState();
    _nyquistRate = _frequency * 2;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sampling Theorem Visualizer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: _showInfoDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Controls Panel
          _buildControls(),

          // Visualization Area
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 15.0, left: 15.0, right: 15.0, bottom: 5.0),
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return CustomPaint(
                    painter: WavePainter(
                      time: _controller.value * 2 * pi,
                      frequency: _frequency,
                      samplingRate: _samplingRate,
                      showReconstruction: _showReconstruction,
                      showAliasing: _showAliasing,
                      nyquistRate: _nyquistRate,
                    ),
                    child: Container(),
                  );
                },
              ),
            ),
          ),

          // Tutorial Steps Panel
          Expanded(flex: 6, child: _buildTutorialSteps()),
        ],
      ),
    );
  }

  Widget _buildControls() {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            // Frequency Control
            _buildFrequencyControl(),
            const SizedBox(height: 12),
            // Sampling Rate Control
            _buildSamplingRateControl(),
            const SizedBox(height: 12),
            // Toggle Buttons
            _buildToggleButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildFrequencyControl() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Signal Frequency',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: Slider(
                value: _frequency,
                min: 0.1,
                max: 5.0,
                divisions: 50,
                label: '${_frequency.toStringAsFixed(1)} Hz',
                onChanged: (value) {
                  setState(() {
                    _frequency = value;
                    _nyquistRate = _frequency * 2;
                  });
                },
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 80,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue),
              ),
              child: Column(
                children: [
                  Text(
                    '${_frequency.toStringAsFixed(1)} Hz',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Nyquist: ${_nyquistRate.toStringAsFixed(1)} Hz',
                    style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSamplingRateControl() {
    final isProperSampling = _samplingRate >= _nyquistRate;
    final controlColor = isProperSampling
        ? Colors.green
        : (_showAliasing ? Colors.red : Colors.orange);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Sampling Rate',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: Slider(
                value: _samplingRate,
                min: 1.0,
                max: 30.0,
                divisions: 30,
                label: '${_samplingRate.toStringAsFixed(1)} Hz',
                activeColor: controlColor,
                inactiveColor: controlColor.withOpacity(0.3),
                onChanged: (value) {
                  setState(() => _samplingRate = value);
                },
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 80,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: controlColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: controlColor),
              ),
              child: Column(
                children: [
                  Text(
                    '${_samplingRate.toStringAsFixed(1)} Hz',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: controlColor,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    isProperSampling ? '✓ Above Nyquist' : '⚠ Below Nyquist',
                    style: TextStyle(
                      color: controlColor,
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildToggleButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Reconstruction Toggle
        _buildToggleButton(
          icon: _showReconstruction ? Icons.toggle_on : Icons.toggle_off,
          label: 'Reconstruction',
          isActive: _showReconstruction,
          activeColor: Colors.green,
          description: _samplingRate >= _nyquistRate
              ? 'Proper signal recovery'
              : 'Aliased reconstruction',
          onTap: () =>
              setState(() => _showReconstruction = !_showReconstruction),
        ),
        SizedBox(width: 8),
        // Aliasing Toggle (only enabled when needed)
        _buildToggleButton(
          icon: _showAliasing
              ? Icons.warning_amber
              : _samplingRate < _nyquistRate
                  ? Icons.warning_amber_outlined
                  : Icons.check_circle_outline,
          label: 'Aliasing',
          isActive: _showAliasing,
          activeColor: _samplingRate < _nyquistRate
              ? (_showAliasing ? Colors.red : Colors.orange)
              : Colors.green,
          description: _samplingRate >= _nyquistRate
              ? 'No aliasing possible'
              : (_showAliasing ? 'Showing effect' : 'Aliasing detected'),
          onTap: _samplingRate < _nyquistRate
              ? () => setState(() => _showAliasing = !_showAliasing)
              : null,
        ),
      ],
    );
  }

  Widget _buildToggleButton({
    required IconData icon,
    required String label,
    required bool isActive,
    required Color activeColor,
    required String description,
    required VoidCallback? onTap,
  }) {
    final isEnabled = onTap != null;
    final color = isEnabled ? activeColor : Colors.grey;

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(isActive ? 0.15 : 0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: color.withOpacity(isActive ? 0.8 : 0.3),
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Column(
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: color,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      description,
                      style: TextStyle(
                        color: color,
                        fontSize: 9,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget tutorialDialog() {
    return OutlinedButton(
        onPressed: () {
          Get.dialog(
            AlertDialog(
              title: const Text(
                'Tutorial Steps',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: _buildTutorialSteps(),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ],
            ),
          );
        },
        child: Text('Tutorial Steps'));
  }

  Widget _buildTutorialSteps() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      height: 200,
      color: Colors.grey[50],
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tutorial Steps',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.deepPurpleAccent,
              ),
            ),
            const SizedBox(height: 8),

            // Step 1
            _buildTutorialStep(
              step: 1,
              title: 'Check Nyquist Condition',
              description:
                  'Sampling rate should be ≥ Nyquist rate (${_nyquistRate.toStringAsFixed(1)} Hz)',
              isComplete: _samplingRate >= _nyquistRate,
              color: _samplingRate >= _nyquistRate ? Colors.green : Colors.red,
            ),
            const SizedBox(height: 8),

            // Step 2
            _buildTutorialStep(
              step: 2,
              title: 'Observe Aliasing Effect',
              description: _samplingRate < _nyquistRate
                  ? 'Toggle Aliasing button to see distortion'
                  : 'Lower sampling rate to enable this step',
              isComplete: _samplingRate < _nyquistRate && _showAliasing,
              color: _samplingRate < _nyquistRate
                  ? (_showAliasing ? Colors.orange : Colors.blue)
                  : Colors.grey,
            ),
            const SizedBox(height: 8),

            // Step 3
            _buildTutorialStep(
              step: 3,
              title: 'Signal Reconstruction',
              description: 'Toggle Reconstruction to see signal recovery',
              isComplete: _showReconstruction,
              color: _showReconstruction ? Colors.blue : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  /* Widget _buildTutorialSteps() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      height: MediaQuery.of(context).size.height * 0.25,
      color: Colors.grey[50],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tutorial Steps',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.deepPurpleAccent),
          ),
          const SizedBox(height: 8),
          // Step 1: Check Nyquist
          _buildTutorialStep(
            step: 1,
            title: 'Check Nyquist Condition',
            description: 'Sampling rate should be ≥ Nyquist rate '
                '(${_nyquistRate.toStringAsFixed(1)} Hz)',
            isComplete: _samplingRate >= _nyquistRate,
            color: _samplingRate >= _nyquistRate ? Colors.green : Colors.red,
          ),
          const SizedBox(height: 8),
          // Step 2: Observe Aliasing
          _buildTutorialStep(
            step: 2,
            title: 'Observe Aliasing Effect',
            description: _samplingRate < _nyquistRate
                ? 'Toggle Aliasing button to see distortion'
                : 'Lower sampling rate to enable this step',
            isComplete: _samplingRate < _nyquistRate && _showAliasing,
            color: _samplingRate < _nyquistRate
                ? (_showAliasing ? Colors.orange : Colors.blue)
                : Colors.grey,
          ),
          const SizedBox(height: 8),
          // Step 3: Signal Reconstruction
          _buildTutorialStep(
            step: 3,
            title: 'Signal Reconstruction',
            description: 'Toggle Reconstruction to see signal recovery',
            isComplete: _showReconstruction,
            color: _showReconstruction ? Colors.blue : Colors.grey,
          ),
        ],
      ),
    );
  }
 */
  Widget _buildTutorialStep({
    required int step,
    required String title,
    required String description,
    required bool isComplete,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: isComplete
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : Text(
                      step.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(
                    color: color.withOpacity(0.9),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showInfoDialog() {
    final isProperSampling = _samplingRate >= _nyquistRate;
    final statusColor = isProperSampling ? Colors.green : Colors.orange;
    final statusIcon = isProperSampling ? Icons.check_circle : Icons.warning;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Sampling Theorem',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Nyquist-Shannon Theorem:\n'
                'A signal can be perfectly reconstructed if sampled at least twice its highest frequency.',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 20),
              // Current Status Card
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: statusColor),
                ),
                child: Row(
                  children: [
                    Icon(statusIcon, color: statusColor),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isProperSampling
                                ? 'Proper Sampling'
                                : 'Aliasing Risk',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: statusColor,
                            ),
                          ),
                          Text(
                            'Signal: ${_frequency.toStringAsFixed(1)} Hz\n'
                            'Sampling: ${_samplingRate.toStringAsFixed(1)} Hz\n'
                            'Nyquist: ${_nyquistRate.toStringAsFixed(1)} Hz',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              if (!isProperSampling)
                const Text(
                  '⚠ To avoid aliasing:\n'
                  '1. Increase sampling rate above Nyquist\n'
                  '2. Apply anti-aliasing filter before sampling',
                  style: TextStyle(fontSize: 12),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Got it!'),
            ),
          ],
        );
      },
    );
  }
}

class WavePainter extends CustomPainter {
  final double time;
  final double frequency;
  final double samplingRate;
  final bool showReconstruction;
  final bool showAliasing;
  final double nyquistRate;
  final List<Offset> samplePoints = [];

  WavePainter({
    required this.time,
    required this.frequency,
    required this.samplingRate,
    required this.showReconstruction,
    required this.showAliasing,
    required this.nyquistRate,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final centerY = size.height / 2;

    // Clear stored points
    samplePoints.clear();

    // 1. Draw grid and axes
    _drawGridAndAxes(canvas, size);

    // 2. Draw aliasing signal first (behind everything)
    if (showAliasing && samplingRate < nyquistRate) {
      _drawAliasingSignal(canvas, size, centerY);
    }

    // 3. Draw original signal
    _drawOriginalSignal(canvas, size, centerY);

    // 4. Draw sampling points and store them
    _drawSamplingPoints(canvas, size, centerY);

    // 5. Draw reconstruction (on top)
    if (showReconstruction) {
      _drawReconstruction(canvas, size, centerY);
    }

    // 6. Draw labels and info
    _drawLabelsAndInfo(canvas, size);

    // 7. Draw warnings if needed
    if (samplingRate < nyquistRate) {
      _drawAliasingWarning(canvas, size);
    }
  }

  void _drawGridAndAxes(Canvas canvas, Size size) {
    // Grid lines
    final gridPaint = Paint()
      ..color = Colors.grey[300]!
      ..strokeWidth = 0.5;

    for (double x = 0; x <= size.width; x += 20) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y <= size.height; y += 20) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Center axis (x-axis)
    final axisPaint = Paint()
      ..color = Colors.grey[600]!
      ..strokeWidth = 1.5;
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      axisPaint,
    );
  }

  void _drawOriginalSignal(Canvas canvas, Size size, double centerY) {
    final signalPaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final amplitude = size.height / 3;

    // Start the path
    final startY = centerY - amplitude * sin(frequency * time);
    path.moveTo(0, startY);

    // Draw the sine wave
    for (double x = 0; x <= size.width; x++) {
      final t = time + (x / size.width) * 4 * pi;
      final y = centerY - amplitude * sin(frequency * t);
      path.lineTo(x, y);
    }

    canvas.drawPath(path, signalPaint);
  }

  void _drawSamplingPoints(Canvas canvas, Size size, double centerY) {
    final samplePaint = Paint()
      ..color = _getSampleColor()
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    final amplitude = size.height / 3;

    // Calculate sample interval in pixels
    // We show 4π seconds across the width, so pixels per second = size.width / (4π)
    final pixelsPerSecond = size.width / (4 * pi);
    final sampleIntervalSeconds = 1.0 / samplingRate;
    final sampleInterval = pixelsPerSecond * sampleIntervalSeconds;

    for (double x = 0; x <= size.width; x += sampleInterval) {
      final t = time + (x / size.width) * 4 * pi;
      final y = centerY - amplitude * sin(frequency * t);

      // Draw the sample point
      canvas.drawCircle(Offset(x, y), 4, samplePaint);
      samplePoints.add(Offset(x, y));

      // Draw connection line to axis
      final linePaint = Paint()
        ..color = _getSampleColor().withOpacity(0.2)
        ..strokeWidth = 1;
      canvas.drawLine(Offset(x, y), Offset(x, centerY), linePaint);
    }
  }

  Color _getSampleColor() {
    if (samplingRate >= nyquistRate) {
      return Colors.green;
    } else {
      return showAliasing ? Colors.red : Colors.orange;
    }
  }

  void _drawReconstruction(Canvas canvas, Size size, double centerY) {
    final reconstructionPaint = Paint()
      ..color = _getReconstructionColor()
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final amplitude = size.height / 3;
    final path = Path();

    if (samplingRate >= nyquistRate) {
      // Proper reconstruction using sinc interpolation
      final sampleInterval = size.width / (samplingRate * 2);

      for (double x = 0; x <= size.width; x += 1.0) {
        double reconstructedY = 0.0;
        double totalWeight = 0.0;

        for (final sample in samplePoints) {
          final dx = (x - sample.dx) / sampleInterval;

          if (dx.abs() < 0.001) {
            reconstructedY += sample.dy;
            totalWeight += 1.0;
          } else {
            final sincValue = sin(pi * dx) / (pi * dx);
            reconstructedY += sample.dy * sincValue;
            totalWeight += sincValue.abs();
          }
        }

        final y = totalWeight > 0 ? reconstructedY / totalWeight : centerY;

        if (x == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
    } else if (showAliasing) {
      // Show aliased reconstruction
      final aliasingFreq = (samplingRate - frequency).abs();
      for (double x = 0; x <= size.width; x += 1.0) {
        final t = time + (x / size.width) * 4 * pi;
        final y = centerY - amplitude * sin(aliasingFreq * t);

        if (x == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
    }

    canvas.drawPath(path, reconstructionPaint);
  }

  Color _getReconstructionColor() {
    if (samplingRate >= nyquistRate) {
      return Colors.green;
    } else {
      return showAliasing ? Colors.orange : Colors.green.withOpacity(0.3);
    }
  }

  void _drawAliasingSignal(Canvas canvas, Size size, double centerY) {
    final aliasingPaint = Paint()
      ..color = Colors.red.withOpacity(0.6)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final amplitude = size.height / 3;
    final aliasingFreq = (samplingRate - frequency).abs();
    final path = Path();

    // Draw aliasing signal
    path.moveTo(0, centerY - amplitude * sin(aliasingFreq * time));
    for (double x = 0; x <= size.width; x++) {
      final t = time + (x / size.width) * 4 * pi;
      final y = centerY - amplitude * sin(aliasingFreq * t);
      path.lineTo(x, y);
    }

    canvas.drawPath(path, aliasingPaint);
  }

  void _drawAliasingWarning(Canvas canvas, Size size) {
    final textStyle = TextStyle(
      color: showAliasing ? Colors.red : Colors.orange,
      fontSize: 13,
      fontWeight: FontWeight.bold,
    );

    final aliasingFreq = (samplingRate - frequency).abs();
    final message = showAliasing
        ? '⚠ ALIASING: ${frequency.toStringAsFixed(1)}Hz → ${aliasingFreq.toStringAsFixed(1)}Hz'
        : '⚠ ALIASING RISK: Increase sampling rate';

    final textPainter = TextPainter(
      text: TextSpan(text: message, style: textStyle),
      textDirection: TextDirection.ltr,
    )..layout();

    // Draw background
    final bgRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(size.width / 2, 25),
        width: textPainter.width + 20,
        height: textPainter.height + 12,
      ),
      const Radius.circular(8),
    );

    final bgPaint = Paint()
      ..color = showAliasing
          ? Colors.red.withOpacity(0.9)
          : Colors.orange.withOpacity(0.9)
      ..style = PaintingStyle.fill;

    canvas.drawRRect(bgRect, bgPaint);

    // Draw text
    textPainter.paint(
      canvas,
      Offset((size.width - textPainter.width) / 2, 25 - textPainter.height / 2),
    );
  }

  void _drawLabelsAndInfo(Canvas canvas, Size size) {
    const textStyle = TextStyle(
      color: Colors.black,
      fontSize: 11,
    );

    // X-axis label
    final xLabelPainter = TextPainter(
      text: const TextSpan(text: 'Time →', style: textStyle),
      textDirection: TextDirection.ltr,
    )..layout();

    xLabelPainter.paint(
      canvas,
      Offset(size.width - xLabelPainter.width - 8, size.height - 18),
    );

    // Y-axis label
    final yLabelPainter = TextPainter(
      text: const TextSpan(text: 'Amplitude', style: textStyle),
      textDirection: TextDirection.ltr,
    )..layout();

    canvas.save();
    canvas.translate(12, size.height / 2 + yLabelPainter.width / 2);
    canvas.rotate(-pi / 2);
    yLabelPainter.paint(canvas, Offset.zero);
    canvas.restore();

    // Bottom info
    final statusColor = samplingRate >= nyquistRate
        ? Colors.green
        : (showAliasing ? Colors.red : Colors.orange);

    final infoText = 'Signal: ${frequency.toStringAsFixed(1)}Hz  |  '
        'Sampling: ${samplingRate.toStringAsFixed(1)}Hz  |  '
        'Nyquist: ${nyquistRate.toStringAsFixed(1)}Hz';

    final infoPainter = TextPainter(
      text: TextSpan(
        text: infoText,
        style: TextStyle(
          color: statusColor,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: size.width - 16);

    infoPainter.paint(
      canvas,
      Offset((size.width - infoPainter.width) / 2, size.height - 30),
    );
  }

  @override
  bool shouldRepaint(covariant WavePainter oldDelegate) {
    return time != oldDelegate.time ||
        frequency != oldDelegate.frequency ||
        samplingRate != oldDelegate.samplingRate ||
        showReconstruction != oldDelegate.showReconstruction ||
        showAliasing != oldDelegate.showAliasing ||
        nyquistRate != oldDelegate.nyquistRate;
  }
}
