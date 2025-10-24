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
      autoHide: false,
      child: child,
    );
  }
}
