import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';
import 'package:tiki_taka_scoreboard_wearos/l10n/l10n.dart';

class LanguagesView extends StatefulWidget {
  const LanguagesView({super.key});

  @override
  State<LanguagesView> createState() => _LanguagesViewState();
}

class _LanguagesViewState extends State<LanguagesView> {
  final ScrollController _scrollController = ScrollController(
    keepScrollOffset: false,
  );

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    const locales = AppVariables.supportedLocales;

    return AppScaffold.scrollable(
      controller: _scrollController,
      child: BlocBuilder<AppCubit, AppState>(
        builder: (context, state) => RadioGroup<Locale>(
          groupValue: state.language,
          onChanged: (v) {},
          child: Column(
            children: [
              const SizedBox(height: AppVariables.topScaffoldSpacing),
              AppTitleText(title: l10n.titleLanguage),
              for (final (index, locale) in locales.indexed) ...[
                CardLanguages(
                  value: locale,
                  label: AppFunctions.getLanguageLabel(l10n, locale),
                ),
                if (index < locales.length - 1)
                  const SizedBox(height: AppVariables.listSpacing),
              ],
              const SizedBox(height: AppVariables.bottomScaffoldSpacing),
            ],
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
    return AppCardAction(
      onPressed: () => context.read<AppCubit>().changeLanguage(language: value),
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 7),
        child: Row(
          spacing: 5,
          children: [
            SizedBox.square(
              dimension: 20,
              child: IgnorePointer(
                child: Radio<Locale>(value: value),
              ),
            ),
            Expanded(child: Text(label)),
          ],
        ),
      ),
    );
  }
}
