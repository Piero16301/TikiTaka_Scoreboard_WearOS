import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';
import 'package:tiki_taka_scoreboard_wearos/l10n/l10n.dart';
import 'package:tiki_taka_scoreboard_wearos/leagues/leagues.dart';
import 'package:user_api/user_api.dart';
import 'package:wearable_rotary/wearable_rotary.dart';

import '../../helpers/helpers.dart';

class MockLeaguesCubit extends Mock implements LeaguesCubit {}

void main() {
  late MockLeaguesCubit mockLeaguesCubit;
  late StreamController<RotaryEvent> rotaryController;
  late StreamController<QuerySnapshot<Map<String, dynamic>>>
  leaguesStreamController;

  setUp(() {
    mockLeaguesCubit = MockLeaguesCubit();
    rotaryController = StreamController<RotaryEvent>();
    leaguesStreamController =
        StreamController<QuerySnapshot<Map<String, dynamic>>>();

    when(() => mockLeaguesCubit.state).thenReturn(const LeaguesState());
    when(
      () => mockLeaguesCubit.stream,
    ).thenAnswer((_) => const Stream<LeaguesState>.empty());
    when(
      () => mockLeaguesCubit.getLeagues(),
    ).thenAnswer((_) => leaguesStreamController.stream);
  });

  tearDown(() {
    unawaited(rotaryController.close());
    unawaited(leaguesStreamController.close());
  });

  group('ShimmerCardLeagues', () {
    testWidgets('renders correctly', (tester) async {
      await tester.pumpApp(const ShimmerCardLeagues());

      expect(find.byType(ShimmerCardLeagues), findsOneWidget);
      expect(find.byType(AppCardData), findsOneWidget);
      expect(find.byType(Switch), findsOneWidget);
      expect(find.byType(AppSchimmer), findsNWidgets(2));
    });

    testWidgets('displays switch in disabled state', (tester) async {
      await tester.pumpApp(const ShimmerCardLeagues());

      final switchWidget = tester.widget<Switch>(find.byType(Switch));
      expect(switchWidget.value, false);
      expect(switchWidget.onChanged, null);
    });

    testWidgets('has correct layout with sizing', (tester) async {
      await tester.pumpApp(const ShimmerCardLeagues());

      final sizedBoxes = tester.widgetList<SizedBox>(find.byType(SizedBox));
      expect(sizedBoxes.length, greaterThan(0));

      final switchSizedBox = sizedBoxes.firstWhere(
        (box) => box.width == 40,
        orElse: () => const SizedBox(),
      );
      expect(switchSizedBox.width, 40);
    });

    testWidgets('shimmer elements have correct dimensions', (tester) async {
      await tester.pumpApp(const ShimmerCardLeagues());

      final schimmers = tester.widgetList<AppSchimmer>(
        find.byType(AppSchimmer),
      );
      expect(schimmers.length, 2);

      final firstSchimmer = schimmers.first;
      expect(firstSchimmer.height, 40);
      expect(firstSchimmer.width, 40);
    });
  });

  group('LeagueCardCompetitions', () {
    late League testLeague;

    setUp(() {
      testLeague = League(
        id: 2021,
        area: const Area(
          id: 2072,
          name: 'England',
          code: 'ENG',
          flag: 'https://crests.football-data.org/770.svg',
        ),
        name: 'Premier League',
        code: 'PL',
        type: 'LEAGUE',
        emblem: 'https://crests.football-data.org/PL.png',
        plan: 'TIER_ONE',
        currentSeason: Season(
          id: 1564,
          startDate: DateTime.parse('2023-08-11'),
          endDate: DateTime.parse('2024-05-19'),
          currentMatchday: 1,
          winner: Team.empty,
        ),
        numberOfAvailableSeasons: 31,
        lastUpdated: DateTime.parse('2023-05-10T11:40:01Z'),
      );
    });

    testWidgets('renders correctly with league data', (tester) async {
      when(() => mockLeaguesCubit.state).thenReturn(
        const LeaguesState(enabledLeagues: {'PL': true}),
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: BlocProvider<LeaguesCubit>.value(
            value: mockLeaguesCubit,
            child: Scaffold(
              body: LeagueCardCompetitions(league: testLeague),
            ),
          ),
        ),
      );

      expect(find.byType(LeagueCardCompetitions), findsOneWidget);
      expect(find.byType(AppCardData), findsOneWidget);
      expect(find.byType(Switch), findsOneWidget);
      expect(find.byType(CrestImage), findsOneWidget);
      expect(find.byType(ScrollText), findsOneWidget);
    });

    testWidgets('displays league name', (tester) async {
      when(() => mockLeaguesCubit.state).thenReturn(
        const LeaguesState(enabledLeagues: {'PL': false}),
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: BlocProvider<LeaguesCubit>.value(
            value: mockLeaguesCubit,
            child: Scaffold(
              body: LeagueCardCompetitions(league: testLeague),
            ),
          ),
        ),
      );

      expect(find.byType(ScrollText), findsOneWidget);
    });

    testWidgets('switch reflects enabled state', (tester) async {
      when(() => mockLeaguesCubit.state).thenReturn(
        const LeaguesState(enabledLeagues: {'PL': true}),
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: BlocProvider<LeaguesCubit>.value(
            value: mockLeaguesCubit,
            child: Scaffold(
              body: LeagueCardCompetitions(league: testLeague),
            ),
          ),
        ),
      );

      final switchWidget = tester.widget<Switch>(find.byType(Switch));
      expect(switchWidget.value, true);
    });

    testWidgets('switch reflects disabled state', (tester) async {
      when(() => mockLeaguesCubit.state).thenReturn(
        const LeaguesState(enabledLeagues: {'PL': false}),
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: BlocProvider<LeaguesCubit>.value(
            value: mockLeaguesCubit,
            child: Scaffold(
              body: LeagueCardCompetitions(league: testLeague),
            ),
          ),
        ),
      );

      final switchWidget = tester.widget<Switch>(find.byType(Switch));
      expect(switchWidget.value, false);
    });

    testWidgets('calls toggleLeague when switch is toggled', (tester) async {
      when(() => mockLeaguesCubit.state).thenReturn(
        const LeaguesState(enabledLeagues: {'PL': false}),
      );
      when(
        () => mockLeaguesCubit.toggleLeague(
          league: any(named: 'league'),
          enabled: any(named: 'enabled'),
        ),
      ).thenAnswer((_) async {});

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: BlocProvider<LeaguesCubit>.value(
            value: mockLeaguesCubit,
            child: Scaffold(
              body: LeagueCardCompetitions(league: testLeague),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      verify(
        () => mockLeaguesCubit.toggleLeague(
          league: 'PL',
          enabled: true,
        ),
      ).called(1);
    });

    testWidgets('displays crest image', (tester) async {
      when(() => mockLeaguesCubit.state).thenReturn(
        const LeaguesState(enabledLeagues: {'PL': true}),
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: BlocProvider<LeaguesCubit>.value(
            value: mockLeaguesCubit,
            child: Scaffold(
              body: LeagueCardCompetitions(league: testLeague),
            ),
          ),
        ),
      );

      expect(find.byType(CrestImage), findsOneWidget);
    });

    testWidgets('has correct layout structure', (tester) async {
      when(() => mockLeaguesCubit.state).thenReturn(
        const LeaguesState(enabledLeagues: {'PL': false}),
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: BlocProvider<LeaguesCubit>.value(
            value: mockLeaguesCubit,
            child: Scaffold(
              body: LeagueCardCompetitions(league: testLeague),
            ),
          ),
        ),
      );

      expect(find.byType(Row), findsWidgets);
      expect(find.byType(SizedBox), findsWidgets);
      expect(find.byType(Expanded), findsOneWidget);
    });
  });

  group('BackButtonCompetitions', () {
    testWidgets('renders correctly', (tester) async {
      await tester.pumpApp(const BackButtonCompetitions());

      expect(find.byType(BackButtonCompetitions), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.byType(Padding), findsWidgets);
    });

    testWidgets('displays text in uppercase', (tester) async {
      await tester.pumpApp(const BackButtonCompetitions());

      expect(find.byType(Text), findsOneWidget);
    });

    testWidgets('calls Navigator.pop when pressed', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            appBar: AppBar(title: const Text('Test')),
            body: Builder(
              builder: (context) => Center(
                child: ElevatedButton(
                  onPressed: () {
                    unawaited(
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const Scaffold(
                            body: BackButtonCompetitions(),
                          ),
                        ),
                      ),
                    );
                  },
                  child: const Text('Go'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Go'));
      await tester.pumpAndSettle();

      expect(find.byType(BackButtonCompetitions), findsOneWidget);

      await tester.tap(find.byType(ElevatedButton).last);
      await tester.pumpAndSettle();

      expect(find.text('Go'), findsOneWidget);
      expect(find.byType(BackButtonCompetitions), findsNothing);
    });

    testWidgets('has correct padding', (tester) async {
      await tester.pumpApp(const BackButtonCompetitions());

      final padding = tester.widget<Padding>(
        find.ancestor(
          of: find.byType(ElevatedButton),
          matching: find.byType(Padding),
        ),
      );

      expect(
        padding.padding,
        const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      );
    });

    testWidgets('button has correct layout', (tester) async {
      await tester.pumpApp(const BackButtonCompetitions());

      expect(find.byType(Row), findsWidgets);
      final row = tester.widget<Row>(
        find.descendant(
          of: find.byType(ElevatedButton),
          matching: find.byType(Row),
        ),
      );

      expect(row.mainAxisAlignment, MainAxisAlignment.center);
    });

    testWidgets('text has correct styling', (tester) async {
      await tester.pumpApp(const BackButtonCompetitions());

      final text = tester.widget<Text>(find.byType(Text));
      expect(text.style?.fontWeight, FontWeight.bold);
      expect(text.style?.fontSize, 14);
    });
  });
}
