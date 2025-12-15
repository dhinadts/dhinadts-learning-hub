// app/widgets/fft_painter.dart
import 'package:flutter/material.dart';

class FFTPainter extends CustomPainter {
  final List<double> data;
  final Color color;
  final bool isFrequencyDomain;

  FFTPainter({
    required this.data,
    required this.color,
    this.isFrequencyDomain = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color = color.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    final gridPaint = Paint()
      ..color = Colors.grey[300]!
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    // Draw grid
    for (double x = 0; x <= size.width; x += size.width / 10) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y <= size.height; y += size.height / 10) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Draw axes
    final axisPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(0, size.height),
      Offset(size.width, size.height),
      axisPaint,
    );

    if (data.length < 2) return;

    // Find max value for scaling
    double maxValue = data.reduce((a, b) => a > b ? a : b);
    if (maxValue == 0) maxValue = 1;

    final path = Path();
    final xStep = size.width / (data.length - 1);

    if (isFrequencyDomain) {
      // Draw bars for frequency domain
      final barWidth = size.width / data.length;

      for (int i = 0; i < data.length; i++) {
        final height = (data[i] / maxValue) * size.height * 0.8;
        final x = i * barWidth;
        final y = size.height - height;

        final rect = Rect.fromLTWH(x, y, barWidth - 1, height);
        canvas.drawRect(rect, fillPaint);
        canvas.drawRect(rect, paint);
      }
    } else {
      // Draw line for time domain
      for (int i = 0; i < data.length; i++) {
        final x = i * xStep;
        final y = size.height / 2 - (data[i] / maxValue) * size.height * 0.4;

        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }

      canvas.drawPath(path, paint);
    }

    // Draw labels
    if (isFrequencyDomain) {
      final textPainter = TextPainter(
        text: const TextSpan(
          text: 'Frequency (Hz) →',
          style: TextStyle(fontSize: 10, color: Colors.grey),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      textPainter.paint(
        canvas,
        Offset(size.width - textPainter.width - 5, size.height - 15),
      );
    }
  }

  @override
  bool shouldRepaint(covariant FFTPainter oldDelegate) {
    return data != oldDelegate.data || color != oldDelegate.color;
  }
}
