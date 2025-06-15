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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Card(
        child: Padding(
          padding: innerPadding,
          child: child,
        ),
      ),
    );
  }
}
