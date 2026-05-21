import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class AppError extends StatelessWidget {
  const AppError({
    required this.text,
    super.key,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 5,
          children: [
            const HugeIcon(
              icon: HugeIcons.strokeRoundedCancelCircle,
              strokeWidth: 2,
              size: 32,
            ),
            Text(
              text,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
