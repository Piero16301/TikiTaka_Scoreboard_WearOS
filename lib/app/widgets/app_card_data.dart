import 'package:flutter/material.dart';

class AppCardData extends StatelessWidget {
  const AppCardData({
    required this.child,
    this.innerPadding = const EdgeInsets.all(5),
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry innerPadding;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: innerPadding,
        child: child,
      ),
    );
  }
}
