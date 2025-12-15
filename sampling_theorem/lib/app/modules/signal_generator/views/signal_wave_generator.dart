// app/widgets/signal_wave_painter.dart
import 'package:flutter/material.dart';

class SignalWavePainter extends CustomPainter {
  final List<double> signalData;
  final List<double> timeData;
  final String signalType;
  final double time;

  SignalWavePainter({
    required this.signalData,
    required this.timeData,
    required this.signalType,
    required this.time,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (signalData.isEmpty || timeData.isEmpty) return;

    final paint = Paint()
      ..color = _getSignalColor()
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final gridPaint = Paint()
      ..color = Colors.grey[300]!
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    final axisPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    // Draw grid
    for (double x = 0; x <= size.width; x += size.width / 10) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y <= size.height; y += size.height / 10) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Draw axes
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      axisPaint,
    );

    // Draw signal
    final path = Path();
    final amplitudeScale = size.height / 3;
    final timeScale = size.width / timeData.last;

    for (int i = 0; i < signalData.length; i++) {
      final x = timeData[i] * timeScale;
      final y = size.height / 2 - signalData[i] * amplitudeScale;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);

    // Draw current time indicator
    final indicatorPaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 2.0;

    final currentX = time * timeScale;
    canvas.drawLine(
      Offset(currentX, 0),
      Offset(currentX, size.height),
      indicatorPaint,
    );

    // Draw signal type label
    final textPainter = TextPainter(
      text: TextSpan(
        text: signalType.toUpperCase(),
        style: const TextStyle(
          color: Colors.deepPurple,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(
      canvas,
      Offset(size.width - textPainter.width - 10, 10),
    );
  }

  Color _getSignalColor() {
    switch (signalType) {
      case 'sine':
        return Colors.blue;
      case 'cosine':
        return Colors.green;
      case 'square':
        return Colors.orange;
      case 'triangle':
        return Colors.purple;
      case 'sawtooth':
        return Colors.red;
      case 'noise':
        return Colors.grey;
      case 'chirp':
        return Colors.teal;
      default:
        return Colors.deepPurple;
    }
  }

  @override
  bool shouldRepaint(covariant SignalWavePainter oldDelegate) {
    return signalData != oldDelegate.signalData ||
        time != oldDelegate.time ||
        signalType != oldDelegate.signalType;
  }
}
