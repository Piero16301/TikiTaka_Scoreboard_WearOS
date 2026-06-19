import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';
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

void main() {
  group('AppRoutes', () {
    test('routes map contains all necessary keys', () {
      expect(AppRoutes.routes.containsKey(HomePage.routeName), isTrue);
      expect(AppRoutes.routes.containsKey(MatchPage.routeName), isTrue);
      expect(AppRoutes.routes.containsKey(TeamPage.routeName), isTrue);
      expect(AppRoutes.routes.containsKey(SettingsPage.routeName), isTrue);
      expect(AppRoutes.routes.containsKey(LeaguesPage.routeName), isTrue);
      expect(AppRoutes.routes.containsKey(LanguagesPage.routeName), isTrue);
      expect(AppRoutes.routes.containsKey(ThemesPage.routeName), isTrue);
      expect(AppRoutes.routes.containsKey(TypographyPage.routeName), isTrue);
      expect(AppRoutes.routes.containsKey(NotificationsPage.routeName), isTrue);
      expect(AppRoutes.routes.containsKey(TeamsPage.routeName), isTrue);
    });

    testWidgets('Simple routes without arguments create correctly', (
      tester,
    ) async {
      late BuildContext testContext;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              testContext = context;
              return const SizedBox();
            },
          ),
        ),
      );

      final routesToTest = {
        HomePage.routeName: isA<HomePage>(),
        SettingsPage.routeName: isA<SettingsPage>(),
        LeaguesPage.routeName: isA<LeaguesPage>(),
        LanguagesPage.routeName: isA<LanguagesPage>(),
        ThemesPage.routeName: isA<ThemesPage>(),
        TypographyPage.routeName: isA<TypographyPage>(),
        NotificationsPage.routeName: isA<NotificationsPage>(),
      };

      for (final entry in routesToTest.entries) {
        final widget = AppRoutes.routes[entry.key]!(testContext);
        expect(widget, entry.value, reason: 'Failed for route ${entry.key}');
      }
    });

    group('Routes with arguments', () {
      testWidgets('MatchPage route with and without arguments', (tester) async {
        Widget? generatedWithArgs;
        Widget? generatedWithoutArgs;

        await tester.pumpWidget(
          MaterialApp(
            onGenerateRoute: (settings) {
              if (settings.name == '/with_args') {
                return MaterialPageRoute<void>(
                  settings: const RouteSettings(name: '/', arguments: 42),
                  builder: (context) {
                    generatedWithArgs = AppRoutes.routes[MatchPage.routeName]!(
                      context,
                    );
                    return const SizedBox();
                  },
                );
              }
              return MaterialPageRoute<void>(
                settings: const RouteSettings(name: '/'),
                builder: (context) {
                  generatedWithoutArgs = AppRoutes.routes[MatchPage.routeName]!(
                    context,
                  );
                  return const SizedBox();
                },
              );
            },
          ),
        );

        unawaited(
          tester
              .state<NavigatorState>(find.byType(Navigator))
              .pushNamed('/with_args'),
        );
        await tester.pumpAndSettle();

        expect(generatedWithArgs, isA<MatchPage>());
        expect((generatedWithArgs! as MatchPage).matchId, 42);

        expect(generatedWithoutArgs, isA<MatchPage>());
        expect((generatedWithoutArgs! as MatchPage).matchId, 0);
      });

      testWidgets('TeamPage route with and without arguments', (tester) async {
        Widget? generatedWithArgs;
        Widget? generatedWithoutArgs;

        await tester.pumpWidget(
          MaterialApp(
            onGenerateRoute: (settings) {
              if (settings.name == '/with_args') {
                return MaterialPageRoute<void>(
                  settings: const RouteSettings(name: '/', arguments: 73),
                  builder: (context) {
                    generatedWithArgs = AppRoutes.routes[TeamPage.routeName]!(
                      context,
                    );
                    return const SizedBox();
                  },
                );
              }
              return MaterialPageRoute<void>(
                settings: const RouteSettings(name: '/'),
                builder: (context) {
                  generatedWithoutArgs = AppRoutes.routes[TeamPage.routeName]!(
                    context,
                  );
                  return const SizedBox();
                },
              );
            },
          ),
        );

        unawaited(
          tester
              .state<NavigatorState>(find.byType(Navigator))
              .pushNamed('/with_args'),
        );
        await tester.pumpAndSettle();

        expect(generatedWithArgs, isA<TeamPage>());
        expect((generatedWithArgs! as TeamPage).teamId, 73);

        expect(generatedWithoutArgs, isA<TeamPage>());
        expect((generatedWithoutArgs! as TeamPage).teamId, 0);
      });

      testWidgets('TeamsPage route with and without arguments', (tester) async {
        Widget? generatedWithArgs;
        Widget? generatedWithoutArgs;

        await tester.pumpWidget(
          MaterialApp(
            onGenerateRoute: (settings) {
              if (settings.name == '/with_args') {
                return MaterialPageRoute<void>(
                  settings: const RouteSettings(name: '/', arguments: 99),
                  builder: (context) {
                    generatedWithArgs = AppRoutes.routes[TeamsPage.routeName]!(
                      context,
                    );
                    return const SizedBox();
                  },
                );
              }
              return MaterialPageRoute<void>(
                settings: const RouteSettings(name: '/'),
                builder: (context) {
                  generatedWithoutArgs = AppRoutes.routes[TeamsPage.routeName]!(
                    context,
                  );
                  return const SizedBox();
                },
              );
            },
          ),
        );

        unawaited(
          tester
              .state<NavigatorState>(find.byType(Navigator))
              .pushNamed('/with_args'),
        );
        await tester.pumpAndSettle();

        expect(generatedWithArgs, isA<TeamsPage>());
        expect((generatedWithArgs! as TeamsPage).leagueId, 99);

        expect(generatedWithoutArgs, isA<TeamsPage>());
        expect((generatedWithoutArgs! as TeamsPage).leagueId, 0);
      });
    });
  });
}
