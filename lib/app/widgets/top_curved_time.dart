import 'dart:async';
import 'dart:math' as math;

import 'package:intl/intl.dart' hide TextDirection;
import 'package:material_ui/material_ui.dart';

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

class _TopCurvedTimeState extends State<TopCurvedTime>
    with WidgetsBindingObserver {
  static final DateFormat _timeFormat = DateFormat.Hm();
  late String _timeString;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _timeString = _formatTime(DateTime.now());
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      final formatted = _formatTime(DateTime.now());
      if (_timeString != formatted) {
        setState(() {
          _timeString = formatted;
        });
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      final formatted = _formatTime(DateTime.now());
      if (_timeString != formatted) {
        setState(() {
          _timeString = formatted;
        });
      }
      _startTimer();
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.hidden) {
      _stopTimer();
    }
  }

  String _formatTime(DateTime time) => _timeFormat.format(time);

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _stopTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final labelLarge = Theme.of(context).textTheme.labelLarge;
    final textStyle = labelLarge?.copyWith(
      fontVariations: <FontVariation>[
        ...(labelLarge.fontVariations ?? const <FontVariation>[]).where(
          (v) => v.axis != 'wght',
        ),
        const FontVariation('wght', 700),
      ],
    );

    return Stack(
      children: [
        widget.child,
        Align(
          alignment: Alignment.topCenter,
          child: IgnorePointer(
            child: RepaintBoundary(
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

    final chars = text.split('');
    final charPainters = <TextPainter>[];
    final charAngles = <double>[];
    var totalAngle = 0.0;

    for (final char in chars) {
      final painter = TextPainter(
        text: TextSpan(text: char, style: textStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      charPainters.add(painter);
      final charAngle = (painter.width + 2.0) / radius;
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
      final painter = charPainters[i];

      canvas
        ..save()
        ..translate(
          radius * math.cos(currentAngle),
          radius * math.sin(currentAngle),
        )
        ..rotate(currentAngle + math.pi / 2);

      painter.paint(canvas, Offset(-painter.width / 2, -painter.height / 2));
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
