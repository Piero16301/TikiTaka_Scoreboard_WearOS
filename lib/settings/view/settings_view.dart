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
        children: [
          const SizedBox(height: AppVariables.topScaffoldSpacing),
          AppTitleText(title: l10n.titleSettings),
          ConfigurationSetting(
            title: l10n.titleLeagues,
            icon: HugeIcons.strokeRoundedFootball,
            route: LeaguesPage.routeName,
          ),
          const SizedBox(height: AppVariables.listSpacing),
          ConfigurationSetting(
            title: l10n.titleNotifications,
            icon: HugeIcons.strokeRoundedNotification01,
            route: NotificationsPage.routeName,
          ),
          const SizedBox(height: AppVariables.listSpacing),
          ConfigurationSetting(
            title: l10n.titleLanguage,
            icon: HugeIcons.strokeRoundedLanguageSkill,
            route: LanguagesPage.routeName,
          ),
          const SizedBox(height: AppVariables.listSpacing),
          ConfigurationSetting(
            title: l10n.titleTheme,
            icon: HugeIcons.strokeRoundedPaintBoard,
            route: ThemesPage.routeName,
          ),
          const SizedBox(height: AppVariables.listSpacing),
          ConfigurationSetting(
            title: l10n.titleFont,
            icon: HugeIcons.strokeRoundedTextFont,
            route: TypographyPage.routeName,
          ),
          const SizedBox(height: AppVariables.listFooterSpacing),
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
    return AppCardAction(
      onPressed: () {
        getIt<AnalyticsService>().logEvent(
          name: 'setting_option_clicked',
          parameters: {'route': route},
        );
        unawaited(Navigator.of(context).pushNamed(route));
      },
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          spacing: 5,
          children: [
            HugeIcon(
              icon: icon,
              color: Theme.of(context).colorScheme.primary,
            ),
            Expanded(child: Text(title)),
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
    final deviceInfo = getIt<DeviceInfoService>();

    return Column(
      children: [
        Text(
          deviceInfo.packageInfo.appName,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        Text(
          l10n.versionText(
            deviceInfo.packageInfo.version,
            deviceInfo.packageInfo.buildNumber,
          ),
          style: const TextStyle(fontSize: 10),
        ),
        Text(
          l10n.updatedOn(getDateOn(l10n, deviceInfo.packageInfo.updateTime)),
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

    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return DateFormat('HH:mm:ss').format(date);
    } else {
      return DateFormat('dd-MM-yyyy').format(date);
    }
  }
}
