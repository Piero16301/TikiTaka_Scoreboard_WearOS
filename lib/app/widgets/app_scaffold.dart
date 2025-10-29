import 'package:flutter/material.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    required this.child,
    this.controller,
    this.disablePadding = false,
    super.key,
  });

  final ScrollController? controller;
  final Widget child;
  final bool disablePadding;

  @override
  Widget build(BuildContext context) {
    if (controller == null) {
      return Scaffold(
        body: SizedBox.expand(
          child: Padding(
            padding: disablePadding
                ? EdgeInsetsGeometry.zero
                : AppVariables.scaffoldPadding,
            child: child,
          ),
        ),
      );
    }

    return Scaffold(
      body: SizedBox.expand(
        child: AppRotaryScrollbar(
          controller: controller!,
          child: Padding(
            padding: disablePadding
                ? EdgeInsetsGeometry.zero
                : AppVariables.scaffoldPadding,
            child: child,
          ),
        ),
      ),
    );
  }
}
