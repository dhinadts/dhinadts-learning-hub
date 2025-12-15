// app/widgets/audio_waveform_painter.dart
import 'package:flutter/material.dart';

class AudioWaveformPainter extends CustomPainter {
  final List<double> waveformData;
  final bool isRecording;

  AudioWaveformPainter({
    required this.waveformData,
    required this.isRecording,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (waveformData.isEmpty) return;

    // Background
    final bgPaint = Paint()..color = Colors.grey[50]!;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // Grid
    final gridPaint = Paint()
      ..color = Colors.grey[200]!
      ..strokeWidth = 0.5;

    for (double x = 0; x <= size.width; x += size.width / 10) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }

    // Center line
    final centerPaint = Paint()
      ..color = Colors.grey[400]!
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      centerPaint,
    );

    // Waveform
    final wavePaint = Paint()
      ..color = isRecording ? Colors.red : Colors.blue
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color = (isRecording ? Colors.red : Colors.blue).withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final path = Path();
    final xStep = size.width / (waveformData.length - 1);
    final amplitudeScale = size.height / 2;

    for (int i = 0; i < waveformData.length; i++) {
      final x = i * xStep;
      final y = size.height / 2 - waveformData[i] * amplitudeScale;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    // Close the path for fill
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, wavePaint);

    // Draw label
    final textPainter = TextPainter(
      text: TextSpan(
        text: isRecording ? 'RECORDING' : 'WAVEFORM',
        style: TextStyle(
          color: isRecording ? Colors.red : Colors.blue,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(
      canvas,
      Offset(size.width - textPainter.width - 8, 8),
    );
  }

  @override
  bool shouldRepaint(covariant AudioWaveformPainter oldDelegate) {
    return waveformData != oldDelegate.waveformData ||
        isRecording != oldDelegate.isRecording;
  }
}
