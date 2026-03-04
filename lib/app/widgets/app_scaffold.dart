import 'package:flutter/material.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold.basic({
    required this.child,
    this.disablePadding = false,
    super.key,
  })  : controller = null,
        isScrollable = false;

  const AppScaffold.scrollable({
    required this.child,
    required this.controller,
    this.disablePadding = false,
    super.key,
  }) : isScrollable = true;

  final Widget child;
  final bool disablePadding;
  final ScrollController? controller;
  final bool isScrollable;

  @override
  Widget build(BuildContext context) {
    if (isScrollable && controller != null) {
      return CircularScrollIndicator(
        controller: controller!,
        child: Scaffold(
          body: SizedBox.expand(
            child: Padding(
              padding: disablePadding
                  ? EdgeInsetsGeometry.zero
                  : AppVariables.scaffoldPadding,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                controller: controller,
                child: child,
              ),
            ),
          ),
        ),
      );
    }

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
}
