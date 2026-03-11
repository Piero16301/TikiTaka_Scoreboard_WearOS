import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tiki_taka_scoreboard_wearos/app/widgets/waving_flag_painter.dart';

class WavingFlagBackground extends StatefulWidget {
  const WavingFlagBackground({
    required this.colors,
    super.key,
  });

  final List<Color> colors;

  @override
  State<WavingFlagBackground> createState() => _WavingFlagBackgroundState();
}

class _WavingFlagBackgroundState extends State<WavingFlagBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );
    unawaited(_animationController.repeat());
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return CustomPaint(
            painter: WavingFlagPainter(
              colors: widget.colors,
              animationValue: _animationController.value,
            ),
          );
        },
      ),
    );
  }
}
