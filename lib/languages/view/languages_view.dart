import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';
import 'package:tiki_taka_scoreboard_wearos/l10n/l10n.dart';
import 'package:wearable_rotary/wearable_rotary.dart'
    as wearable_rotary
    show rotaryEvents;
import 'package:wearable_rotary/wearable_rotary.dart' hide rotaryEvents;

class LanguagesView extends StatefulWidget {
  LanguagesView({
    super.key,
    @visibleForTesting Stream<RotaryEvent>? rotaryEvents,
  }) : rotaryEvents = rotaryEvents ?? wearable_rotary.rotaryEvents;

  final Stream<RotaryEvent> rotaryEvents;

  @override
  State<LanguagesView> createState() => _LanguagesViewState();
}

class _LanguagesViewState extends State<LanguagesView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AppScaffold(
      controller: _scrollController,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: BlocBuilder<AppCubit, AppState>(
          builder: (context, state) => RadioGroup<String>(
            groupValue: state.language,
            onChanged: (value) =>
                context.read<AppCubit>().changeLanguage(value ?? 'en_US'),
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
                CardLanguages(
                  value: 'en_US',
                  language: l10n.englishLanguage,
                ),
                CardLanguages(
                  value: 'es_ES',
                  language: l10n.spanishLanguage,
                ),
                CardLanguages(
                  value: 'it_IT',
                  language: l10n.italianLanguage,
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
    required this.language,
    super.key,
  });

  final String value;
  final String language;

  @override
  Widget build(BuildContext context) {
    return AppCardData(
      child: Row(
        children: [
          Radio<String>(value: value),
          Expanded(child: ScrollText(text: language)),
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

    return ElevatedButton(
      onPressed: () => Navigator.of(context).pop(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: AppVariables.verticalPaddingBackButton,
            ),
            child: Text(
              l10n.backText.toUpperCase(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
