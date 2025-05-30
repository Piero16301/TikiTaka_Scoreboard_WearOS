import 'dart:async';

import 'package:dash_flags/dash_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rotary_scrollbar/rotary_scrollbar.dart';
import 'package:tiki_taka/app/app.dart';
import 'package:tiki_taka/l10n/l10n.dart';
import 'package:wearable_rotary/wearable_rotary.dart' as wearable_rotary
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

    return Scaffold(
      body: SizedBox.expand(
        child: RotaryScrollbar(
          controller: _scrollController,
          scrollAnimationCurve: Curves.easeInOut,
          scrollAnimationDuration: scrollDuration,
          scrollMagnitude: scrollMagnitude,
          width: scrollWidth,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: ScrollText(
                      text: l10n.titleLanguage.toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: titleSize,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  CardLanguages(
                    value: 'en_US',
                    flag: l10n.englishFlag,
                    language: l10n.englishLanguage,
                  ),
                  CardLanguages(
                    value: 'es_ES',
                    flag: l10n.spanishFlag,
                    language: l10n.spanishLanguage,
                  ),
                  CardLanguages(
                    value: 'it_IT',
                    flag: l10n.italianFlag,
                    language: l10n.italianLanguage,
                  ),
                  const BackButtonLanguages(),
                  const SizedBox(height: 50),
                ],
              ),
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
    required this.flag,
    required this.language,
    super.key,
  });

  final String value;
  final String flag;
  final String language;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SizedBox(
        height: 50,
        child: Card(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Stack(
            children: [
              Opacity(
                opacity: 0.1,
                child: CountryFlag(
                  country: Country.fromCode(flag),
                  height: double.infinity,
                ),
              ),
              Row(
                children: [
                  BlocBuilder<AppCubit, AppState>(
                    builder: (context, state) => Radio<String>(
                      value: value,
                      groupValue: state.language,
                      onChanged: (v) =>
                          context.read<AppCubit>().changeLanguage(v ?? value),
                    ),
                  ),
                  Expanded(child: ScrollText(text: language)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BackButtonLanguages extends StatelessWidget {
  const BackButtonLanguages({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: ElevatedButton(
        onPressed: () => Navigator.of(context).pop(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                l10n.backText.toUpperCase(),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
