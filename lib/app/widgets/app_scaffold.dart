import 'package:flutter/material.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';
import 'package:wear_os_scrollbar/wear_os_scrollbar.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold.basic({
    required this.child,
    this.disablePadding = false,
    this.background,
    super.key,
  })  : controller = null,
        isScrollable = false;

  const AppScaffold.scrollable({
    required this.child,
    required this.controller,
    this.disablePadding = false,
    this.background,
    super.key,
  }) : isScrollable = true;

  final Widget child;
  final bool disablePadding;
  final ScrollController? controller;
  final bool isScrollable;
  final Widget? background;

  @override
  Widget build(BuildContext context) {
    if (isScrollable && controller != null) {
      return WearOsScrollbar(
        controller: controller!,
        child: Scaffold(
          body: SizedBox.expand(
            child: Stack(
              children: [
                if (background != null) background!,
                Padding(
                  padding: disablePadding
                      ? EdgeInsetsGeometry.zero
                      : AppVariables.scaffoldPadding,
                  child: SingleChildScrollView(
                    controller: controller,
                    child: child,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: SizedBox.expand(
        child: Stack(
          children: [
            if (background != null) background!,
            Padding(
              padding: disablePadding
                  ? EdgeInsetsGeometry.zero
                  : AppVariables.scaffoldPadding,
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
