import 'package:material_ui/material_ui.dart';

class AppLinearProgressBar extends StatefulWidget {
  const AppLinearProgressBar({
    this.indicatorColor,
    this.backgroundColor,
    this.strokeWidth = 6.0,
    super.key,
  });

  final Color? indicatorColor;
  final Color? backgroundColor;
  final double strokeWidth;

  @override
  State<AppLinearProgressBar> createState() => _AppLinearProgressBarState();
}

class _AppLinearProgressBarState extends State<AppLinearProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final backgroundColor =
        widget.backgroundColor ?? theme.colorScheme.surfaceContainerHighest;
    final indicatorColor = widget.indicatorColor ?? theme.colorScheme.primary;

    return SizedBox(
      height: widget.strokeWidth,
      width: double.infinity,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(
            painter: _AppLinearProgressBarPainter(
              animationValue: _controller.value,
              backgroundColor: backgroundColor,
              indicatorColor: indicatorColor,
              strokeWidth: widget.strokeWidth,
            ),
          );
        },
      ),
    );
  }
}

class _AppLinearProgressBarPainter extends CustomPainter {
  _AppLinearProgressBarPainter({
    required this.animationValue,
    required this.backgroundColor,
    required this.indicatorColor,
    required this.strokeWidth,
  });

  final double animationValue;
  final Color backgroundColor;
  final Color indicatorColor;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= strokeWidth) return;

    final y = size.height / 2;
    final halfStroke = strokeWidth / 2;
    final startX = halfStroke;
    final endX = size.width - halfStroke;
    final usableWidth = size.width - strokeWidth;

    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final indicatorPaint = Paint()
      ..color = indicatorColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final progress = Curves.linear.transform(animationValue);

    final indicatorWidth = usableWidth * 0.3;
    final totalSpan = usableWidth + indicatorWidth;

    final currCenter = startX + (totalSpan * progress) - (indicatorWidth / 2);

    final realIStart = currCenter - indicatorWidth / 2;
    final realIEnd = currCenter + indicatorWidth / 2;

    final pointGap = strokeWidth * 2;

    final iStartPoint = realIStart.clamp(startX, endX);
    final iEndPoint = realIEnd.clamp(startX, endX);

    final bgLeftEndPoint = realIStart - pointGap;
    if (bgLeftEndPoint > startX) {
      canvas.drawLine(
        Offset(startX, y),
        Offset(bgLeftEndPoint, y),
        backgroundPaint,
      );
    }

    final bgRightStartPoint = realIEnd + pointGap;
    if (bgRightStartPoint < endX) {
      canvas.drawLine(
        Offset(bgRightStartPoint, y),
        Offset(endX, y),
        backgroundPaint,
      );
    }

    if (iEndPoint > iStartPoint) {
      canvas.drawLine(
        Offset(iStartPoint, y),
        Offset(iEndPoint, y),
        indicatorPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _AppLinearProgressBarPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.indicatorColor != indicatorColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
