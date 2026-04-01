import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';
import 'package:tiki_taka_scoreboard_wearos/l10n/l10n.dart';

class ThemesView extends StatefulWidget {
  const ThemesView({super.key});

  @override
  State<ThemesView> createState() => _ThemesViewState();
}

class _ThemesViewState extends State<ThemesView> {
  final ScrollController _scrollController =
      ScrollController(keepScrollOffset: false);

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AppScaffold.scrollable(
      controller: _scrollController,
      child: BlocBuilder<AppCubit, AppState>(
        builder: (context, state) => RadioGroup<Color>(
          groupValue: state.baseColor,
          onChanged: (value) => context.read<AppCubit>().changeBaseColor(
                baseColor: value ?? AppVariables.defaultBaseColor,
              ),
          child: Column(
            spacing: AppVariables.scaffoldSpacing,
            children: [
              const SizedBox(height: AppVariables.topScaffoldSpacing),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppVariables.horizontalPaddingTitle,
                ),
                child: ScrollText(
                  text: l10n.titleTheme.toUpperCase(),
                  style: const TextStyle(
                    fontSize: AppVariables.titleSize,
                    height: AppVariables.titleTextHeight,
                  ),
                ),
              ),
              ...ColorHelper.colorMap.entries.map(
                (entry) => CardColorThemes(
                  text: entry.key,
                  color: entry.value,
                ),
              ),
              const BackButtonThemes(),
              const SizedBox(height: AppVariables.bottomScaffoldSpacing),
            ],
          ),
        ),
      ),
    );
  }
}

class CardColorThemes extends StatelessWidget {
  const CardColorThemes({
    required this.text,
    required this.color,
    super.key,
  });

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorName = AppFunctions.getColorName(text, l10n);

    return AppCardData(
      content: Row(
        children: [
          Radio<Color>(value: color),
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(child: ScrollText(text: colorName)),
        ],
      ),
    );
  }
}

class BackButtonThemes extends StatelessWidget {
  const BackButtonThemes({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Row(
      children: [
        Expanded(
          child: AppFilledButton(
            onPressed: () => Navigator.of(context).pop(),
            label: l10n.backText.toUpperCase(),
          ),
        ),
      ],
    );
  }
}
