import 'dart:async';

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
              child: _RotaryScrollWrapper(
                controller: controller!,
                child: SingleChildScrollView(
                  controller: controller,
                  child: child,
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

class _RotaryScrollWrapper extends StatefulWidget {
  const _RotaryScrollWrapper({
    required this.child,
    required this.controller,
  });

  final Widget child;
  final ScrollController controller;

  @override
  State<_RotaryScrollWrapper> createState() => _RotaryScrollWrapperState();
}

class _RotaryScrollWrapperState extends State<_RotaryScrollWrapper> {
  static const EventChannel _rotaryChannel =
      EventChannel('com.pmorales.wearos.tikitaka/rotary');
  StreamSubscription<dynamic>? _rotarySubscription;

  @override
  void initState() {
    super.initState();
    _rotarySubscription =
        _rotaryChannel.receiveBroadcastStream().listen((dynamic event) {
      if (event is double) {
        // We now receive native standard pixels from ViewConfiguration in
        // Kotlin.
        final scrollAmount = event;
        final newOffset = widget.controller.offset + scrollAmount;

        final maxScrollExtent = widget.controller.position.maxScrollExtent;
        final minScrollExtent = widget.controller.position.minScrollExtent;
        final clampedOffset = newOffset.clamp(minScrollExtent, maxScrollExtent);

        if (clampedOffset != widget.controller.offset) {
          widget.controller.jumpTo(clampedOffset);
          unawaited(HapticFeedback.selectionClick());
        }
      }
    });
  }

  @override
  void dispose() {
    unawaited(_rotarySubscription?.cancel());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
