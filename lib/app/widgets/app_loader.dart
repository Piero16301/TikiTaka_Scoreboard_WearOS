import 'package:flutter/material.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';

class AppLoader extends StatelessWidget {
  const AppLoader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: BallLoader(
        primary: theme.colorScheme.primary,
        secondary: theme.colorScheme.secondary,
        size: 60,
      ),
    );
  }
}
