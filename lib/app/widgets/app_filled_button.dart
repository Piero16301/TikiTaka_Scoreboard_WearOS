import 'package:flutter/material.dart';

class AppFilledButton extends StatelessWidget {
  const AppFilledButton({
    this.onPressed,
    this.icon,
    this.label,
    this.innerPadding,
    this.color,
    this.isOnlyIcon = false,
    super.key,
  });

  final void Function()? onPressed;
  final Widget? icon;
  final String? label;
  final EdgeInsetsGeometry? innerPadding;
  final Color? color;
  final bool isOnlyIcon;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor:
            color ?? Theme.of(context).colorScheme.primaryContainer,
        padding: innerPadding ??
            const EdgeInsets.symmetric(
              vertical: 18,
              horizontal: 16,
            ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      icon: icon != null && !isOnlyIcon ? icon : null,
      label: label != null
          ? Text(
              label ?? '',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            )
          : icon!,
    );
  }
}
