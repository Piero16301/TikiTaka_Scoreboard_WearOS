import 'package:flutter/material.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';

class AppCardData extends StatelessWidget {
  const AppCardData({
    required this.content,
    this.title,
    this.innerPadding = const EdgeInsets.all(7),
    super.key,
  });

  final Widget content;
  final String? title;
  final EdgeInsetsGeometry innerPadding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    var cardContent = content;

    if (title != null) {
      cardContent = Column(
        mainAxisSize: MainAxisSize.min,
        spacing: AppVariables.cardSpacing,
        children: [
          Text(
            title!,
            style: TextStyle(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
          content,
        ],
      );
    }

    return Card(
      color: theme.colorScheme.surfaceContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: innerPadding,
        child: DefaultTextStyle.merge(
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: 14,
          ),
          child: cardContent,
        ),
      ),
    );
  }
}
