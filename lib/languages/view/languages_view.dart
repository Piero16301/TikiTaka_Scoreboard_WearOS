import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';
import 'package:tiki_taka_scoreboard_wearos/l10n/l10n.dart';

class LanguagesView extends StatelessWidget {
  const LanguagesView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AppScaffold(
      child: SingleChildScrollView(
        child: BlocBuilder<AppCubit, AppState>(
          builder: (context, state) => RadioGroup<Locale>(
            groupValue: state.language,
            onChanged: (value) => context.read<AppCubit>().changeLanguage(
                  language: value ?? AppVariables.supportedLocales.first,
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
                    text: l10n.titleLanguage.toUpperCase(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: AppVariables.titleSize,
                    ),
                  ),
                ),
                ...AppVariables.supportedLocales.map(
                  (locale) => CardLanguages(
                    value: locale,
                    label: AppFunctions.getLanguageLabel(l10n, locale),
                  ),
                ),
                const BackButtonLanguages(),
                const SizedBox(height: AppVariables.bottomScaffoldSpacing),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CardLanguages extends StatelessWidget {
  const CardLanguages({
    required this.value,
    required this.label,
    super.key,
  });

  final Locale value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return AppCardData(
      child: Row(
        children: [
          Radio<Locale>(value: value),
          Expanded(child: ScrollText(text: label)),
        ],
      ),
    );
  }
}

class BackButtonLanguages extends StatelessWidget {
  const BackButtonLanguages({super.key});

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
