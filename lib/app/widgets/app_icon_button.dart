import 'package:hugeicons/hugeicons.dart';
import 'package:material_ui/material_ui.dart';

class AppIconButton extends StatelessWidget {
  const AppIconButton({
    required this.icon,
    this.onPressed,
    super.key,
  });

  final void Function()? onPressed;
  final List<List<dynamic>>? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = theme.colorScheme.onPrimary;
    final iconColor = theme.colorScheme.primary;

    return Material(
      color: bgColor,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: icon != null
              ? HugeIcon(
                  icon: icon!,
                  color: iconColor,
                  size: 20,
                  strokeWidth: 2,
                )
              : const SizedBox(width: 30, height: 30),
        ),
      ),
    );
  }
}
