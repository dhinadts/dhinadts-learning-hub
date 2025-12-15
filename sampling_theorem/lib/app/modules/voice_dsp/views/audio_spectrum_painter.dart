// app/widgets/audio_spectrum_painter.dart
import 'package:flutter/material.dart';

class AudioSpectrumPainter extends CustomPainter {
  final List<double> spectrumData;
  final bool isActive;

  AudioSpectrumPainter({
    required this.spectrumData,
    required this.isActive,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (spectrumData.isEmpty) return;

    // Background
    final bgPaint = Paint()..color = Colors.grey[50]!;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // Spectrum bars
    final barWidth = size.width / spectrumData.length;

    for (int i = 0; i < spectrumData.length; i++) {
      final height = spectrumData[i] * size.height * 0.8;
      final x = i * barWidth;
      final y = size.height - height;

      // Gradient color based on frequency
      final color = Color.lerp(
        Colors.blue,
        Colors.red,
        i / spectrumData.length,
      )!;

      final barPaint = Paint()
        ..color = color.withOpacity(isActive ? 0.8 : 0.3)
        ..style = PaintingStyle.fill;

      final borderPaint = Paint()
        ..color = color
        ..strokeWidth = 1
        ..style = PaintingStyle.stroke;

      final rect = Rect.fromLTWH(x, y, barWidth - 1, height);
      canvas.drawRect(rect, barPaint);
      canvas.drawRect(rect, borderPaint);
    }

    // Draw frequency labels
    if (spectrumData.length > 10) {
      final textPainter = TextPainter(
        text: const TextSpan(
          text: 'Frequency (Hz) →',
          style: TextStyle(fontSize: 10, color: Colors.grey),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      textPainter.paint(
        canvas,
        Offset(size.width - textPainter.width - 8, size.height - 20),
      );
    }
  }

  @override
  bool shouldRepaint(covariant AudioSpectrumPainter oldDelegate) {
    return spectrumData != oldDelegate.spectrumData ||
        isActive != oldDelegate.isActive;
  }
}
