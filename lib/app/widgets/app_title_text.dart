import 'package:flutter/material.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';

class AppTitleText extends StatelessWidget {
  const AppTitleText({
    required this.title,
    this.hasBottomSpacing = true,
    super.key,
  });

  final String title;
  final bool hasBottomSpacing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppVariables.horizontalPaddingTitle,
        right: AppVariables.horizontalPaddingTitle,
        bottom: hasBottomSpacing ? AppVariables.titlePaddingBottom : 0,
      ),
      child: ScrollText(
        text: title,
        style: const TextStyle(
          fontSize: AppVariables.titleSize,
          height: AppVariables.titleTextHeight,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
