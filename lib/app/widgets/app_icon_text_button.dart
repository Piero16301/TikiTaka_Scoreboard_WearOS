import 'package:material_ui/material_ui.dart';

class AppIconTextButton extends StatelessWidget {
  const AppIconTextButton({
    required this.label,
    required this.icon,
    this.onPressed,
    super.key,
  });

  final String label;
  final Widget icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Card(
          clipBehavior: onPressed != null ? Clip.antiAlias : null,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 14,
                horizontal: 32,
              ),
              child: icon,
            ),
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            fontVariations: <FontVariation>[
              ...(Theme.of(
                        context,
                      ).textTheme.labelLarge?.fontVariations ??
                      const <FontVariation>[])
                  .where((v) => v.axis != 'wght'),
              const FontVariation('wght', 700),
            ],
          ),
        ),
      ],
    );
  }
}
