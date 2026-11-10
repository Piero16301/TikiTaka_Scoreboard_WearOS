import 'package:material_ui/material_ui.dart';
import 'package:tiki_taka_scoreboard_wearos/home/home.dart';
import 'package:tiki_taka_scoreboard_wearos/languages/languages.dart';
import 'package:tiki_taka_scoreboard_wearos/leagues/leagues.dart';
import 'package:tiki_taka_scoreboard_wearos/match/match.dart';
import 'package:tiki_taka_scoreboard_wearos/notifications/notifications.dart';
import 'package:tiki_taka_scoreboard_wearos/settings/settings.dart';
import 'package:tiki_taka_scoreboard_wearos/team/team.dart';
import 'package:tiki_taka_scoreboard_wearos/teams/teams.dart';
import 'package:tiki_taka_scoreboard_wearos/themes/themes.dart';
import 'package:tiki_taka_scoreboard_wearos/typography/typography.dart';

class AppRoutes {
  static Map<String, Widget Function(BuildContext)> routes = {
    HomePage.routeName: (_) => const HomePage(),
    MatchPage.routeName: (context) {
      final args = ModalRoute.of(context)?.settings.arguments;
      final matchId = args is int
          ? args
          : int.tryParse(args?.toString() ?? '') ?? 0;
      return MatchPage(matchId: matchId);
    },
    TeamPage.routeName: (context) {
      final args = ModalRoute.of(context)?.settings.arguments;
      final teamId = args is int
          ? args
          : int.tryParse(args?.toString() ?? '') ?? 0;
      return TeamPage(teamId: teamId);
    },
    SettingsPage.routeName: (_) => const SettingsPage(),
    LeaguesPage.routeName: (_) => const LeaguesPage(),
    LanguagesPage.routeName: (_) => const LanguagesPage(),
    ThemesPage.routeName: (_) => const ThemesPage(),
    TypographyPage.routeName: (_) => const TypographyPage(),
    NotificationsPage.routeName: (_) => const NotificationsPage(),
    TeamsPage.routeName: (context) {
      final args = ModalRoute.of(context)?.settings.arguments;
      final leagueId = args is int
          ? args
          : int.tryParse(args?.toString() ?? '') ?? 0;
      return TeamsPage(leagueId: leagueId);
    },
  };
}
