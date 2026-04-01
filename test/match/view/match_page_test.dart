import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';
import 'package:tiki_taka_scoreboard_wearos/l10n/l10n.dart';
import 'package:tiki_taka_scoreboard_wearos/match/match.dart';
import 'package:tiki_taka_scoreboard_wearos/team/team.dart';

class MockMatchCubit extends MockCubit<MatchState> implements MatchCubit {}

class MockDatabaseService extends Mock implements DatabaseService {}

class MockMatch extends Mock implements Match {}

class MockTeam extends Mock implements Team {}

class MockScore extends Mock implements Score {}

class MockTime extends Mock implements Time {}

class MockArea extends Mock implements Area {}

class MockLeague extends Mock implements League {}

class MockSeason extends Mock implements Season {}

class MockReferee extends Mock implements Referee {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class FakeRoute extends Fake implements Route<dynamic> {}

class MockAnalyticsService extends Mock implements AnalyticsService {}

void main() {
  group('MatchPage and MatchView', () {
    late MockMatchCubit matchCubit;
    late MockDatabaseService mockDatabase;
    late MockAnalyticsService mockAnalytics;

    setUpAll(() async {
      mockDatabase = MockDatabaseService();
      mockAnalytics = MockAnalyticsService();

      if (getIt.isRegistered<DatabaseService>()) {
        await getIt.unregister<DatabaseService>();
      }
      getIt.registerSingleton<DatabaseService>(mockDatabase);

      if (getIt.isRegistered<AnalyticsService>()) {
        await getIt.unregister<AnalyticsService>();
      }
      getIt.registerSingleton<AnalyticsService>(mockAnalytics);

      registerFallbackValue(FakeRoute());
    });

    setUp(() {
      matchCubit = MockMatchCubit();

      when(() => matchCubit.state).thenReturn(const MatchState(matchId: 1));
      when(() => matchCubit.initialize(matchId: 1)).thenAnswer((_) async {});
      when(
        () => mockAnalytics.logEvent(
          name: any(named: 'name'),
          parameters: any(named: 'parameters'),
        ),
      ).thenAnswer((_) async {});
    });

    testWidgets('renders MatchPage properly and shows shimmers when loading',
        (tester) async {
      when(() => mockDatabase.getMatchStream(matchId: 1))
          .thenAnswer((_) => const Stream.empty());

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: BlocProvider<MatchCubit>.value(
            value: matchCubit,
            child: const MatchPage(matchId: 1),
          ),
        ),
      );

      expect(find.byType(MatchPage), findsOneWidget);
      expect(find.byType(MatchView), findsOneWidget);
    });

    testWidgets('shows error state when stream emits error', (tester) async {
      when(() => mockDatabase.getMatchStream(matchId: 1))
          .thenAnswer((_) => Stream.error('Error'));

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: BlocProvider<MatchCubit>.value(
            value: matchCubit,
            child: const MatchView(),
          ),
        ),
      );

      await tester.pump();

      expect(find.text('Error loading match'), findsOneWidget);
    });

    testWidgets('shows match details when stream emits data', (tester) async {
      final mockMatch = MockMatch();
      final homeTeam = MockTeam();
      final awayTeam = MockTeam();
      final score = MockScore();
      final halfTime = MockTime();
      final fullTime = MockTime();
      final area = MockArea();
      final league = MockLeague();
      final season = MockSeason();

      when(() => homeTeam.id).thenReturn(10);
      when(() => homeTeam.name).thenReturn('Home Team FC');
      when(() => homeTeam.crest).thenReturn('home.png');

      when(() => awayTeam.id).thenReturn(20);
      when(() => awayTeam.name).thenReturn('Away Team FC');
      when(() => awayTeam.crest).thenReturn('away.png');

      when(() => halfTime.home).thenReturn(1);
      when(() => halfTime.away).thenReturn(0);
      when(() => fullTime.home).thenReturn(2);
      when(() => fullTime.away).thenReturn(1);

      when(() => score.halfTime).thenReturn(halfTime);
      when(() => score.fullTime).thenReturn(fullTime);

      when(() => area.name).thenReturn('England');
      when(() => area.flag).thenReturn('england.png');

      when(() => league.id).thenReturn(123);
      when(() => league.name).thenReturn('Premier League');
      when(() => league.emblem).thenReturn('pl.png');

      when(() => season.startDate).thenReturn(DateTime(2023, 8));
      when(() => season.endDate).thenReturn(DateTime(2024, 5, 30));

      when(() => mockMatch.homeTeam).thenReturn(homeTeam);
      when(() => mockMatch.awayTeam).thenReturn(awayTeam);
      when(() => mockMatch.score).thenReturn(score);
      when(() => mockMatch.area).thenReturn(area);
      when(() => mockMatch.competition).thenReturn(league);
      when(() => mockMatch.season).thenReturn(season);
      when(() => mockMatch.status).thenReturn('FINISHED');
      when(() => mockMatch.utcDate).thenReturn(DateTime.now());
      when(() => mockMatch.matchday).thenReturn(5);
      final mockReferee = MockReferee();
      when(() => mockReferee.name).thenReturn('John Doe');
      when(() => mockReferee.nationality).thenReturn('England');

      when(() => mockMatch.referees).thenReturn([mockReferee]);

      when(() => mockDatabase.getMatchStream(matchId: 1))
          .thenAnswer((_) => Stream.value(mockMatch));
      when(
        () => mockDatabase.getConfigStream(id: AppVariables.matchesCollection),
      ).thenAnswer(
        (_) => Stream.value(Config(id: '', lastUpdate: DateTime.now())),
      );
      when(() => mockDatabase.getStandingsStream(leagueId: '123'))
          .thenAnswer((_) => Stream.value(LeagueStandings.empty));

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: BlocProvider<MatchCubit>.value(
            value: matchCubit,
            child: const MatchView(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Home Team FC'), findsOneWidget);
      expect(find.text('Away Team FC'), findsOneWidget);
      expect(find.text('Premier League'), findsOneWidget);
      expect(find.text('John Doe'), findsOneWidget);
    });

    testWidgets('shows standings and navigates when teams are clicked',
        (tester) async {
      final mockMatch = MockMatch();
      final homeTeam = MockTeam();
      final awayTeam = MockTeam();
      final score = MockScore();
      final area = MockArea();
      final league = MockLeague();
      final season = MockSeason();

      when(() => homeTeam.id).thenReturn(10);
      when(() => homeTeam.name).thenReturn('Home Team FC');
      when(() => homeTeam.crest).thenReturn('home.png');
      when(() => awayTeam.id).thenReturn(20);
      when(() => awayTeam.name).thenReturn('Away Team FC');
      when(() => awayTeam.crest).thenReturn('away.png');

      final halfTime = MockTime();
      final fullTime = MockTime();
      when(() => halfTime.home).thenReturn(1);
      when(() => halfTime.away).thenReturn(0);
      when(() => fullTime.home).thenReturn(2);
      when(() => fullTime.away).thenReturn(1);
      when(() => score.halfTime).thenReturn(halfTime);
      when(() => score.fullTime).thenReturn(fullTime);

      when(() => area.name).thenReturn('England');
      when(() => area.flag).thenReturn('england.png');
      when(() => league.id).thenReturn(123);
      when(() => league.name).thenReturn('Premier League');
      when(() => league.emblem).thenReturn('pl.png');
      when(() => season.startDate).thenReturn(DateTime(2023, 8));
      when(() => season.endDate).thenReturn(DateTime(2024, 5, 30));

      when(() => mockMatch.homeTeam).thenReturn(homeTeam);
      when(() => mockMatch.awayTeam).thenReturn(awayTeam);
      when(() => mockMatch.score).thenReturn(score);
      when(() => mockMatch.area).thenReturn(area);
      when(() => mockMatch.competition).thenReturn(league);
      when(() => mockMatch.season).thenReturn(season);
      when(() => mockMatch.status).thenReturn('IN_PLAY');
      when(() => mockMatch.utcDate).thenReturn(DateTime.now());
      when(() => mockMatch.matchday).thenReturn(5);
      when(() => mockMatch.referees).thenReturn([]);

      when(() => mockDatabase.getMatchStream(matchId: 1))
          .thenAnswer((_) => Stream.value(mockMatch));
      when(
        () => mockDatabase.getConfigStream(id: AppVariables.matchesCollection),
      ).thenAnswer(
        (_) => Stream.value(Config(id: '', lastUpdate: DateTime.now())),
      );

      final singleStanding = {
        AppVariables.standingsCollection: [
          {
            'stage': 'REGULAR_SEASON',
            'type': 'TOTAL',
            'group': 'GROUP A',
            'table': [
              {
                'position': 1,
                'team': {
                  'id': 10,
                  'name': 'Home Team FC',
                  'tla': 'HOM',
                  'crest': '',
                },
                'playedGames': 3,
                'goalDifference': 2,
                'points': 7,
              },
              {
                'position': 2,
                'team': {
                  'id': 20,
                  'name': 'Away Team FC',
                  'tla': 'AWA',
                  'crest': '',
                },
                'playedGames': 3,
                'goalDifference': 1,
                'points': 6,
              }
            ],
          }
        ],
      };

      when(() => mockDatabase.getStandingsStream(leagueId: '123')).thenAnswer(
        (_) => Stream.value(
          LeagueStandings.fromJson({
            'leagueId': '123',
            'standings': singleStanding[AppVariables.standingsCollection],
          }),
        ),
      );

      final mockObserver = MockNavigatorObserver();

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          navigatorObservers: [mockObserver],
          routes: {
            TeamPage.routeName: (context) => Scaffold(
                  appBar: AppBar(),
                  body: const Text('TeamPageScreen'),
                ),
          },
          home: BlocProvider<MatchCubit>.value(
            value: matchCubit,
            child: const MatchView(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.byType(CrestImage).first);
      await tester.pumpAndSettle();
      verify(() => mockObserver.didPush(any(), any())).called(greaterThan(0));

      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(CrestImage).last);
      await tester.pumpAndSettle();

      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();

      await tester.drag(find.byType(MatchView), const Offset(0, -500));
      await tester.pumpAndSettle();
      await tester.tap(find.text('BACK'));
      await tester.pumpAndSettle();
    });

    testWidgets('shows standings for multiple groups', (tester) async {
      final mockMatch = MockMatch();
      final homeTeam = MockTeam();
      final awayTeam = MockTeam();
      final score = MockScore();
      final area = MockArea();
      final league = MockLeague();
      final season = MockSeason();

      when(() => homeTeam.id).thenReturn(10);
      when(() => homeTeam.name).thenReturn('Home Team FC');
      when(() => homeTeam.crest).thenReturn('home.png');
      when(() => awayTeam.id).thenReturn(20);
      when(() => awayTeam.name).thenReturn('Away Team FC');
      when(() => awayTeam.crest).thenReturn('away.png');

      final halfTime = MockTime();
      final fullTime = MockTime();
      when(() => halfTime.home).thenReturn(1);
      when(() => halfTime.away).thenReturn(0);
      when(() => fullTime.home).thenReturn(2);
      when(() => fullTime.away).thenReturn(1);
      when(() => score.halfTime).thenReturn(halfTime);
      when(() => score.fullTime).thenReturn(fullTime);

      when(() => area.name).thenReturn('England');
      when(() => area.flag).thenReturn('england.png');
      when(() => league.id).thenReturn(123);
      when(() => league.name).thenReturn('Champions League');
      when(() => league.emblem).thenReturn('ucl.png');
      when(() => season.startDate).thenReturn(DateTime(2023, 8));
      when(() => season.endDate).thenReturn(DateTime(2024, 5, 30));

      when(() => mockMatch.homeTeam).thenReturn(homeTeam);
      when(() => mockMatch.awayTeam).thenReturn(awayTeam);
      when(() => mockMatch.score).thenReturn(score);
      when(() => mockMatch.area).thenReturn(area);
      when(() => mockMatch.competition).thenReturn(league);
      when(() => mockMatch.season).thenReturn(season);
      when(() => mockMatch.status).thenReturn('PAUSED');
      when(() => mockMatch.utcDate).thenReturn(DateTime.now());
      when(() => mockMatch.matchday).thenReturn(5);
      when(() => mockMatch.referees).thenReturn([]);

      when(() => mockDatabase.getMatchStream(matchId: 1))
          .thenAnswer((_) => Stream.value(mockMatch));
      when(
        () => mockDatabase.getConfigStream(id: AppVariables.matchesCollection),
      ).thenAnswer(
        (_) => Stream.value(Config(id: '', lastUpdate: DateTime.now())),
      );

      final multipleStandings = {
        AppVariables.standingsCollection: [
          {
            'stage': 'GROUP_STAGE',
            'type': 'TOTAL',
            'group': 'GROUP A',
            'table': [
              {
                'position': 1,
                'team': {
                  'id': 10,
                  'name': 'Home Team FC',
                  'tla': 'HOM',
                  'crest': '',
                },
                'playedGames': 3,
                'goalDifference': 2,
                'points': 7,
              }
            ],
          },
          {
            'stage': 'GROUP_STAGE',
            'type': 'TOTAL',
            'group': 'GROUP B',
            'table': [
              {
                'position': 1,
                'team': {
                  'id': 30,
                  'name': 'Other Team FC',
                  'tla': 'OTH',
                  'crest': '',
                },
                'playedGames': 3,
                'goalDifference': 4,
                'points': 9,
              }
            ],
          }
        ],
      };

      when(() => mockDatabase.getStandingsStream(leagueId: '123')).thenAnswer(
        (_) => Stream.value(
          LeagueStandings.fromJson({
            'leagueId': '123',
            'standings': multipleStandings[AppVariables.standingsCollection],
          }),
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: BlocProvider<MatchCubit>.value(
            value: matchCubit,
            child: const MatchView(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('GROUP A'), findsOneWidget);
      expect(find.text('GROUP B'), findsOneWidget);
    });

    testWidgets('shows no standings if data is misconfigured', (tester) async {
      final mockMatch = MockMatch();
      final homeTeam = MockTeam();
      final awayTeam = MockTeam();
      final score = MockScore();
      final area = MockArea();
      final league = MockLeague();
      final season = MockSeason();

      when(() => homeTeam.id).thenReturn(10);
      when(() => homeTeam.name).thenReturn('Home Team FC');
      when(() => homeTeam.crest).thenReturn('home.png');
      when(() => awayTeam.id).thenReturn(20);
      when(() => awayTeam.name).thenReturn('Away Team FC');
      when(() => awayTeam.crest).thenReturn('away.png');

      final halfTime = MockTime();
      final fullTime = MockTime();
      when(() => halfTime.home).thenReturn(1);
      when(() => halfTime.away).thenReturn(0);
      when(() => fullTime.home).thenReturn(2);
      when(() => fullTime.away).thenReturn(1);
      when(() => score.halfTime).thenReturn(halfTime);
      when(() => score.fullTime).thenReturn(fullTime);

      when(() => area.name).thenReturn('England');
      when(() => area.flag).thenReturn('england.png');
      when(() => league.id).thenReturn(123);
      when(() => league.name).thenReturn('Champions League');
      when(() => league.emblem).thenReturn('ucl.png');
      when(() => season.startDate).thenReturn(DateTime(2023, 8));
      when(() => season.endDate).thenReturn(DateTime(2024, 5, 30));

      when(() => mockMatch.homeTeam).thenReturn(homeTeam);
      when(() => mockMatch.awayTeam).thenReturn(awayTeam);
      when(() => mockMatch.score).thenReturn(score);
      when(() => mockMatch.area).thenReturn(area);
      when(() => mockMatch.competition).thenReturn(league);
      when(() => mockMatch.season).thenReturn(season);
      when(() => mockMatch.status).thenReturn('PAUSED');
      when(() => mockMatch.utcDate).thenReturn(DateTime.now());
      when(() => mockMatch.matchday).thenReturn(5);
      when(() => mockMatch.referees).thenReturn([]);

      when(() => mockDatabase.getMatchStream(matchId: 1))
          .thenAnswer((_) => Stream.value(mockMatch));
      when(
        () => mockDatabase.getConfigStream(id: AppVariables.matchesCollection),
      ).thenAnswer(
        (_) => Stream.value(Config(id: '', lastUpdate: DateTime.now())),
      );

      final invalidStandings = {'invalid_key': <dynamic>[]};

      when(() => mockDatabase.getStandingsStream(leagueId: '123')).thenAnswer(
        (_) => Stream.value(LeagueStandings.fromJson(invalidStandings)),
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: BlocProvider<MatchCubit>.value(
            value: matchCubit,
            child: const MatchView(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('GROUP A'), findsNothing);
    });
  });
}
