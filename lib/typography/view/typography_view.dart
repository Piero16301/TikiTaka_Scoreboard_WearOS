import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';
import 'package:tiki_taka_scoreboard_wearos/l10n/l10n.dart';

class TypographyView extends StatefulWidget {
  const TypographyView({super.key});

  @override
  State<TypographyView> createState() => _TypographyViewState();
}

class _TypographyViewState extends State<TypographyView> {
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
        builder: (context, state) => RadioGroup<String>(
          groupValue: state.fontFamily,
          onChanged: (value) => context.read<AppCubit>().changeFontFamily(
                fontFamily: value ?? AppVariables.defaultFontFamily,
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
                  text: l10n.titleFont.toUpperCase(),
                  style: const TextStyle(
                    fontSize: AppVariables.titleSize,
                    height: AppVariables.titleTextHeight,
                  ),
                ),
              ),
              ...AppVariables.availableFonts.entries.map(
                (entry) => CardFonts(
                  label: entry.key,
                  value: entry.value,
                ),
              ),
              const BackButtonFonts(),
              const SizedBox(height: AppVariables.bottomScaffoldSpacing),
            ],
          ),
        ),
      ),
    );
  }
}

class CardFonts extends StatelessWidget {
  const CardFonts({
    required this.label,
    required this.value,
    super.key,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return AppCardData(
      content: Row(
        children: [
          Radio<String>(value: value),
          Expanded(
            child: ScrollText(
              text: label,
              style: TextStyle(
                fontFamily: value,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BackButtonFonts extends StatelessWidget {
  const BackButtonFonts({super.key});

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
