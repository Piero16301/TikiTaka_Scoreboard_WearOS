import 'package:flutter/material.dart';
import 'package:tiki_taka/app/widgets/widgets.dart';

class RippleBackground extends StatefulWidget {
  const RippleBackground({
    required this.colors,
    required this.child,
    super.key,
  });

  final List<Color> colors;
  final Widget child;

  @override
  State<RippleBackground> createState() => _RippleBackgroundState();
}

class _RippleBackgroundState extends State<RippleBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return CustomPaint(
          painter: RipplePainter(
            colors: widget.colors,
            animationValue: _animationController.value,
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
