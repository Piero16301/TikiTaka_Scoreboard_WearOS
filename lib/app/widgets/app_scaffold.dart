import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
              child: Focus(
                autofocus: true,
                child: Listener(
                  onPointerSignal: (event) {
                    if (event is PointerScrollEvent) {
                      final newOffset =
                          controller!.offset + event.scrollDelta.dy;

                      final maxScrollExtent =
                          controller!.position.maxScrollExtent;
                      final minScrollExtent =
                          controller!.position.minScrollExtent;
                      final clampedOffset =
                          newOffset.clamp(minScrollExtent, maxScrollExtent);

                      if (clampedOffset != controller!.offset) {
                        controller!.jumpTo(clampedOffset);
                        unawaited(HapticFeedback.selectionClick());
                      }
                    }
                  },
                  child: SingleChildScrollView(
                    controller: controller,
                    child: child,
                  ),
                ),
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
