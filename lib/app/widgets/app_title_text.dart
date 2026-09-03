import 'package:auto_size_text/auto_size_text.dart';
import 'package:material_ui/material_ui.dart';
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
      child: AutoSizeText(
        title,
        textAlign: TextAlign.center,
        maxLines: 2,
        minFontSize: 10,
        style: TextStyle(
          fontSize: AppVariables.titleSize,
          height: AppVariables.titleTextHeight,
          fontVariations: <FontVariation>[
            ...(Theme.of(
                      context,
                    ).textTheme.bodyMedium?.fontVariations ??
                    const <FontVariation>[])
                .where((v) => v.axis != 'wght'),
            const FontVariation('wght', 700),
          ],
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
