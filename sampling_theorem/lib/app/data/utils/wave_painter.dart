import 'package:flutter/material.dart';

class WavePainter extends CustomPainter {
  final List<double> samples;

  WavePainter(this.samples);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.cyanAccent
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    if (samples.isEmpty) return;

    final path = Path();
    final dx = size.width / (samples.length - 1);
    final midY = size.height / 2;

    path.moveTo(0, midY);

    for (int i = 0; i < samples.length; i++) {
      path.lineTo(
        i * dx,
        midY - samples[i] * midY * 0.8,
      );
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant WavePainter oldDelegate) => true;
}
