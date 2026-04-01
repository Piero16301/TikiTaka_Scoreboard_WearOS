import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';
import 'package:tiki_taka_scoreboard_wearos/l10n/l10n.dart';
import 'package:tiki_taka_scoreboard_wearos/leagues/leagues.dart';

class MockLeaguesCubit extends MockCubit<LeaguesState>
    implements LeaguesCubit {}

class MockDatabaseService extends Mock implements DatabaseService {}

class MockLocalStorageService extends Mock implements LocalStorageService {}

class MockLeague extends Mock implements League {}

class MockAnalyticsService extends Mock implements AnalyticsService {}

void main() {
  group('LeaguesPage and LeaguesView', () {
    late MockLeaguesCubit leaguesCubit;
    late MockDatabaseService mockDatabase;
    late MockLocalStorageService mockLocalStorage;
    late MockAnalyticsService mockAnalytics;

    setUpAll(() async {
      mockDatabase = MockDatabaseService();
      mockLocalStorage = MockLocalStorageService();
      mockAnalytics = MockAnalyticsService();

      if (getIt.isRegistered<DatabaseService>()) {
        await getIt.unregister<DatabaseService>();
      }
      getIt.registerSingleton<DatabaseService>(mockDatabase);

      if (getIt.isRegistered<LocalStorageService>()) {
        await getIt.unregister<LocalStorageService>();
      }
      getIt.registerSingleton<LocalStorageService>(mockLocalStorage);

      if (getIt.isRegistered<AnalyticsService>()) {
        await getIt.unregister<AnalyticsService>();
      }
      getIt.registerSingleton<AnalyticsService>(mockAnalytics);
    });

    setUp(() {
      leaguesCubit = MockLeaguesCubit();
      when(() => leaguesCubit.state).thenReturn(const LeaguesState());
      when(() => leaguesCubit.initialize()).thenAnswer((_) async {});
      when(() => mockLocalStorage.getEnabledLeagues()).thenReturn([]);
      when(
        () => mockAnalytics.logEvent(
          name: any(named: 'name'),
          parameters: any(named: 'parameters'),
        ),
      ).thenAnswer((_) async {});
    });

    testWidgets('renders LeaguesPage properly and shows shimmers when loading',
        (tester) async {
      when(() => mockDatabase.getLeaguesStream())
          .thenAnswer((_) => const Stream.empty());

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: BlocProvider<LeaguesCubit>.value(
            value: leaguesCubit,
            child: const LeaguesPage(),
          ),
        ),
      );

      expect(find.byType(LeaguesPage), findsOneWidget);
      expect(find.byType(LeaguesView), findsOneWidget);
    });

    testWidgets('shows error state when stream emits error', (tester) async {
      when(() => mockDatabase.getLeaguesStream())
          .thenAnswer((_) => Stream.error('Error'));

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: BlocProvider<LeaguesCubit>.value(
            value: leaguesCubit,
            child: const LeaguesView(),
          ),
        ),
      );

      await tester.pump();

      expect(find.text('Error loading leagues'), findsOneWidget);
    });

    testWidgets('shows empty state when stream emits empty list',
        (tester) async {
      when(() => mockDatabase.getLeaguesStream())
          .thenAnswer((_) => Stream.value([]));

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: BlocProvider<LeaguesCubit>.value(
            value: leaguesCubit,
            child: const LeaguesView(),
          ),
        ),
      );

      await tester.pump();

      expect(find.text('No leagues available'), findsOneWidget);
    });

    testWidgets('shows list of leagues when stream emits data', (tester) async {
      final mockLeague = MockLeague();
      when(() => mockLeague.code).thenReturn('PL');
      when(() => mockLeague.emblem).thenReturn('emblem.png');
      when(() => mockLeague.name).thenReturn('Premier League');

      final mockLeagues = <League>[mockLeague];
      when(() => mockDatabase.getLeaguesStream())
          .thenAnswer((_) => Stream.value(mockLeagues));

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: BlocProvider<LeaguesCubit>.value(
            value: leaguesCubit,
            child: const LeaguesView(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Premier League'), findsOneWidget);
      expect(find.byType(LeagueCardCompetitions), findsOneWidget);
    });

    testWidgets('toggles league when switch is pressed', (tester) async {
      final mockLeague = MockLeague();
      when(() => mockLeague.code).thenReturn('PL');
      when(() => mockLeague.emblem).thenReturn('emblem.png');
      when(() => mockLeague.name).thenReturn('Premier League');

      final mockLeagues = <League>[mockLeague];
      when(() => mockDatabase.getLeaguesStream())
          .thenAnswer((_) => Stream.value(mockLeagues));

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: BlocProvider<LeaguesCubit>.value(
            value: leaguesCubit,
            child: const LeaguesView(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final switchFinder = find.byType(Switch);
      expect(switchFinder, findsOneWidget);

      await tester.tap(switchFinder);
      await tester.pumpAndSettle();

      verify(() => leaguesCubit.toggleLeague(league: 'PL', enabled: true))
          .called(1);
    });
  });
}
