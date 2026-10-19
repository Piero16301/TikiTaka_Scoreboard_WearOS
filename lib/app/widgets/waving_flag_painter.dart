import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:material_ui/material_ui.dart';

class WavingFlagPainter extends CustomPainter {
  WavingFlagPainter({
    required this.colors,
    required this.animationValue,
    this.numberOfWaves = 3,
  });

  final List<Color> colors;
  final double animationValue;
  final int numberOfWaves;

  /// Multi-harmonic wind wave equation.
  ///
  /// Combines a primary traveling billow, secondary fluttering harmonics,
  /// diagonal cloth twist, and wind gusts.
  /// All time harmonics use integer multiples of 2*pi to ensure a 100%
  /// seamless and continuous animation loop with zero hitching.
  double _calculateWaveOffset({
    required double u,
    required double v,
    required double t,
    required double baseAmplitude,
  }) {
    final theta = t * 2 * math.pi;

    // 1. Primary traveling billow in wind direction
    final w1 = math.sin(u * 2.8 * math.pi - theta + v * 0.45);

    // 2. Secondary undulating harmonic (ripples traveling with the wind)
    final w2 = 0.38 * math.sin(u * 5.6 * math.pi - 2 * theta + v * 0.9 + 1.2);

    // 3. High-frequency micro-flutter (fast wind flapping near edges)
    final w3 = 0.16 * math.sin(u * 9.2 * math.pi - 3 * theta + 2.1);

    // 4. Diagonal cloth twist (cross-wind variation).
    final w4 =
        0.20 * math.sin(v * 2.6 * math.pi + u * 1.8 * math.pi - theta + 0.7);

    // 5. Wind gust modulation (gusts that swell and relax naturally).
    final windGust = 0.88 + 0.16 * math.sin(u * 2 * math.pi - 2 * theta + 0.5);

    // Amplitude increases naturally towards the free fly-edge (u -> 1.0)
    final flutterMultiplier = 0.75 + 0.5 * u;

    return (w1 + w2 + w3 + w4) * windGust * flutterMultiplier * baseAmplitude;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (colors.isEmpty) return;

    canvas.save();

    // Ensure flag covers round/square WearOS canvas when rotated.
    final double maxDimension = math.max(size.width, size.height);
    final diagonal =
        math.sqrt(maxDimension * maxDimension + maxDimension * maxDimension) *
        1.35;

    // Center and tilt the flag diagonally for dynamic presentation.
    canvas
      ..translate(size.width / 2, size.height / 2)
      ..rotate(-math.pi / 7); // -25.7 degrees

    final startX = -diagonal / 2;
    final startY = -diagonal / 2;
    final flagWidth = diagonal;
    final flagHeight = diagonal;

    final stripeHeight = flagHeight / colors.length;
    final baseAmplitude = flagHeight * 0.038;

    const steps = 100;
    final dx = flagWidth / steps;

    // 1. Draw smooth wavy stripes
    for (var i = 0; i < colors.length; i++) {
      final path = Path();
      final color = colors[i];

      final topV = i / colors.length;
      final bottomV = (i + 1) / colors.length;

      // Top edge from left to right (x: 0 -> flagWidth)
      for (var s = 0; s <= steps; s++) {
        final x = s * dx;
        final u = s / steps;
        final y = (i == 0)
            ? startY - baseAmplitude * 3.0
            : startY +
                  i * stripeHeight +
                  _calculateWaveOffset(
                    u: u,
                    v: topV,
                    t: animationValue,
                    baseAmplitude: baseAmplitude,
                  );

        if (s == 0) {
          path.moveTo(startX + x, y);
        } else {
          path.lineTo(startX + x, y);
        }
      }

      // Bottom edge from right to left (x: flagWidth -> 0)
      for (var s = steps; s >= 0; s--) {
        final x = s * dx;
        final u = s / steps;
        final y = (i == colors.length - 1)
            ? startY + flagHeight + baseAmplitude * 3.0
            : startY +
                  (i + 1) * stripeHeight +
                  _calculateWaveOffset(
                    u: u,
                    v: bottomV,
                    t: animationValue,
                    baseAmplitude: baseAmplitude,
                  );

        path.lineTo(startX + x, y);
      }

      path.close();
      canvas.drawPath(path, Paint()..color = color);
    }

    // 2. Realistic 3D cloth lighting (continuous gradient shader).
    const lightingSamples = 100;
    final gradientColors = <Color>[];
    final gradientStops = <double>[];

    for (var s = 0; s <= lightingSamples; s++) {
      final u = s / lightingSamples;
      gradientStops.add(u);

      // Numerical derivative along the wave direction to compute surface slope
      const du = 0.006;
      final uPrev = math.max<double>(0, u - du);
      final uNext = math.min<double>(1, u + du);
      final wavePrev = _calculateWaveOffset(
        u: uPrev,
        v: 0.5,
        t: animationValue,
        baseAmplitude: baseAmplitude,
      );
      final waveNext = _calculateWaveOffset(
        u: uNext,
        v: 0.5,
        t: animationValue,
        baseAmplitude: baseAmplitude,
      );
      final slope = (waveNext - wavePrev) / ((uNext - uPrev) * flagWidth);

      // Surfaces sloping toward light catch highlights.
      final light = (slope * 14).clamp(-1.0, 1.0);

      if (light > 0) {
        // Specular highlight on wave ridges (silky sheen)
        final alpha = math.pow(light, 1.4) * 0.28;
        gradientColors.add(Colors.white.withValues(alpha: alpha));
      } else {
        // Crease shadow in wave valleys
        final alpha = math.pow(-light, 1.2) * 0.35;
        gradientColors.add(Colors.black.withValues(alpha: alpha));
      }
    }

    final lightingPaint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(startX, 0),
        Offset(startX + flagWidth, 0),
        gradientColors,
        gradientStops,
      );

    canvas.drawRect(
      Rect.fromLTWH(
        startX - 20,
        startY - baseAmplitude * 3.0,
        flagWidth + 40,
        flagHeight + baseAmplitude * 6.0,
      ),
      lightingPaint,
    );

    // 3. Subtle fabric satin sheen to enhance realistic material depth
    final sheenPaint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(startX, startY),
        Offset(startX + flagWidth, startY + flagHeight),
        [
          Colors.white.withValues(alpha: 0.07),
          Colors.transparent,
          Colors.black.withValues(alpha: 0.10),
          Colors.white.withValues(alpha: 0.05),
          Colors.transparent,
        ],
        [0, 0.3, 0.6, 0.85, 1],
      );

    canvas
      ..drawRect(
        Rect.fromLTWH(
          startX - 20,
          startY - baseAmplitude * 3.0,
          flagWidth + 40,
          flagHeight + baseAmplitude * 6.0,
        ),
        sheenPaint,
      )
      ..restore();

    // 4. Smooth circular edge vignette for WearOS round display.
    final vignetteRadius = math.max(size.width, size.height) * 0.55;
    final vignettePaint = Paint()
      ..shader = ui.Gradient.radial(
        Offset(size.width / 2, size.height / 2),
        vignetteRadius,
        [
          Colors.transparent,
          Colors.black.withValues(alpha: 0.15),
          Colors.black.withValues(alpha: 0.55),
        ],
        [0, 0.65, 1],
      );

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      vignettePaint,
    );
  }

  @override
  bool shouldRepaint(covariant WavingFlagPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.colors != colors;
  }
}
