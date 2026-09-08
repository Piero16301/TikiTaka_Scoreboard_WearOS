import 'package:hugeicons/hugeicons.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';

class AppEmpty extends StatelessWidget {
  const AppEmpty({
    required this.text,
    this.onPressedSettings,
    super.key,
  });

  final String text;
  final void Function()? onPressedSettings;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const HugeIcon(
              icon: HugeIcons.strokeRoundedClean,
              strokeWidth: 2,
              size: 32,
            ),
            const SizedBox(height: 5),
            Text(
              text,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            if (onPressedSettings != null) ...[
              const SizedBox(height: 10),
              AppIconButton(
                icon: HugeIcons.strokeRoundedSettings01,
                onPressed: onPressedSettings,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
