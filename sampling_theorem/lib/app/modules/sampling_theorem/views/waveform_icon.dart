// waveform_icon.dart
import 'dart:math';

import 'package:flutter/material.dart';

class WaveformIcon extends StatelessWidget {
  final double size;
  final Color color;

  const WaveformIcon({
    super.key,
    this.size = 150,
    this.color = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: WaveformPainter(color: color),
    );
  }
}

class WaveformPainter extends CustomPainter {
  final Color color;

  WaveformPainter({this.color = Colors.blue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final centerY = size.height / 2;
    final waveHeight = size.height * 0.4;

    // Draw waveform
    final path = Path();
    final waveCount = 3;
    final waveWidth = size.width / waveCount;

    for (int i = 0; i < waveCount; i++) {
      final startX = i * waveWidth;
      final midX = startX + waveWidth / 2;

      if (i == 0) {
        path.moveTo(startX, centerY);
      }

      // Draw one wave cycle
      path.cubicTo(
        startX + waveWidth * 0.3,
        centerY - waveHeight,
        midX - waveWidth * 0.3,
        centerY - waveHeight,
        midX,
        centerY,
      );

      path.cubicTo(
        midX + waveWidth * 0.3,
        centerY + waveHeight,
        startX + waveWidth * 0.7,
        centerY + waveHeight,
        startX + waveWidth,
        centerY,
      );
    }

    canvas.drawPath(path, paint);

    // Add sampling points
    final samplePaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i <= waveCount * 2; i++) {
      final x = i * (size.width / (waveCount * 2));
      final t = (x / size.width) * 2 * pi;
      final y = centerY - waveHeight * sin(t * 2);

      canvas.drawCircle(Offset(x, y), 3, samplePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
