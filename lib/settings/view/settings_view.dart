import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:rotary_scrollbar/rotary_scrollbar.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';
import 'package:tiki_taka_scoreboard_wearos/l10n/l10n.dart';
import 'package:tiki_taka_scoreboard_wearos/languages/languages.dart';
import 'package:tiki_taka_scoreboard_wearos/leagues/leagues.dart';
import 'package:tiki_taka_scoreboard_wearos/notifications/notifications.dart';
import 'package:tiki_taka_scoreboard_wearos/themes/themes.dart';
import 'package:wearable_rotary/wearable_rotary.dart'
    as wearable_rotary
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
                      text: l10n.titleSettings.toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: titleSize,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ConfigurationSetting(
                    title: l10n.titleLeagues.toUpperCase(),
                    icon: HugeIcons.strokeRoundedFootball,
                    route: LeaguesPage.routeName,
                  ),
                  ConfigurationSetting(
                    title: l10n.titleNotifications.toUpperCase(),
                    icon: HugeIcons.strokeRoundedNotification01,
                    route: NotificationsPage.routeName,
                  ),
                  ConfigurationSetting(
                    title: l10n.titleLanguage.toUpperCase(),
                    icon: HugeIcons.strokeRoundedLanguageSkill,
                    route: LanguagesPage.routeName,
                  ),
                  ConfigurationSetting(
                    title: l10n.titleTheme.toUpperCase(),
                    icon: HugeIcons.strokeRoundedPaintBoard,
                    route: ThemesPage.routeName,
                  ),
                  const BackButtonSettings(),
                  const AppInfoSettings(),
                  const SizedBox(height: 30),
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
  final List<List<dynamic>> icon;
  final String route;

  @override
  Widget build(BuildContext context) {
    return AppCardData(
      child: Row(
        children: [
          const SizedBox(width: 10),
          HugeIcon(
            icon: icon,
            size: 30,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 5),
          Expanded(child: ScrollText(text: title)),
          const SizedBox(width: 5),
          IconButton(
            onPressed: () => Navigator.of(context).pushNamed(route),
            icon: const Icon(Icons.arrow_forward_ios),
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}

class BackButtonSettings extends StatelessWidget {
  const BackButtonSettings({super.key});

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
              padding: const EdgeInsets.symmetric(vertical: 14),
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
      ),
    );
  }
}

class AppInfoSettings extends StatelessWidget {
  const AppInfoSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final packageInfo = LocalSettingsService.instance.packageInfo;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Column(
        children: [
          Text(
            packageInfo.appName,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(
            'Version: ${packageInfo.version} (${packageInfo.buildNumber})',
            style: const TextStyle(fontSize: 10),
          ),
          Text(
            '${l10n.updatedOn}: ${getDateOn(l10n, packageInfo.updateTime)}',
            style: const TextStyle(fontSize: 10),
          ),
        ],
      ),
    );
  }

  String getDateOn(AppLocalizations l10n, DateTime? date) {
    if (date == null) {
      return l10n.todayText;
    }

    final now = DateTime.now().toLocal();

    // Check if the date is today
    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return DateFormat('HH:mm:ss').format(date);
    }
    // Otherwise return date as dd-MM-yyyy
    else {
      return DateFormat('dd-MM-yyyy').format(date);
    }
  }
}
