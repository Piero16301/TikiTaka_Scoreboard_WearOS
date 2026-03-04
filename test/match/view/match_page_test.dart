import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';
import 'package:tiki_taka_scoreboard_wearos/l10n/l10n.dart';
import 'package:tiki_taka_scoreboard_wearos/match/match.dart';

class MockMatchCubit extends MockCubit<MatchState> implements MatchCubit {}

class MockDatabaseService extends Mock implements DatabaseService {}

class MockMatch extends Mock implements Match {}

class MockTeam extends Mock implements Team {}

class MockScore extends Mock implements Score {}

class MockTime extends Mock implements Time {}

class MockArea extends Mock implements Area {}

class MockCompetition extends Mock implements Competition {}

class MockSeason extends Mock implements Season {}

class FakeRoute extends Fake implements Route<dynamic> {}

void main() {
  group('MatchPage and MatchView', () {
    late MockMatchCubit matchCubit;
    late MockDatabaseService mockDatabase;

    setUpAll(() async {
      mockDatabase = MockDatabaseService();

      if (getIt.isRegistered<DatabaseService>()) {
        await getIt.unregister<DatabaseService>();
      }
      getIt.registerSingleton<DatabaseService>(mockDatabase);

      registerFallbackValue(FakeRoute());
    });

    setUp(() {
      matchCubit = MockMatchCubit();

      when(() => matchCubit.state).thenReturn(const MatchState(matchId: 1));
      when(() => matchCubit.initialize(matchId: 1)).thenAnswer((_) async {});
    });

    testWidgets('renders MatchPage properly and shows shimmers when loading',
        (tester) async {
      when(() => mockDatabase.getMatch(matchId: 1))
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
      when(() => mockDatabase.getMatch(matchId: 1))
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

    testWidgets('shows not found state when stream emits empty list',
        (tester) async {
      when(() => mockDatabase.getMatch(matchId: 1))
          .thenAnswer((_) => Stream.value([]));

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

      expect(find.text('Match not found'), findsOneWidget);
    });

    testWidgets('shows match details when stream emits data', (tester) async {
      final mockMatch = MockMatch();
      final homeTeam = MockTeam();
      final awayTeam = MockTeam();
      final score = MockScore();
      final halfTime = MockTime();
      final fullTime = MockTime();
      final area = MockArea();
      final competition = MockCompetition();
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

      when(() => competition.id).thenReturn(123);
      when(() => competition.name).thenReturn('Premier League');
      when(() => competition.emblem).thenReturn('pl.png');

      when(() => season.startDate).thenReturn(DateTime(2023, 8));
      when(() => season.endDate).thenReturn(DateTime(2024, 5, 30));

      when(() => mockMatch.homeTeam).thenReturn(homeTeam);
      when(() => mockMatch.awayTeam).thenReturn(awayTeam);
      when(() => mockMatch.score).thenReturn(score);
      when(() => mockMatch.area).thenReturn(area);
      when(() => mockMatch.competition).thenReturn(competition);
      when(() => mockMatch.season).thenReturn(season);
      when(() => mockMatch.status).thenReturn('FINISHED');
      when(() => mockMatch.utcDate).thenReturn(DateTime.now());
      when(() => mockMatch.matchday).thenReturn(5);
      when(() => mockMatch.referees).thenReturn([]);

      when(() => mockDatabase.getMatch(matchId: 1))
          .thenAnswer((_) => Stream.value([mockMatch]));
      when(() => mockDatabase.getConfigs(id: AppVariables.matchesCollection))
          .thenAnswer((_) => Stream.value([]));
      when(() => mockDatabase.getStandings(leagueId: '123'))
          .thenAnswer((_) => Stream.value([]));

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
    });
  });
}
