import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' hide TextDirection;

class TopCurvedTime extends StatefulWidget {
  const TopCurvedTime({
    required this.child,
    super.key,
    this.backgroundColor = Colors.black,
  });

  final Widget child;
  final Color? backgroundColor;

  @override
  State<TopCurvedTime> createState() => _TopCurvedTimeState();
}

class _TopCurvedTimeState extends State<TopCurvedTime> {
  late String _timeString;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timeString = _formatTime(DateTime.now());
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      final formatted = _formatTime(DateTime.now());
      if (_timeString != formatted) {
        setState(() {
          _timeString = formatted;
        });
      }
    });
  }

  String _formatTime(DateTime time) {
    return DateFormat.Hm().format(time);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
        );

    return Stack(
      children: [
        widget.child,
        Align(
          alignment: Alignment.topCenter,
          child: IgnorePointer(
            child: CustomPaint(
              size: const Size(100, 30),
              painter: _CurvedTextPainter(
                text: _timeString,
                textStyle: textStyle,
                backgroundColor: widget.backgroundColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CurvedTextPainter extends CustomPainter {
  _CurvedTextPainter({
    required this.text,
    this.textStyle,
    this.backgroundColor,
  });

  final String text;
  final TextStyle? textStyle;
  final Color? backgroundColor;
  final double radius = 120;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = this.radius;
    canvas.translate(size.width / 2, radius + 12);

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    final chars = text.split('');
    final charAngles = <double>[];
    var totalAngle = 0.0;

    for (final char in chars) {
      textPainter
        ..text = TextSpan(text: char, style: textStyle)
        ..layout();
      final charAngle = (textPainter.width + 2.0) / radius;
      charAngles.add(charAngle);
      totalAngle += charAngle;
    }

    if (backgroundColor != null) {
      final pillPaint = Paint()
        ..color = backgroundColor!
        ..style = PaintingStyle.stroke
        ..strokeWidth = 18
        ..strokeCap = StrokeCap.round;

      const paddingAngle = 0.02;
      canvas.drawArc(
        Rect.fromCircle(center: Offset.zero, radius: radius),
        -math.pi / 2 - totalAngle / 2 - paddingAngle,
        totalAngle + paddingAngle * 2,
        false,
        pillPaint,
      );
    }

    var currentAngle = -math.pi / 2 - totalAngle / 2;

    for (var i = 0; i < chars.length; i++) {
      final charAngle = charAngles[i];
      currentAngle += charAngle / 2;

      textPainter
        ..text = TextSpan(text: chars[i], style: textStyle)
        ..layout();

      canvas
        ..save()
        ..translate(
          radius * math.cos(currentAngle),
          radius * math.sin(currentAngle),
        )
        ..rotate(currentAngle + math.pi / 2);

      textPainter.paint(
        canvas,
        Offset(-textPainter.width / 2, -textPainter.height / 2),
      );
      canvas.restore();

      currentAngle += charAngle / 2;
    }
  }

  @override
  bool shouldRepaint(covariant _CurvedTextPainter oldDelegate) {
    return oldDelegate.text != text ||
        oldDelegate.textStyle != textStyle ||
        oldDelegate.backgroundColor != backgroundColor;
  }
}
