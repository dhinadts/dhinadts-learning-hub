// tutorial_screen.dart
import 'package:flutter/material.dart';
import 'dart:math';

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({super.key});

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _frequency = 1.0;
  double _samplingRate = 10.0;
  double _nyquistRate = 2.0;
  bool _showReconstruction = false;
  bool _showAliasing = false;

  final List<double> _samples = [];
  final List<Offset> _samplePoints = [];

  @override
  void initState() {
    super.initState();
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
          IconButton(icon: const Icon(Icons.info), onPressed: _showInfoDialog),
        ],
      ),
      body: Column(
        children: [
          // Controls
          _buildControls(),

          // Visualization Area
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
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

          // Tutorial Steps
          Expanded(child: _buildTutorialSteps()),
        ],
      ),
    );
  }

  Widget _buildControls() {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Signal Frequency:'),
                      Row(
                        children: [
                          Expanded(
                            child: Slider(
                              value: _frequency,
                              min: 0.1,
                              max: 5.0,
                              divisions: 50,
                              onChanged: (value) {
                                setState(() {
                                  _frequency = value;
                                  _nyquistRate = _frequency * 2;
                                });
                              },
                            ),
                          ),
                          Container(
                            width: 60,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${_frequency.toStringAsFixed(1)} Hz',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'Nyquist Rate: ${_nyquistRate.toStringAsFixed(1)} Hz',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Sampling Rate:'),
                      Row(
                        children: [
                          Expanded(
                            child: Slider(
                              value: _samplingRate,
                              min: 1.0,
                              max: 30.0,
                              divisions: 30,
                              onChanged: (value) {
                                setState(() => _samplingRate = value);
                              },
                            ),
                          ),
                          Container(
                            width: 60,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: _getSamplingRateColor().withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${_samplingRate.toStringAsFixed(1)} Hz',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: _getSamplingRateColor(),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        _samplingRate >= _nyquistRate
                            ? '✓ Above Nyquist'
                            : '⚠ Below Nyquist',
                        style: TextStyle(
                          color: _samplingRate >= _nyquistRate
                              ? Colors.green
                              : Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Reconstruction Toggle
                Container(
                  decoration: BoxDecoration(
                    color: _showReconstruction
                        ? Colors.green.withOpacity(0.1)
                        : Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: _showReconstruction ? Colors.green : Colors.grey,
                      width: 2,
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                        setState(
                            () => _showReconstruction = !_showReconstruction);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Icon(
                              _showReconstruction
                                  ? Icons.toggle_on
                                  : Icons.toggle_off,
                              color: _showReconstruction
                                  ? Colors.green
                                  : Colors.grey,
                              size: 30,
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Reconstruction',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: _showReconstruction
                                        ? Colors.green
                                        : Colors.grey,
                                  ),
                                ),
                                Text(
                                  _samplingRate >= _nyquistRate
                                      ? 'Shows recovered signal'
                                      : 'Shows aliased signal',
                                  style: const TextStyle(fontSize: 10),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Aliasing Toggle
                Container(
                  decoration: BoxDecoration(
                    color: _showAliasing
                        ? Colors.red.withOpacity(0.1)
                        : (_samplingRate < _nyquistRate
                            ? Colors.orange.withOpacity(0.1)
                            : Colors.grey.withOpacity(0.1)),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: _showAliasing
                          ? Colors.red
                          : (_samplingRate < _nyquistRate
                              ? Colors.orange
                              : Colors.grey),
                      width: 2,
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                        if (_samplingRate < _nyquistRate) {
                          setState(() => _showAliasing = !_showAliasing);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Icon(
                              _showAliasing
                                  ? Icons.warning_amber
                                  : (_samplingRate < _nyquistRate
                                      ? Icons.warning_amber_outlined
                                      : Icons.check_circle_outline),
                              color: _showAliasing
                                  ? Colors.red
                                  : (_samplingRate < _nyquistRate
                                      ? Colors.orange
                                      : Colors.green),
                              size: 30,
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Aliasing',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: _showAliasing
                                        ? Colors.red
                                        : (_samplingRate < _nyquistRate
                                            ? Colors.orange
                                            : Colors.green),
                                  ),
                                ),
                                Text(
                                  _samplingRate >= _nyquistRate
                                      ? 'No aliasing'
                                      : (_showAliasing
                                          ? 'Showing aliasing effect'
                                          : 'Aliasing detected'),
                                  style: const TextStyle(fontSize: 10),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getSamplingRateColor() {
    if (_samplingRate >= _nyquistRate) {
      return Colors.green;
    } else {
      return _showAliasing ? Colors.red : Colors.orange;
    }
  }

  /* Widget _buildControls() {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Signal Frequency: ${_frequency.toStringAsFixed(1)} Hz',
                      ),
                      Slider(
                        value: _frequency,
                        min: 0.1,
                        max: 5.0,
                        divisions: 50,
                        onChanged: (value) {
                          setState(() {
                            _frequency = value;
                            _nyquistRate = _frequency * 2;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sampling Rate: ${_samplingRate.toStringAsFixed(1)} Hz',
                      ),
                      Slider(
                        value: _samplingRate,
                        min: 1.0,
                        max: 30.0,
                        divisions: 30,
                        onChanged: (value) {
                          setState(() => _samplingRate = value);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() => _showReconstruction = !_showReconstruction);
                  },
                  icon: Icon(
                    _showReconstruction
                        ? Icons.check_box
                        : Icons.check_box_outline_blank,
                  ),
                  label: const Text('Show Reconstruction'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() => _showAliasing = !_showAliasing);
                  },
                  icon: Icon(
                    _showAliasing ? Icons.warning : Icons.warning_outlined,
                  ),
                  label: const Text('Show Aliasing'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

   */

  Widget _buildTutorialSteps() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey[50],
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tutorial Steps:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),

            // Step 1
            Container(
              decoration: BoxDecoration(
                color: _samplingRate >= _nyquistRate
                    ? Colors.green.withOpacity(0.1)
                    : Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color:
                      _samplingRate >= _nyquistRate ? Colors.green : Colors.red,
                  width: 1,
                ),
              ),
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: _samplingRate >= _nyquistRate
                          ? Colors.green
                          : Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        _samplingRate >= _nyquistRate
                            ? Icons.check
                            : Icons.close,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Step 1: Verify Sampling Rate',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _samplingRate >= _nyquistRate
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                        Text(
                          'Sampling rate (${_samplingRate.toStringAsFixed(1)} Hz) should be ≥ Nyquist rate (${_nyquistRate.toStringAsFixed(1)} Hz)',
                          style: TextStyle(
                            color: _samplingRate >= _nyquistRate
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Step 2
            Container(
              decoration: BoxDecoration(
                color: _samplingRate < _nyquistRate && _showAliasing
                    ? Colors.orange.withOpacity(0.1)
                    : Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _samplingRate < _nyquistRate && _showAliasing
                      ? Colors.orange
                      : Colors.grey,
                  width: 1,
                ),
              ),
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: _samplingRate < _nyquistRate && _showAliasing
                          ? Colors.orange
                          : Colors.grey,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '2',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Step 2: Observe Aliasing',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          _samplingRate < _nyquistRate
                              ? 'Set sampling rate below Nyquist and toggle "Show Aliasing"'
                              : 'Increase signal frequency to see this step',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Step 3
            Container(
              decoration: BoxDecoration(
                color: _showReconstruction
                    ? Colors.blue.withOpacity(0.1)
                    : Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _showReconstruction ? Colors.blue : Colors.grey,
                  width: 1,
                ),
              ),
              padding: const EdgeInsets.all(8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: _showReconstruction ? Colors.blue : Colors.grey,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '3',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Step 3: Signal Reconstruction',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color:
                                _showReconstruction ? Colors.blue : Colors.grey,
                          ),
                        ),
                        Text(
                          'Toggle "Reconstruction" to see how sampling affects signal recovery',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      
    );
    
  }

  /* Widget _buildTutorialSteps() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey[100],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tutorial Steps:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 10),
          _buildStep(
            1,
            'Adjust signal frequency and observe Nyquist rate (${_nyquistRate.toStringAsFixed(1)} Hz)',
            _samplingRate >= _nyquistRate ? Colors.green : Colors.red,
          ),
          _buildStep(
            2,
            'Set sampling rate below Nyquist rate to see aliasing',
            _showAliasing ? Colors.orange : Colors.grey,
          ),
          _buildStep(
            3,
            'Enable reconstruction to see how original signal is recovered',
            _showReconstruction ? Colors.blue : Colors.grey,
          ),
        ],
      ),
    );
  }

   */
  Widget _buildStep(int number, String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Center(
              child: Text(
                number.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sampling Theorem'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Nyquist-Shannon Sampling Theorem:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  'A continuous-time signal can be completely represented in its samples and recovered back if the sampling frequency (Fs) is greater than twice the maximum frequency (Fmax) present in the signal.',
                ),
                const SizedBox(height: 20),
                Text(
                  'Nyquist Rate: ${(_frequency * 2).toStringAsFixed(1)} Hz',
                  style: TextStyle(
                    color: _samplingRate >= _nyquistRate
                        ? Colors.green
                        : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Current Sampling: ${_samplingRate.toStringAsFixed(1)} Hz',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  _samplingRate >= _nyquistRate
                      ? '✓ Sampling rate is sufficient'
                      : '⚠ Sampling rate is too low (aliasing may occur)',
                  style: TextStyle(
                    color: _samplingRate >= _nyquistRate
                        ? Colors.green
                        : Colors.orange,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
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
  final List<Offset> samplePoints = []; // Add this line

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

    // Clear previous samples at the start
    samplePoints.clear();

    // Draw grid
    _drawGrid(canvas, size);

    // Draw original signal
    _drawOriginalSignal(canvas, size, centerY);

    // Draw sampling points
    _drawSamplingPoints(canvas, size, centerY);

    // Draw reconstruction if enabled
    if (showReconstruction) {
      _drawReconstruction(canvas, size, centerY);
    }

    // Draw aliasing if enabled
    if (showAliasing && samplingRate < nyquistRate) {
      _drawAliasingSignal(canvas, size, centerY);
    }

    // Draw axes labels
    _drawLabels(canvas, size);

    // Draw warning if aliasing would occur
    _drawAliasingWarning(canvas, size);
  }

  void _drawOriginalSignal(Canvas canvas, Size size, double centerY) {
    final signalPaint = Paint()
      ..color = Colors.blue.withOpacity(0.8)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final path = Path();
    final amplitude = size.height / 3;

    path.moveTo(0, centerY - amplitude * sin(frequency * time));

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
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final amplitude = size.height / 3;
    final sampleInterval = size.width / (samplingRate * 2);

    for (double x = 0; x <= size.width; x += sampleInterval) {
      final t = time + (x / size.width) * 4 * pi;
      final y = centerY - amplitude * sin(frequency * t);

      canvas.drawCircle(Offset(x, y), 4, samplePaint);
      samplePoints.add(Offset(x, y)); // Store the point

      // Draw vertical line to axis
      final linePaint = Paint()
        ..color = _getSampleColor().withOpacity(0.3)
        ..strokeWidth = 1;
      canvas.drawLine(
        Offset(x, y),
        Offset(x, centerY),
        linePaint,
      );
    }
  }

  Color _getSampleColor() {
    if (samplingRate < nyquistRate) {
      return showAliasing ? Colors.red : Colors.orange;
    } else {
      return Colors.green;
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
    final sampleInterval = size.width / (samplingRate * 2);

    if (samplingRate >= nyquistRate) {
      // Proper reconstruction using sinc interpolation
      for (double x = 0; x <= size.width; x += 0.5) {
        double y = 0;
        double totalWeight = 0;

        for (int n = 0; n < samplePoints.length; n++) {
          final samplePoint = samplePoints[n];
          if (samplePoint.dx < 0 || samplePoint.dx > size.width) continue;

          // Sinc interpolation
          final sincArg = (x - samplePoint.dx) / sampleInterval;
          if (sincArg.abs() < 0.001) {
            y += samplePoint.dy;
            totalWeight += 1;
          } else {
            final sincValue = sin(pi * sincArg) / (pi * sincArg);
            y += samplePoint.dy * sincValue;
            totalWeight += sincValue.abs();
          }
        }

        if (totalWeight > 0) {
          y /= totalWeight;
        }

        if (x == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }

      canvas.drawPath(path, reconstructionPaint);
    } else if (showAliasing) {
      // When aliasing occurs, show what the reconstructed signal would look like
      final aliasingFreq = samplingRate - frequency;
      for (double x = 0; x <= size.width; x += 0.5) {
        final t = time + (x / size.width) * 4 * pi;
        final y = centerY - amplitude * sin(aliasingFreq.abs() * t);

        if (x == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }

      canvas.drawPath(path, reconstructionPaint);
    }
  }

  Color _getReconstructionColor() {
    if (samplingRate < nyquistRate) {
      return showAliasing ? Colors.orange : Colors.green.withOpacity(0.5);
    } else {
      return Colors.green;
    }
  }

  void _drawAliasingSignal(Canvas canvas, Size size, double centerY) {
    final aliasingPaint = Paint()
      ..color = Colors.red.withOpacity(0.7)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final amplitude = size.height / 3;
    final aliasingFreq = (samplingRate - frequency).abs();
    final path = Path();

    path.moveTo(0, centerY - amplitude * sin(aliasingFreq * time));

    for (double x = 0; x <= size.width; x++) {
      final t = time + (x / size.width) * 4 * pi;
      final y = centerY - amplitude * sin(aliasingFreq * t);
      path.lineTo(x, y);
    }

    canvas.drawPath(path, aliasingPaint);

    // Fill the area between original and aliasing signal
    final fillPath = Path();
    fillPath.moveTo(0, centerY - amplitude * sin(frequency * time));

    // Original signal top path
    for (double x = 0; x <= size.width; x++) {
      final t = time + (x / size.width) * 4 * pi;
      final y = centerY - amplitude * sin(frequency * t);

      if (x == 0) {
        fillPath.moveTo(x, y);
      } else {
        fillPath.lineTo(x, y);
      }
    }

    // Aliasing signal bottom path (reverse)
    for (double x = size.width; x >= 0; x--) {
      final t = time + (x / size.width) * 4 * pi;
      final y = centerY - amplitude * sin(aliasingFreq * t);
      fillPath.lineTo(x, y);
    }

    final fillPaint = Paint()
      ..color = Colors.red.withOpacity(0.15)
      ..style = PaintingStyle.fill;

    canvas.drawPath(fillPath, fillPaint);
  }

  void _drawAliasingWarning(Canvas canvas, Size size) {
    if (samplingRate < nyquistRate) {
      final textStyle = TextStyle(
        color: showAliasing ? Colors.red : Colors.orange,
        fontSize: 14,
        fontWeight: FontWeight.bold,
        shadows: [
          Shadow(
            color: Colors.white.withOpacity(0.8),
            blurRadius: 4,
            offset: const Offset(1, 1),
          ),
        ],
      );

      final aliasingFreq = (samplingRate - frequency).abs();
      String message;
      Color bgColor;

      if (showAliasing) {
        message = '⚠ ALIASING ACTIVE!\n'
            '${frequency.toStringAsFixed(1)} Hz appears as '
            '${aliasingFreq.toStringAsFixed(1)} Hz';
        bgColor = Colors.red.withOpacity(0.9);
      } else {
        message = '⚠ ALIASING DETECTED!\n'
            'Sampling rate is below Nyquist rate\n'
            'Toggle "Show Aliasing" to visualize';
        bgColor = Colors.orange.withOpacity(0.9);
      }

      final textSpan = TextSpan(text: message, style: textStyle);
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      )..layout(maxWidth: size.width - 20);

      // Draw background
      final bgRect = RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(size.width / 2, 40),
          width: textPainter.width + 20,
          height: textPainter.height + 15,
        ),
        const Radius.circular(10),
      );

      final bgPaint = Paint()
        ..color = bgColor
        ..style = PaintingStyle.fill;

      canvas.drawRRect(bgRect, bgPaint);

      // Draw border
      final borderPaint = Paint()
        ..color = showAliasing ? Colors.red : Colors.orange
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;

      canvas.drawRRect(bgRect, borderPaint);

      // Draw text
      textPainter.paint(
        canvas,
        Offset(
          (size.width - textPainter.width) / 2,
          40 - textPainter.height / 2,
        ),
      );
    }
  }

  void _drawGrid(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = Colors.grey[300]!
      ..strokeWidth = 0.5;

    // Vertical lines
    for (double x = 0; x <= size.width; x += 20) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        gridPaint,
      );
    }

    // Horizontal lines
    for (double y = 0; y <= size.height; y += 20) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        gridPaint,
      );
    }

    // Center line
    final centerLinePaint = Paint()
      ..color = Colors.grey[500]!
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      centerLinePaint,
    );
  }

  void _drawLabels(Canvas canvas, Size size) {
    const textStyle = TextStyle(
      color: Colors.black,
      fontSize: 12,
    );

    // Frequency info with color coding
    Color samplingColor;
    String samplingStatus;

    if (samplingRate >= nyquistRate) {
      samplingColor = Colors.green;
      samplingStatus = '✓ Proper';
    } else {
      samplingColor = showAliasing ? Colors.red : Colors.orange;
      samplingStatus = showAliasing ? '✗ Aliasing' : '⚠ Warning';
    }

    // X-axis label
    final xLabelPainter = TextPainter(
      text: const TextSpan(text: 'Time', style: textStyle),
      textDirection: TextDirection.ltr,
    )..layout();

    xLabelPainter.paint(
      canvas,
      Offset(size.width - xLabelPainter.width - 5, size.height - 15),
    );

    // Y-axis label
    final yLabelPainter = TextPainter(
      text: const TextSpan(text: 'Amplitude', style: textStyle),
      textDirection: TextDirection.ltr,
    )..layout();

    canvas.save();
    canvas.translate(15, 15);
    canvas.rotate(-pi / 2);
    yLabelPainter.paint(canvas, Offset.zero);
    canvas.restore();

    // Bottom info bar
    final infoPainter = TextPainter(
      text: TextSpan(
        children: [
          const WidgetSpan(
            child: Icon(Icons.waves, size: 14, color: Colors.blue),
          ),
          TextSpan(
            text: ' ${frequency.toStringAsFixed(1)}Hz ',
            style: const TextStyle(
                color: Colors.blue, fontWeight: FontWeight.bold),
          ),
          const TextSpan(text: '|'),
          const WidgetSpan(
            child: Icon(Icons.speed, size: 14, color: Colors.green),
          ),
          TextSpan(
            text: ' ${samplingRate.toStringAsFixed(1)}Hz ',
            style: TextStyle(
              color: samplingColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const TextSpan(text: '|'),
          const WidgetSpan(
            child: Icon(Icons.science, size: 14, color: Colors.purple),
          ),
          TextSpan(
            text: ' ${nyquistRate.toStringAsFixed(1)}Hz ',
            style: const TextStyle(
                color: Colors.purple, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      textDirection: TextDirection.ltr,
    )..layout();

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
/* class WavePainter extends CustomPainter {
  final double time;
  final double frequency;
  final double samplingRate;
  final bool showReconstruction;
  final bool showAliasing;
  final double nyquistRate;

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
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Draw grid
    _drawGrid(canvas, size);

    // Draw original signal
    _drawOriginalSignal(canvas, size, centerY);

    // Draw sampling points
    _drawSamplingPoints(canvas, size, centerY);

    // Draw reconstruction if enabled
    if (showReconstruction) {
      _drawReconstruction(canvas, size, centerY);
    }

    // Draw aliasing if enabled and sampling rate is low
    if (showAliasing && samplingRate < nyquistRate) {
      _drawAliasingSignal(canvas, size, centerY);
    }

    // Draw axes labels
    _drawLabels(canvas, size);
  }

  void _drawGrid(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = Colors.grey[300]!
      ..strokeWidth = 0.5;

    // Vertical lines
    for (double x = 0; x <= size.width; x += 20) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }

    // Horizontal lines
    for (double y = 0; y <= size.height; y += 20) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Center line
    final centerLinePaint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      centerLinePaint,
    );
  }

  void _drawOriginalSignal(Canvas canvas, Size size, double centerY) {
    final signalPaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final path = Path();
    final amplitude = size.height / 3;

    path.moveTo(0, centerY - amplitude * sin(frequency * time));

    for (double x = 0; x <= size.width; x++) {
      final t = time + (x / size.width) * 4 * pi;
      final y = centerY - amplitude * sin(frequency * t);
      path.lineTo(x, y);
    }

    canvas.drawPath(path, signalPaint);
  }

  void _drawSamplingPoints(Canvas canvas, Size size, double centerY) {
    final samplePaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final amplitude = size.height / 3;
    final sampleInterval = size.width / (samplingRate * 2);

    for (double x = 0; x <= size.width; x += sampleInterval) {
      final t = time + (x / size.width) * 4 * pi;
      final y = centerY - amplitude * sin(frequency * t);

      canvas.drawCircle(Offset(x, y), 4, samplePaint);

      // Draw vertical line to axis
      final linePaint = Paint()
        ..color = Colors.red.withOpacity(0.3)
        ..strokeWidth = 1;
      canvas.drawLine(Offset(x, y), Offset(x, centerY), linePaint);
    }
  }

  void _drawReconstruction(Canvas canvas, Size size, double centerY) {
    final reconstructionPaint = Paint()
      ..color = Colors.green
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    if (samplingRate >= nyquistRate) {
      final amplitude = size.height / 3;
      final path = Path();
      final sampleInterval = size.width / (samplingRate * 2);

      for (double x = 0; x <= size.width; x++) {
        double y = 0;
        for (double n = 0; n * sampleInterval <= size.width; n++) {
          final sampleX = n * sampleInterval;
          final t = time + (sampleX / size.width) * 4 * pi;
          final sampleY = centerY - amplitude * sin(frequency * t);

          // Sinc interpolation
          final sincArg = (x - sampleX) / sampleInterval;
          if (sincArg == 0) continue;
          final sincValue = sin(pi * sincArg) / (pi * sincArg);
          y += sampleY * sincValue;
        }
        if (x == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }

      canvas.drawPath(path, reconstructionPaint);
    }
  }

  void _drawAliasingSignal(Canvas canvas, Size size, double centerY) {
    final aliasingPaint = Paint()
      ..color = Colors.orange
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final aliasingFreq = samplingRate - frequency;
    final amplitude = size.height / 3;
    final path = Path();

    path.moveTo(0, centerY - amplitude * sin(aliasingFreq * time));

    for (double x = 0; x <= size.width; x++) {
      final t = time + (x / size.width) * 4 * pi;
      final y = centerY - amplitude * sin(aliasingFreq * t);
      path.lineTo(x, y);
    }

    canvas.drawPath(path, aliasingPaint);

    // Draw aliasing warning text
    final textStyle = TextStyle(
      color: Colors.orange[800],
      fontSize: 14,
      fontWeight: FontWeight.bold,
    );

    final textSpan = TextSpan(
      text:
          'Aliasing!\n'
          '${frequency.toStringAsFixed(1)} Hz appears as '
          '${aliasingFreq.abs().toStringAsFixed(1)} Hz',
      style: textStyle,
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(canvas, Offset(size.width - textPainter.width - 10, 10));
  }

  void _drawLabels(Canvas canvas, Size size) {
    const textStyle = TextStyle(color: Colors.black, fontSize: 12);

    // X-axis label
    final xLabelPainter = TextPainter(
      text: const TextSpan(text: 'Time', style: textStyle),
      textDirection: TextDirection.ltr,
    )..layout();

    xLabelPainter.paint(
      canvas,
      Offset(size.width - xLabelPainter.width - 5, size.height - 15),
    );

    // Y-axis label
    final yLabelPainter = TextPainter(
      text: const TextSpan(text: 'Amplitude', style: textStyle),
      textDirection: TextDirection.ltr,
    )..layout();

    canvas.save();
    canvas.translate(15, 15);
    canvas.rotate(-pi / 2);
    yLabelPainter.paint(canvas, Offset.zero);
    canvas.restore();

    // Frequency info
    final infoText =
        'Signal: ${frequency.toStringAsFixed(1)} Hz | '
        'Sampling: ${samplingRate.toStringAsFixed(1)} Hz | '
        'Nyquist: ${nyquistRate.toStringAsFixed(1)} Hz';

    final infoPainter = TextPainter(
      text: TextSpan(
        text: infoText,
        style: const TextStyle(
          color: Colors.blue,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    infoPainter.paint(canvas, Offset((size.width - infoPainter.width) / 2, 5));
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
 */
