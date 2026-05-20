import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

class BallLoader extends StatefulWidget {
  const BallLoader({
    required this.primary,
    required this.secondary,
    this.size = 100.0,
    this.speedInSeconds = 2,
    super.key,
  });

  final Color primary;
  final Color secondary;
  final double size;
  final int speedInSeconds;

  @override
  State<BallLoader> createState() => _BallLoaderState();
}

class _BallLoaderState extends State<BallLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.speedInSeconds),
    );
    unawaited(_controller.repeat());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(BallLoader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.speedInSeconds != widget.speedInSeconds) {
      _controller.duration = Duration(seconds: widget.speedInSeconds);
      if (_controller.isAnimating) {
        unawaited(_controller.repeat());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size(widget.size, widget.size),
          painter: _BallPainter(
            primary: widget.primary,
            secondary: widget.secondary,
            progress: _controller.value,
          ),
        );
      },
    );
  }
}

class _BallPainter extends CustomPainter {
  _BallPainter({
    required this.primary,
    required this.secondary,
    required this.progress,
  });
  final Color primary;
  final Color secondary;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 2;
    final center = Offset(radius, radius);

    final circlePath = Path()
      ..addOval(Rect.fromCircle(center: center, radius: radius));
    canvas.clipPath(circlePath);

    final hexRadius = radius / 2.5;
    final hexWidth = math.sqrt(3) * hexRadius;
    final hexHeight = 2 * hexRadius;
    final horizSpacing = hexWidth;
    final vertSpacing = hexHeight * 0.75;

    for (var row = -4; row <= 4; row++) {
      for (var col = -4; col <= 4; col++) {
        var x = center.dx + col * horizSpacing;
        final y = center.dy + row * vertSpacing;

        if (row.isOdd) {
          x += horizSpacing / 2;
        }

        final hexCenter = Offset(x, y);

        if ((hexCenter - center).distance > radius + hexRadius) {
          continue;
        }

        final hexPath = _createHexagon(hexCenter, hexRadius * 0.95);

        final isPrimary = (row + col).isEven;
        final baseColor = isPrimary ? primary : secondary;

        final distFromCenter = (hexCenter - center).distance;
        final normalizedDist = (distFromCenter / radius).clamp(0.0, 1.0);

        final wave =
            math.sin((progress * 2 * math.pi) - (normalizedDist * math.pi));

        final opacity = 0.65 + (0.35 * wave);

        final paint = Paint()
          ..color = baseColor.withValues(alpha: opacity.clamp(0.0, 1.0))
          ..style = PaintingStyle.fill;

        canvas.drawPath(hexPath, paint);
      }
    }
  }

  Path _createHexagon(Offset center, double radius) {
    final path = Path();
    for (var i = 0; i < 6; i++) {
      final angle = (math.pi / 180) * (-90 + i * 60);
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(covariant _BallPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.primary != primary ||
        oldDelegate.secondary != secondary;
  }
}
