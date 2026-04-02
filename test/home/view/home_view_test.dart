import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_performance/firebase_performance.dart';
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

class MockPerformanceService extends Mock implements PerformanceService {}

class MockTrace extends Mock implements Trace {}

class MockAnalyticsService extends Mock implements AnalyticsService {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class FakeRoute extends Fake implements Route<dynamic> {}

class MockMatch extends Mock implements Match {}

class MockTeam extends Mock implements Team {}

class MockScore extends Mock implements Score {}

class MockTime extends Mock implements Time {}

class MockLeague extends Mock implements League {}

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
        ..registerSingleton<DeviceInfoService>(MockDeviceInfoService())
        ..registerSingleton<PerformanceService>(MockPerformanceService())
        ..registerSingleton<AnalyticsService>(MockAnalyticsService());
    });

    setUp(() {
      homeCubit = MockHomeCubit();
      database = getIt<DatabaseService>() as MockDatabaseService;
      localStorage = getIt<LocalStorageService>() as MockLocalStorageService;

      when(() => homeCubit.state).thenReturn(const HomeState());
      when(() => localStorage.getEnabledLeagues()).thenReturn([]);

      final mockTrace = MockTrace();
      when(mockTrace.start).thenAnswer((_) async {});
      when(mockTrace.stop).thenAnswer((_) async {});
      when(() => getIt<PerformanceService>().startTrace(any()))
          .thenReturn(mockTrace);
      when(() => database.getConfigStream(id: any(named: 'id'))).thenAnswer(
        (_) => Stream.value(Config(id: '', lastUpdate: DateTime.now())),
      );
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
        () => database.getMatchesStream(
          enabledLeagues: any(named: 'enabledLeagues'),
        ),
      ).thenAnswer((_) => Stream.error(Exception('error')));

      await tester.pumpWidget(buildSubject());
      await tester.pump();

      expect(find.text('Error loading matches'), findsOneWidget);
    });

    testWidgets('renders shimmers when loading (no data yet)', (tester) async {
      final controller = StreamController<List<Match>>();
      when(
        () => database.getMatchesStream(
          enabledLeagues: any(named: 'enabledLeagues'),
        ),
      ).thenAnswer((_) => controller.stream);

      await tester.pumpWidget(buildSubject());

      expect(find.byType(ShimmerMatchCardHome), findsWidgets);
      expect(find.text('Updating matches...'), findsOneWidget);

      await controller.close();
    });

    testWidgets('renders empty matches text when data is empty',
        (tester) async {
      when(
        () => database.getMatchesStream(
          enabledLeagues: any(named: 'enabledLeagues'),
        ),
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

      final league = MockLeague();
      when(() => league.name).thenReturn('Premier League');

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
        when(() => m.competition).thenReturn(league);
        when(() => m.score).thenReturn(score);
        when(() => m.utcDate).thenReturn(DateTime.now());
      }

      setupMatch(match1, 'SCHEDULED', 1);
      setupMatch(match2, 'IN_PLAY', 2);
      setupMatch(match3, 'FINISHED', 3);

      when(
        () => database.getMatchesStream(
          enabledLeagues: any(named: 'enabledLeagues'),
        ),
      ).thenAnswer((_) => Stream.value([match1, match2, match3]));

      final observer = MockNavigatorObserver();

      await tester.pumpWidget(buildSubject(observer: observer));
      await tester.pump(const Duration(seconds: 1));

      expect(find.byType(MatchCardHome), findsNWidgets(3));

      await tester.drag(find.byType(HomeView), const Offset(0, -500));
      await tester.pump(const Duration(seconds: 1));
      await tester.tap(find.byType(SettingsHome));
      await tester.pump(const Duration(seconds: 1));
      verify(() => observer.didPush(any(), any())).called(greaterThan(0));

      Navigator.of(tester.element(find.byType(HomeView))).pop();
      await tester.pump(const Duration(seconds: 1));

      await tester.tap(find.byType(MatchCardHome).first);
      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('renders LastUpdateHome with configs', (tester) async {
      final mockMatch = MockMatch();
      final homeTeam = MockTeam();
      when(() => homeTeam.crest).thenReturn('');
      when(() => homeTeam.tla).thenReturn('HOM');
      final awayTeam = MockTeam();
      when(() => awayTeam.crest).thenReturn('');
      when(() => awayTeam.tla).thenReturn('AWA');
      final league = MockLeague();
      when(() => league.name).thenReturn('Premier League');
      final time = MockTime();
      when(() => time.home).thenReturn(1);
      when(() => time.away).thenReturn(0);
      final score = MockScore();
      when(() => score.fullTime).thenReturn(time);

      when(() => mockMatch.id).thenReturn(1);
      when(() => mockMatch.status).thenReturn('IN_PLAY');
      when(() => mockMatch.homeTeam).thenReturn(homeTeam);
      when(() => mockMatch.awayTeam).thenReturn(awayTeam);
      when(() => mockMatch.competition).thenReturn(league);
      when(() => mockMatch.score).thenReturn(score);
      when(() => mockMatch.utcDate).thenReturn(DateTime.now());

      when(
        () => database.getMatchesStream(
          enabledLeagues: any(named: 'enabledLeagues'),
        ),
      ).thenAnswer((_) => Stream.value([mockMatch]));

      final config = Config(
        id: 'matches',
        lastUpdate: DateTime.now().subtract(const Duration(seconds: 5)),
      );
      when(() => database.getConfigStream(id: AppVariables.matchesCollection))
          .thenAnswer((_) => Stream.value(config));

      await tester.pumpWidget(buildSubject());
      await tester.pump(const Duration(seconds: 1));

      expect(find.byType(LastUpdateHome), findsWidgets);
    });
  });
}
