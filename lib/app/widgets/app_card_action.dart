import 'package:flutter/material.dart';

class AppCardAction extends StatelessWidget {
  const AppCardAction({
    required this.content,
    this.title,
    this.innerPadding = const EdgeInsets.all(7),
    this.onPressed,
    super.key,
  });

  final Widget content;
  final String? title;
  final EdgeInsetsGeometry innerPadding;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    var cardContent = content;

    if (title != null) {
      cardContent = Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 4,
        children: [
          Text(
            title!,
            style: TextStyle(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
          content,
        ],
      );
    }

    Widget result = Padding(
      padding: innerPadding,
      child: DefaultTextStyle.merge(
        style: TextStyle(
          color: theme.colorScheme.onSurface,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        child: cardContent,
      ),
    );

    if (onPressed != null) {
      result = InkWell(
        onTap: onPressed,
        child: result,
      );
    }

    return Card(
      clipBehavior: onPressed != null ? Clip.antiAlias : null,
      child: result,
    );
  }
}
