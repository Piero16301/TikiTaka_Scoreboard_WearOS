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
  static final Stream<dynamic> _sharedRotaryStream =
      _rotaryChannel.receiveBroadcastStream();

  StreamSubscription<dynamic>? _rotarySubscription;
  double? _targetOffset;
  Timer? _clearTargetTimer;

  @override
  void initState() {
    super.initState();
    _rotarySubscription = _sharedRotaryStream.listen((dynamic event) {
      if (event is double) {
        // Multiply by 0.5 to halve the original speed of the scroll, making
        // it much slower and controlled.
        // This keeps the smoothness but prevents jumping too fast.
        final scrollAmount = event * 0.5;

        _targetOffset =
            (_targetOffset ?? widget.controller.offset) + scrollAmount;

        final maxScrollExtent = widget.controller.position.maxScrollExtent;
        final minScrollExtent = widget.controller.position.minScrollExtent;
        final clampedOffset =
            _targetOffset!.clamp(minScrollExtent, maxScrollExtent);

        _targetOffset = clampedOffset;

        if (clampedOffset != widget.controller.offset) {
          unawaited(
            widget.controller.animateTo(
              clampedOffset,
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeOutQuad,
            ),
          );

          // Using heavyImpact to mimic the stronger Google Wear OS native
          // haptic feel
          unawaited(HapticFeedback.heavyImpact());
        }

        // Reset target offset 200ms after the last rotary interaction
        // to gracefully allow touch scrolling synchronization.
        _clearTargetTimer?.cancel();
        _clearTargetTimer = Timer(const Duration(milliseconds: 200), () {
          _targetOffset = null;
        });
      }
    });
  }

  @override
  void dispose() {
    unawaited(_rotarySubscription?.cancel());
    _clearTargetTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
