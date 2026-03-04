import 'dart:math' as math;

import 'package:flutter/material.dart';

class WavingFlagPainter extends CustomPainter {
  WavingFlagPainter({
    required this.colors,
    required this.animationValue,
    this.numberOfWaves = 3,
  });

  final List<Color> colors;
  final double animationValue;
  final int numberOfWaves;

  @override
  void paint(Canvas canvas, Size size) {
    if (colors.isEmpty) return;

    canvas.save();

    // Ensure the flag covers the canvas when rotated and waving.
    final double maxDimension = math.max(size.width, size.height);
    final diagonal =
        math.sqrt(maxDimension * maxDimension + maxDimension * maxDimension) *
            1.3;

    // Center and tilt the flag diagonally.
    canvas
      ..translate(size.width / 2, size.height / 2)
      ..rotate(-math.pi / 7); // -25.7 degrees

    final startX = -diagonal / 2;
    final startY = -diagonal / 2;
    final flagWidth = diagonal;
    final flagHeight = diagonal;

    final stripeHeight = flagHeight / colors.length;
    final amplitude = flagHeight * 0.05; // Adjust the wave height
    const waveCount = 2.0;

    // Draw wavy stripes for the colors provided.
    for (var i = 0; i < colors.length; i++) {
      final path = Path();
      final color = colors[i];

      // Top edge
      for (double x = 0; x <= flagWidth; x += flagWidth / 40) {
        double y;
        if (i == 0) {
          y = startY;
        } else {
          y = startY +
              i * stripeHeight +
              math.sin(
                    (x / flagWidth * math.pi * 2 * waveCount) -
                        (animationValue * math.pi * 2),
                  ) *
                  amplitude;
        }
        if (x == 0) {
          path.moveTo(startX + x, y);
        } else {
          path.lineTo(startX + x, y);
        }
      }

      // Fill remaining side length
      path.lineTo(startX + flagWidth, startY + flagHeight);

      // Bottom edge
      for (var x = flagWidth; x >= 0; x -= flagWidth / 40) {
        double y;
        if (i == colors.length - 1) {
          y = startY + flagHeight;
        } else {
          y = startY +
              (i + 1) * stripeHeight +
              math.sin(
                    (x / flagWidth * math.pi * 2 * waveCount) -
                        (animationValue * math.pi * 2),
                  ) *
                  amplitude;
        }
        path.lineTo(startX + x, y);
      }

      path
        ..lineTo(startX, startY)
        ..close();

      canvas.drawPath(path, Paint()..color = color);
    }

    // Overlay to simulate 3D lighting/shadows from the folds.
    final segmentWidth = flagWidth / 60;
    for (double x = 0; x < flagWidth; x += segmentWidth) {
      final phase = (x / flagWidth * math.pi * 2 * waveCount) -
          (animationValue * math.pi * 2);

      // Slope of the sine wave dictates brightness.
      final light = math.cos(phase);

      Color overlayColor;
      if (light > 0) {
        overlayColor = Colors.white.withValues(alpha: light * 0.25);
      } else {
        overlayColor = Colors.black.withValues(alpha: -light * 0.25);
      }

      final bandPath = Path()
        ..addRect(
          Rect.fromLTWH(startX + x, startY, segmentWidth + 1.5, flagHeight),
        );

      canvas.drawPath(bandPath, Paint()..color = overlayColor);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant WavingFlagPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.colors != colors;
  }
}
