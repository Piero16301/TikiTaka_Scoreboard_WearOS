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
import 'package:tiki_taka_scoreboard_wearos/typography/typography.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final _scrollController = ScrollController(keepScrollOffset: false);

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
      child: Column(
        spacing: AppVariables.scaffoldSpacing,
        children: [
          const SizedBox(height: AppVariables.topScaffoldSpacing),
          AppTitleText(title: l10n.titleSettings.toUpperCase()),
          ConfigurationSetting(
            title: l10n.titleLeagues,
            icon: HugeIcons.strokeRoundedFootball,
            route: LeaguesPage.routeName,
          ),
          ConfigurationSetting(
            title: l10n.titleNotifications,
            icon: HugeIcons.strokeRoundedNotification01,
            route: NotificationsPage.routeName,
          ),
          ConfigurationSetting(
            title: l10n.titleLanguage,
            icon: HugeIcons.strokeRoundedLanguageSkill,
            route: LanguagesPage.routeName,
          ),
          ConfigurationSetting(
            title: l10n.titleTheme,
            icon: HugeIcons.strokeRoundedPaintBoard,
            route: ThemesPage.routeName,
          ),
          ConfigurationSetting(
            title: l10n.titleFont,
            icon: HugeIcons.strokeRoundedTextFont,
            route: TypographyPage.routeName,
          ),
          const BackButtonSettings(),
          const AppInfoSettings(),
          const SizedBox(height: AppVariables.bottomScaffoldSpacing),
        ],
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
      content: Row(
        spacing: 5,
        children: [
          HugeIcon(
            icon: icon,
            size: 30,
            color: Theme.of(context).colorScheme.primary,
          ),
          Expanded(child: ScrollText(text: title)),
          SizedBox(
            width: 40,
            height: 40,
            child: IconButton(
              onPressed: () {
                getIt<AnalyticsService>().logEvent(
                  name: 'setting_option_clicked',
                  parameters: {'route': route},
                );
                unawaited(Navigator.of(context).pushNamed(route));
              },
              icon: const Icon(Icons.arrow_forward_ios),
              padding: EdgeInsets.zero,
            ),
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
      padding: const EdgeInsets.only(
        top: AppVariables.bottomScaffoldSpacingButton,
      ),
      child: Row(
        children: [
          Expanded(
            child: AppFilledButton(
              onPressed: () => Navigator.of(context).pop(),
              label: l10n.backText,
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
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
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
