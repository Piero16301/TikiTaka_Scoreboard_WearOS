import 'dart:math' as math;

import 'package:flutter/material.dart';

class RipplePainter extends CustomPainter {
  RipplePainter({
    required this.colors,
    required this.animationValue,
    this.numberOfWaves = 3,
  });

  final List<Color> colors;
  final double animationValue;
  final int numberOfWaves;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    final backgroundPaint = Paint()
      ..shader = LinearGradient(
        colors: colors,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(rect);

    canvas.drawRect(rect, backgroundPaint);

    final center = Offset(size.width / 2, size.height / 2);

    for (var i = 0; i < numberOfWaves; i++) {
      final waveOffset = i / numberOfWaves;
      final waveAnimValue = (animationValue + waveOffset) % 1.0;

      final outerRadius =
          math.min(size.width, size.height) * waveAnimValue * 0.8;
      final innerRadius = outerRadius - (12.0 * (1.0 - waveAnimValue));

      final opacity = (1.0 - waveAnimValue) * 0.3;

      final waveColor = colors[i % colors.length];

      final wavePaint = Paint()
        ..shader = RadialGradient(
          colors: [
            waveColor.withValues(alpha: opacity),
            waveColor.withValues(alpha: 0),
          ],
          stops: const [0.8, 1.0],
        ).createShader(
          Rect.fromCircle(
            center: center,
            radius: outerRadius,
          ),
        )
        ..style = PaintingStyle.fill;

      final circlePath = Path()
        ..addOval(Rect.fromCircle(center: center, radius: outerRadius))
        ..addOval(Rect.fromCircle(center: center, radius: innerRadius))
        ..fillType = PathFillType.evenOdd;

      canvas.drawPath(circlePath, wavePaint);

      final glowPaint = Paint()
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8)
        ..shader = RadialGradient(
          colors: [
            waveColor.withValues(alpha: opacity * 0.5),
            waveColor.withValues(alpha: 0),
          ],
          stops: const [0.85, 1.0],
        ).createShader(
          Rect.fromCircle(
            center: center,
            radius: outerRadius + 5.0,
          ),
        );

      canvas.drawCircle(center, outerRadius, glowPaint);
    }
  }

  @override
  bool shouldRepaint(covariant RipplePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.colors != colors;
  }
}
