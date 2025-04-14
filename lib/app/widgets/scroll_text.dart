import 'package:flutter/material.dart';
import 'package:text_scroll/text_scroll.dart';

class ScrollText extends StatelessWidget {
  const ScrollText({
    required this.text,
    this.style = const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
    super.key,
  });

  final String text;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return TextScroll(
      text,
      pauseBetween: const Duration(seconds: 1),
      velocity: const Velocity(pixelsPerSecond: Offset(20, 0)),
      style: style,
    );
  }
}
