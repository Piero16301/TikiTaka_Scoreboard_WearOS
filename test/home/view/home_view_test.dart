import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';
import 'package:tiki_taka_scoreboard_wearos/home/home.dart';
import 'package:tiki_taka_scoreboard_wearos/l10n/l10n.dart';
import 'package:tiki_taka_scoreboard_wearos/match/match.dart';
import 'package:tiki_taka_scoreboard_wearos/settings/settings.dart';

class MockHomeCubit extends MockCubit<HomeState> implements HomeCubit {}

class MockLocalStorageService extends Mock implements LocalStorageService {}

class MockDatabaseService extends Mock implements DatabaseService {}

class MockNotificationService extends Mock implements NotificationService {}

class MockDeviceInfoService extends Mock implements DeviceInfoService {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class FakeRoute extends Fake implements Route<dynamic> {}

class MockMatch extends Mock implements Match {}

class MockTeam extends Mock implements Team {}

class MockScore extends Mock implements Score {}

class MockTime extends Mock implements Time {}

class MockCompetition extends Mock implements Competition {}

void main() {
  group('HomeView', () {
    late MockHomeCubit homeCubit;
    late MockDatabaseService database;
    late MockLocalStorageService localStorage;

    setUpAll(() {
      registerFallbackValue(FakeRoute());
      getIt
        ..registerSingleton<LocalStorageService>(MockLocalStorageService())
        ..registerSingleton<DatabaseService>(MockDatabaseService())
        ..registerSingleton<NotificationService>(MockNotificationService())
        ..registerSingleton<DeviceInfoService>(MockDeviceInfoService());
    });

    setUp(() {
      homeCubit = MockHomeCubit();
      database = getIt<DatabaseService>() as MockDatabaseService;
      localStorage = getIt<LocalStorageService>() as MockLocalStorageService;

      when(() => homeCubit.state).thenReturn(const HomeState());
      when(() => localStorage.getEnabledLeagues()).thenReturn([]);
      when(() => database.getConfigs(id: any(named: 'id')))
          .thenAnswer((_) => Stream.value([]));
    });

    Widget buildSubject({NavigatorObserver? observer}) {
      return MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        navigatorObservers: observer != null ? [observer] : [],
        routes: {
          SettingsPage.routeName: (_) =>
              Scaffold(appBar: AppBar(), body: const Text('SettingsPage')),
          MatchPage.routeName: (_) =>
              Scaffold(appBar: AppBar(), body: const Text('MatchPage')),
        },
        home: BlocProvider<HomeCubit>.value(
          value: homeCubit,
          child: const HomeView(),
        ),
      );
    }

    testWidgets('renders error text when stream has error', (tester) async {
      when(
        () => database.getMatches(enabledLeagues: any(named: 'enabledLeagues')),
      ).thenAnswer((_) => Stream.error(Exception('error')));

      await tester.pumpWidget(buildSubject());
      await tester.pump();

      expect(find.text('Error loading matches'), findsOneWidget);
    });

    testWidgets('renders shimmers when loading (no data yet)', (tester) async {
      final controller = StreamController<List<Match>>();
      when(
        () => database.getMatches(enabledLeagues: any(named: 'enabledLeagues')),
      ).thenAnswer((_) => controller.stream);

      await tester.pumpWidget(buildSubject());

      // Should show shimmers initially
      expect(find.byType(ShimmerMatchCardHome), findsWidgets);
      expect(find.text('Updating matches...'), findsOneWidget);

      await controller.close();
    });

    testWidgets('renders empty matches text when data is empty',
        (tester) async {
      when(
        () => database.getMatches(enabledLeagues: any(named: 'enabledLeagues')),
      ).thenAnswer((_) => Stream.value([]));

      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(find.text('No matches for today'), findsOneWidget);
    });

    testWidgets(
        'renders matches with different statuses and navigates to settings/match',
        (tester) async {
      final match1 = MockMatch();
      final match2 = MockMatch();
      final match3 = MockMatch();

      final homeTeam = MockTeam();
      when(() => homeTeam.crest).thenReturn('');
      when(() => homeTeam.tla).thenReturn('HOM');

      final awayTeam = MockTeam();
      when(() => awayTeam.crest).thenReturn('');
      when(() => awayTeam.tla).thenReturn('AWA');

      final competition = MockCompetition();
      when(() => competition.name).thenReturn('Premier League');

      final time = MockTime();
      when(() => time.home).thenReturn(1);
      when(() => time.away).thenReturn(0);
      final score = MockScore();
      when(() => score.fullTime).thenReturn(time);

      void setupMatch(MockMatch m, String status, int matchId) {
        when(() => m.id).thenReturn(matchId);
        when(() => m.status).thenReturn(status);
        when(() => m.homeTeam).thenReturn(homeTeam);
        when(() => m.awayTeam).thenReturn(awayTeam);
        when(() => m.competition).thenReturn(competition);
        when(() => m.score).thenReturn(score);
        when(() => m.utcDate).thenReturn(DateTime.now());
      }

      setupMatch(match1, 'SCHEDULED', 1);
      setupMatch(match2, 'IN_PLAY', 2);
      setupMatch(match3, 'FINISHED', 3);

      when(
        () => database.getMatches(enabledLeagues: any(named: 'enabledLeagues')),
      ).thenAnswer((_) => Stream.value([match1, match2, match3]));

      final observer = MockNavigatorObserver();

      await tester.pumpWidget(buildSubject(observer: observer));
      await tester.pump(const Duration(seconds: 1));

      // IN_PLAY, SCHEDULED, FINISHED matches order
      expect(find.byType(MatchCardHome), findsNWidgets(3));

      // Test tapping settings
      await tester.tap(find.text('SETTINGS'));
      await tester.pump(const Duration(seconds: 1));
      verify(() => observer.didPush(any(), any())).called(greaterThan(0));

      // The settings tap pushed a new route. We pop it.
      Navigator.of(tester.element(find.byType(HomeView))).pop();
      await tester.pump(const Duration(seconds: 1));

      await tester.tap(find.byType(MatchCardHome).first);
      await tester.pump(const Duration(seconds: 1));

      // Match card pushed a new route, test is complete
    });

    testWidgets('renders LastUpdateHome with configs', (tester) async {
      final mockMatch = MockMatch();
      final homeTeam = MockTeam();
      when(() => homeTeam.crest).thenReturn('');
      when(() => homeTeam.tla).thenReturn('HOM');
      final awayTeam = MockTeam();
      when(() => awayTeam.crest).thenReturn('');
      when(() => awayTeam.tla).thenReturn('AWA');
      final competition = MockCompetition();
      when(() => competition.name).thenReturn('Premier League');
      final time = MockTime();
      when(() => time.home).thenReturn(1);
      when(() => time.away).thenReturn(0);
      final score = MockScore();
      when(() => score.fullTime).thenReturn(time);

      when(() => mockMatch.id).thenReturn(1);
      when(() => mockMatch.status).thenReturn('IN_PLAY');
      when(() => mockMatch.homeTeam).thenReturn(homeTeam);
      when(() => mockMatch.awayTeam).thenReturn(awayTeam);
      when(() => mockMatch.competition).thenReturn(competition);
      when(() => mockMatch.score).thenReturn(score);
      when(() => mockMatch.utcDate).thenReturn(DateTime.now());

      when(
        () => database.getMatches(enabledLeagues: any(named: 'enabledLeagues')),
      ).thenAnswer((_) => Stream.value([mockMatch]));

      final config = Config(
        id: 'matches',
        lastUpdate: DateTime.now().subtract(const Duration(seconds: 5)),
      );
      when(() => database.getConfigs(id: AppVariables.matchesCollection))
          .thenAnswer((_) => Stream.value([config]));

      await tester.pumpWidget(buildSubject());
      await tester.pump(const Duration(seconds: 1));

      expect(find.byType(LastUpdateHome), findsWidgets);
    });
  });
}
