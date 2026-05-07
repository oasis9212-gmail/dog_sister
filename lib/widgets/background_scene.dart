import 'dart:math';
import 'package:flutter/material.dart';

class BackgroundScene extends StatelessWidget {
  const BackgroundScene({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _BackgroundPainter(),
      child: const SizedBox.expand(),
    );
  }
}

class _BackgroundPainter extends CustomPainter {
  final Random _rand = Random(42);

  @override
  void paint(Canvas canvas, Size size) {
    // Sky
    final skyPaint = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color(0xFFBEE7FF),
          Color(0xFFF7FDFF),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), skyPaint);

    // Sun glow
    final sunCenter = Offset(size.width * 0.25, size.height * 0.18);
    canvas.drawCircle(
      sunCenter,
      size.width * 0.08,
      Paint()..color = const Color(0xFFFFE7A3).withOpacity(0.85),
    );
    canvas.drawCircle(
      sunCenter,
      size.width * 0.12,
      Paint()..color = const Color(0xFFFFE7A3).withOpacity(0.25),
    );

    // Hills
    _drawHill(
      canvas,
      size,
      y: size.height * 0.55,
      height: size.height * 0.22,
      curve: 0.18,
      shift: 0.0,
      colorA: const Color(0xFFA8E27E),
      colorB: const Color(0xFF7ED957),
    );
    _drawHill(
      canvas,
      size,
      y: size.height * 0.62,
      height: size.height * 0.28,
      curve: 0.25,
      shift: 0.08,
      colorA: const Color(0xFFB7F2A1),
      colorB: const Color(0xFF7ED957),
    );

    // Grass strokes
    final baseY = size.height * 0.72;
    final bladeCount = (size.width / 10).floor().clamp(10, 250);
    for (int i = 0; i < bladeCount; i++) {
      final x = (i / (bladeCount - 1)) * size.width + (_rand.nextDouble() - 0.5) * 4;
      final bladeH = 14 + _rand.nextDouble() * 22;
      final sway = (_rand.nextDouble() - 0.5) * 8;

      final p = Path()
        ..moveTo(x, baseY)
        ..quadraticBezierTo(x + sway, baseY - bladeH * 0.6, x + sway * 0.4, baseY - bladeH);

      canvas.drawPath(
        p,
        Paint()
          ..color = const Color(0xFF69C94A)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    }
  }

  void _drawHill(
    Canvas canvas,
    Size size, {
    required double y,
    required double height,
    required double curve,
    required double shift,
    required Color colorA,
    required Color colorB,
  }) {
    final hillPath = Path()..moveTo(0, size.height)..lineTo(0, y);

    hillPath.quadraticBezierTo(
      size.width * 0.25 + size.width * shift,
      y - height * curve,
      size.width * 0.55 + size.width * shift,
      y - height * (curve * 0.65),
    );
    hillPath.quadraticBezierTo(
      size.width * 0.78 + size.width * shift,
      y + height * 0.15,
      size.width,
      y,
    );

    hillPath
      ..lineTo(size.width, size.height)
      ..close();

    final paint = Paint()
      ..shader = LinearGradient(
        colors: [colorA, colorB],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(hillPath, paint);
  }

  @override
  bool shouldRepaint(covariant _BackgroundPainter oldDelegate) => false;
}

