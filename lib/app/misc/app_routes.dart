import 'package:flutter/material.dart';
import 'package:tiki_taka/home/home.dart';
import 'package:tiki_taka/languages/languages.dart';
import 'package:tiki_taka/leagues/leagues.dart';
import 'package:tiki_taka/match/match.dart';
import 'package:tiki_taka/notifications/notifications.dart';
import 'package:tiki_taka/settings/settings.dart';
import 'package:tiki_taka/teams/teams.dart';
import 'package:tiki_taka/themes/themes.dart';

class AppRoutes {
  static Map<String, Widget Function(BuildContext)> routes = {
    HomePage.routeName: (_) => const HomePage(),
    MatchPage.routeName: (context) => MatchPage(
          matchId: ModalRoute.of(context)!.settings.arguments as int? ?? 0,
        ),
    SettingsPage.routeName: (_) => const SettingsPage(),
    LeaguesPage.routeName: (_) => const LeaguesPage(),
    LanguagesPage.routeName: (_) => const LanguagesPage(),
    ThemesPage.routeName: (_) => const ThemesPage(),
    NotificationsPage.routeName: (_) => const NotificationsPage(),
    TeamsPage.routeName: (context) => TeamsPage(
          leagueId: ModalRoute.of(context)!.settings.arguments as int? ?? 0,
        ),
  };
}
