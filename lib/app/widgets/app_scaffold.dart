import 'package:flutter/material.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    required this.child,
    this.disablePadding = false,
    super.key,
  });

  final Widget child;
  final bool disablePadding;

  @override
  Widget build(BuildContext context) {
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
