import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';
import 'package:tiki_taka_scoreboard_wearos/l10n/l10n.dart';
import 'package:tiki_taka_scoreboard_wearos/languages/languages.dart';
import 'package:tiki_taka_scoreboard_wearos/leagues/leagues.dart';
import 'package:tiki_taka_scoreboard_wearos/notifications/notifications.dart';
import 'package:tiki_taka_scoreboard_wearos/themes/themes.dart';
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
    final l10n = AppLocalizations.of(context);

    return AppScaffold(
      controller: _scrollController,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          spacing: AppVariables.scaffoldSpacing,
          children: [
            const SizedBox(height: AppVariables.topScaffoldSpacing),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppVariables.horizontalPaddingTitle,
              ),
              child: ScrollText(
                text: l10n.titleSettings.toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: AppVariables.titleSize,
                ),
              ),
            ),
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
            const SizedBox(height: AppVariables.bottomScaffoldSpacing),
          ],
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
        spacing: 5,
        children: [
          const SizedBox(width: 2),
          HugeIcon(
            icon: icon,
            size: 30,
            color: Theme.of(context).colorScheme.primary,
          ),
          Expanded(child: ScrollText(text: title)),
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

class AppInfoSettings extends StatelessWidget {
  const AppInfoSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final deviceInfo = getIt<DeviceInfoService>();

    return Column(
      children: [
        Text(
          deviceInfo.packageInfo.appName,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text(
          'Version: ${deviceInfo.packageInfo.version} '
          '(${deviceInfo.packageInfo.buildNumber})',
          style: const TextStyle(fontSize: 10),
        ),
        Text(
          '${l10n.updatedOn}: '
          '${getDateOn(l10n, deviceInfo.packageInfo.updateTime)}',
          style: const TextStyle(fontSize: 10),
        ),
      ],
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
