import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tiki_taka_scoreboard_wearos/app/misc/app_routes.dart';
import 'package:tiki_taka_scoreboard_wearos/home/home.dart';
import 'package:tiki_taka_scoreboard_wearos/languages/languages.dart';
import 'package:tiki_taka_scoreboard_wearos/leagues/leagues.dart';
import 'package:tiki_taka_scoreboard_wearos/match/match.dart';
import 'package:tiki_taka_scoreboard_wearos/notifications/notifications.dart';
import 'package:tiki_taka_scoreboard_wearos/settings/settings.dart';
import 'package:tiki_taka_scoreboard_wearos/team/team.dart';
import 'package:tiki_taka_scoreboard_wearos/teams/teams.dart';
import 'package:tiki_taka_scoreboard_wearos/themes/themes.dart';

void main() {
  group('AppRoutes', () {
    test('routes map contains all expected routes', () {
      expect(AppRoutes.routes, isNotNull);
      expect(AppRoutes.routes.length, equals(9));

      expect(AppRoutes.routes.containsKey(HomePage.routeName), isTrue);
      expect(AppRoutes.routes.containsKey(MatchPage.routeName), isTrue);
      expect(AppRoutes.routes.containsKey(TeamPage.routeName), isTrue);
      expect(AppRoutes.routes.containsKey(SettingsPage.routeName), isTrue);
      expect(AppRoutes.routes.containsKey(LeaguesPage.routeName), isTrue);
      expect(AppRoutes.routes.containsKey(LanguagesPage.routeName), isTrue);
      expect(AppRoutes.routes.containsKey(ThemesPage.routeName), isTrue);
      expect(
        AppRoutes.routes.containsKey(NotificationsPage.routeName),
        isTrue,
      );
      expect(AppRoutes.routes.containsKey(TeamsPage.routeName), isTrue);
    });

    group('route builders', () {
      testWidgets('HomePage route builds correctly', (tester) async {
        final context = await _createTestContext(tester);
        final widget = AppRoutes.routes[HomePage.routeName]!(context);

        expect(widget, isA<HomePage>());
      });

      testWidgets('MatchPage route builds correctly with argument', (
        tester,
      ) async {
        const testMatchId = 123;
        final context = await _createTestContext(
          tester,
          arguments: testMatchId,
        );
        final widget = AppRoutes.routes[MatchPage.routeName]!(context);

        expect(widget, isA<MatchPage>());
      });

      testWidgets(
        'MatchPage route builds with default value when no argument',
        (tester) async {
          final context = await _createTestContext(tester);
          final widget = AppRoutes.routes[MatchPage.routeName]!(context);

          expect(widget, isA<MatchPage>());
        },
      );

      testWidgets('TeamPage route builds correctly with argument', (
        tester,
      ) async {
        const testTeamId = 456;
        final context = await _createTestContext(
          tester,
          arguments: testTeamId,
        );
        final widget = AppRoutes.routes[TeamPage.routeName]!(context);

        expect(widget, isA<TeamPage>());
      });

      testWidgets('TeamPage route builds with default value when no argument', (
        tester,
      ) async {
        final context = await _createTestContext(tester);
        final widget = AppRoutes.routes[TeamPage.routeName]!(context);

        expect(widget, isA<TeamPage>());
      });

      testWidgets('SettingsPage route builds correctly', (tester) async {
        final context = await _createTestContext(tester);
        final widget = AppRoutes.routes[SettingsPage.routeName]!(context);

        expect(widget, isA<SettingsPage>());
      });

      testWidgets('LeaguesPage route builds correctly', (tester) async {
        final context = await _createTestContext(tester);
        final widget = AppRoutes.routes[LeaguesPage.routeName]!(context);

        expect(widget, isA<LeaguesPage>());
      });

      testWidgets('LanguagesPage route builds correctly', (tester) async {
        final context = await _createTestContext(tester);
        final widget = AppRoutes.routes[LanguagesPage.routeName]!(context);

        expect(widget, isA<LanguagesPage>());
      });

      testWidgets('ThemesPage route builds correctly', (tester) async {
        final context = await _createTestContext(tester);
        final widget = AppRoutes.routes[ThemesPage.routeName]!(context);

        expect(widget, isA<ThemesPage>());
      });

      testWidgets('NotificationsPage route builds correctly', (tester) async {
        final context = await _createTestContext(tester);
        final widget = AppRoutes.routes[NotificationsPage.routeName]!(context);

        expect(widget, isA<NotificationsPage>());
      });

      testWidgets('TeamsPage route builds correctly with argument', (
        tester,
      ) async {
        const testLeagueId = 789;
        final context = await _createTestContext(
          tester,
          arguments: testLeagueId,
        );
        final widget = AppRoutes.routes[TeamsPage.routeName]!(context);

        expect(widget, isA<TeamsPage>());
      });

      testWidgets(
        'TeamsPage route builds with default value when no argument',
        (tester) async {
          final context = await _createTestContext(tester);
          final widget = AppRoutes.routes[TeamsPage.routeName]!(context);

          expect(widget, isA<TeamsPage>());
        },
      );
    });
  });
}

Future<BuildContext> _createTestContext(
  WidgetTester tester, {
  Object? arguments,
}) async {
  late BuildContext capturedContext;

  await tester.pumpWidget(
    MaterialApp(
      home: Builder(
        builder: (context) {
          capturedContext = context;
          return const SizedBox();
        },
      ),
      onGenerateRoute: (settings) {
        return MaterialPageRoute<void>(
          settings: RouteSettings(
            name: settings.name,
            arguments: arguments,
          ),
          builder: (context) {
            capturedContext = context;
            return const SizedBox();
          },
        );
      },
    ),
  );

  return capturedContext;
}
