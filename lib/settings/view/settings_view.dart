import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rotary_scrollbar/rotary_scrollbar.dart';
import 'package:tiki_taka/app/app.dart';
import 'package:tiki_taka/l10n/l10n.dart';
import 'package:tiki_taka/languages/languages.dart';
import 'package:tiki_taka/leagues/leagues.dart';
import 'package:tiki_taka/themes/themes.dart';
import 'package:wearable_rotary/wearable_rotary.dart' as wearable_rotary
    show rotaryEvents;
import 'package:wearable_rotary/wearable_rotary.dart' hide rotaryEvents;

class SettingsView extends StatefulWidget {
  SettingsView({
    super.key,
    @visibleForTesting Stream<RotaryEvent>? rotaryEvents,
  }) : rotaryEvents = rotaryEvents ?? wearable_rotary.rotaryEvents;

  final Stream<RotaryEvent> rotaryEvents;

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

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
                  const SizedBox(height: 10),
                  Text(
                    l10n.titleSettings.toUpperCase(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ConfigurationSetting(
                    title: l10n.titleLeagues.toUpperCase(),
                    icon: Icons.sports_soccer,
                    route: LeaguesPage.routeName,
                  ),
                  ConfigurationSetting(
                    title: l10n.titleLanguage.toUpperCase(),
                    icon: Icons.language,
                    route: LanguagesPage.routeName,
                  ),
                  ConfigurationSetting(
                    title: l10n.titleTheme.toUpperCase(),
                    icon: Icons.palette,
                    route: ThemesPage.routeName,
                  ),
                  const BackButtonSettings(),
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

class ConfigurationSetting extends StatelessWidget {
  const ConfigurationSetting({
    required this.title,
    required this.icon,
    required this.route,
    super.key,
  });

  final String title;
  final IconData icon;
  final String route;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Card(
        child: Row(
          spacing: 10,
          children: [
            const SizedBox(width: 0),
            Icon(icon, size: 30),
            Expanded(child: ScrollText(text: title)),
            IconButton(
              onPressed: () => Navigator.of(context).pushNamed(route),
              icon: const Icon(Icons.arrow_forward_ios),
              padding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }
}

class BackButtonSettings extends StatelessWidget {
  const BackButtonSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

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
