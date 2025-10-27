import 'package:flutter/material.dart';
import 'package:rotary_scrollbar/rotary_scrollbar.dart';

class AppRotaryScrollbar extends StatelessWidget {
  const AppRotaryScrollbar({
    required this.controller,
    required this.child,
    super.key,
  });

  final ScrollController controller;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return RotaryScrollbar(
      controller: controller,
      width: 7,
      padding: 0,
      scrollAnimationCurve: Curves.easeInOut,
      scrollAnimationDuration: const Duration(milliseconds: 200),
      scrollMagnitude: 5,
      child: child,
    );
  }
}
