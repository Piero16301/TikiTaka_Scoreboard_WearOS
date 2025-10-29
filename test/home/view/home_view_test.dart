import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';
import 'package:tiki_taka_scoreboard_wearos/home/home.dart';
import 'package:tiki_taka_scoreboard_wearos/l10n/l10n.dart';
import 'package:tiki_taka_scoreboard_wearos/settings/settings.dart';
import 'package:user_api/user_api.dart';
import 'package:wearable_rotary/wearable_rotary.dart';

import 'home_view_test.mocks.dart';

@GenerateMocks([HomeCubit, SharedPreferences])
void main() {
  late MockHomeCubit mockHomeCubit;
  late MockSharedPreferences mockPreferences;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();

    mockHomeCubit = MockHomeCubit();
    mockPreferences = MockSharedPreferences();

    when(mockPreferences.getString(any)).thenReturn('mock_value');
    when(mockPreferences.getBool(any)).thenReturn(true);
    when(mockPreferences.getStringList(any)).thenReturn(['PL', 'PD']);

    when(mockHomeCubit.state).thenReturn(const HomeState());
    when(mockHomeCubit.stream).thenAnswer((_) => const Stream.empty());
    when(mockHomeCubit.reload(value: anyNamed('value'))).thenReturn(null);

    final fakeFirestore = FakeFirebaseFirestore();

    when(mockHomeCubit.getMatches()).thenAnswer(
      (_) =>
          fakeFirestore.collection(AppVariables.matchesCollection).snapshots(),
    );
    when(mockHomeCubit.getMatchConfigs()).thenAnswer(
      (_) async* {
        yield await fakeFirestore
            .collection(AppVariables.configsCollection)
            .doc(AppVariables.matchesCollection)
            .set({
              'id': AppVariables.matchesCollection,
              'lastUpdate': Timestamp.fromDate(DateTime.now()),
            })
            .then(
              (_) => fakeFirestore
                  .collection(AppVariables.configsCollection)
                  .get(),
            );
      },
    );
  });

  group('HomeView', () {
    testWidgets('renders correctly with empty matches', (tester) async {
      final fakeFirestore = FakeFirebaseFirestore();
      when(mockHomeCubit.getMatches()).thenAnswer(
        (_) => fakeFirestore
            .collection(AppVariables.matchesCollection)
            .snapshots(),
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: BlocProvider<HomeCubit>.value(
            value: mockHomeCubit,
            child: HomeView(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(HomeView), findsOneWidget);
      expect(find.byType(SettingsHome), findsOneWidget);

      await tester.pump(const Duration(seconds: 3));
      await tester.pump();
    });

    testWidgets('renders loading state', (tester) async {
      final fakeFirestore = FakeFirebaseFirestore();
      when(mockHomeCubit.getMatches()).thenAnswer(
        (_) => fakeFirestore
            .collection(AppVariables.matchesCollection)
            .snapshots(),
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: BlocProvider<HomeCubit>.value(
            value: mockHomeCubit,
            child: HomeView(),
          ),
        ),
      );

      expect(find.byType(ShimmerMatchCardHome), findsWidgets);
      expect(find.byType(LastUpdateHome), findsOneWidget);

      await tester.pumpAndSettle();

      await tester.pump(const Duration(seconds: 3));
      await tester.pump();
    });

    testWidgets('renders error state', (tester) async {
      when(mockHomeCubit.getMatches()).thenAnswer(
        (_) => Stream<QuerySnapshot<Map<String, dynamic>>>.error(
          Exception('Test error'),
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: BlocProvider<HomeCubit>.value(
            value: mockHomeCubit,
            child: HomeView(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(HomeView), findsOneWidget);
      expect(find.byType(ScrollText), findsWidgets);
    });

    testWidgets('renders matches list', (tester) async {
      final mockMatches = [
        _createMockMatch(1, 'IN_PLAY'),
        _createMockMatch(2, 'SCHEDULED'),
      ];

      final fakeFirestore = FakeFirebaseFirestore();
      for (final match in mockMatches) {
        await fakeFirestore
            .collection(AppVariables.matchesCollection)
            .add(_matchToMap(match));
      }

      when(mockHomeCubit.getMatches()).thenAnswer(
        (_) => fakeFirestore
            .collection(AppVariables.matchesCollection)
            .snapshots(),
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: BlocProvider<HomeCubit>.value(
            value: mockHomeCubit,
            child: HomeView(),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 500));

      expect(find.byType(MatchCardHome), findsNWidgets(2));

      await tester.pump(const Duration(seconds: 3));
      await tester.pump();
    });

    testWidgets('sorts matches correctly', (tester) async {
      final mockMatches = [
        _createMockMatch(1, 'SCHEDULED'),
        _createMockMatch(2, 'IN_PLAY'),
        _createMockMatch(3, 'PAUSED'),
        _createMockMatch(4, 'TIMED'),
      ];

      final fakeFirestore = FakeFirebaseFirestore();
      for (final match in mockMatches) {
        await fakeFirestore
            .collection(AppVariables.matchesCollection)
            .add(_matchToMap(match));
      }

      when(mockHomeCubit.getMatches()).thenAnswer(
        (_) => fakeFirestore
            .collection(AppVariables.matchesCollection)
            .snapshots(),
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: BlocProvider<HomeCubit>.value(
            value: mockHomeCubit,
            child: HomeView(),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 500));

      expect(find.byType(MatchCardHome), findsNWidgets(4));

      await tester.pump(const Duration(seconds: 3));
      await tester.pump();
    });

    testWidgets(
      'uses rotary events stream when provided',
      (tester) async {
        const rotaryStream = Stream<RotaryEvent>.empty();
        final fakeFirestore = FakeFirebaseFirestore();

        when(mockHomeCubit.getMatches()).thenAnswer(
          (_) => fakeFirestore
              .collection(AppVariables.matchesCollection)
              .snapshots(),
        );

        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: BlocProvider<HomeCubit>.value(
              value: mockHomeCubit,
              child: HomeView(rotaryEvents: rotaryStream),
            ),
          ),
        );

        await tester.pump();

        expect(find.byType(HomeView), findsOneWidget);

        await tester.pump(const Duration(seconds: 3));
        await tester.pump();
      },
      timeout: const Timeout(Duration(seconds: 10)),
    );

    testWidgets('reloads when state.reload is true', (tester) async {
      final fakeFirestore = FakeFirebaseFirestore();

      when(mockHomeCubit.state).thenReturn(const HomeState(reload: true));
      when(mockHomeCubit.getMatches()).thenAnswer(
        (_) => fakeFirestore
            .collection(AppVariables.matchesCollection)
            .snapshots(),
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: BlocProvider<HomeCubit>.value(
            value: mockHomeCubit,
            child: HomeView(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      verify(mockHomeCubit.reload(value: false)).called(greaterThan(0));

      await tester.pump(const Duration(seconds: 3));
      await tester.pump();
    });
  });

  group('LastUpdateHome', () {
    testWidgets('renders time since last update', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: BlocProvider<HomeCubit>.value(
            value: mockHomeCubit,
            child: const Scaffold(
              body: LastUpdateHome(),
            ),
          ),
        ),
      );

      await tester.pump();

      expect(find.byType(Text), findsWidgets);
      expect(find.byType(LastUpdateHome), findsOneWidget);
    });

    testWidgets('updates every second', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: BlocProvider<HomeCubit>.value(
            value: mockHomeCubit,
            child: const Scaffold(
              body: LastUpdateHome(),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.byType(LastUpdateHome), findsOneWidget);
    });

    testWidgets('handles empty configs list', (tester) async {
      final fakeFirestore = FakeFirebaseFirestore();

      when(mockHomeCubit.getMatchConfigs()).thenAnswer(
        (_) => fakeFirestore
            .collection(AppVariables.configsCollection)
            .snapshots(),
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: BlocProvider<HomeCubit>.value(
            value: mockHomeCubit,
            child: const Scaffold(
              body: LastUpdateHome(),
            ),
          ),
        ),
      );

      await tester.pump();

      expect(find.byType(Text), findsOneWidget);
    });

    testWidgets('disposes subscription on dispose', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: BlocProvider<HomeCubit>.value(
            value: mockHomeCubit,
            child: const Scaffold(
              body: LastUpdateHome(),
            ),
          ),
        ),
      );

      await tester.pump();

      await tester.pumpWidget(const SizedBox.shrink());

      expect(find.byType(LastUpdateHome), findsNothing);
    });
  });

  group('ShimmerMatchCardHome', () {
    testWidgets('renders correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShimmerMatchCardHome(),
          ),
        ),
      );

      expect(find.byType(ShimmerMatchCardHome), findsOneWidget);
      expect(find.byType(AppCardData), findsOneWidget);
      expect(find.byType(AppSchimmer), findsNWidgets(6));
    });

    testWidgets('has correct structure', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShimmerMatchCardHome(),
          ),
        ),
      );

      expect(find.byType(Column), findsWidgets);
      expect(find.byType(Row), findsWidgets);
      expect(find.byType(Expanded), findsWidgets);
    });

    testWidgets('can be instantiated', (tester) async {
      const widget = ShimmerMatchCardHome();
      expect(widget, isNotNull);
      expect(widget, isA<ShimmerMatchCardHome>());
    });
  });

  group('MatchCardHome', () {
    testWidgets('renders match information correctly', (tester) async {
      final match = _createMockMatch(1, 'SCHEDULED');

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: MatchCardHome(match: match),
          ),
        ),
      );

      await tester.pump();

      expect(find.byType(MatchCardHome), findsOneWidget);
      expect(find.text('Premier League'), findsOneWidget);
      expect(find.text('CHE'), findsOneWidget);
      expect(find.text('ARS'), findsOneWidget);
      expect(find.byType(CrestImage), findsNWidgets(2));
    });

    testWidgets('renders IN_PLAY match correctly', (tester) async {
      final match = _createMockMatch(1, 'IN_PLAY');

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: MatchCardHome(match: match),
          ),
        ),
      );

      await tester.pump();

      expect(find.text('2 - 1'), findsOneWidget);
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
    });

    testWidgets('renders PAUSED match correctly', (tester) async {
      final match = _createMockMatch(1, 'PAUSED');

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: MatchCardHome(match: match),
          ),
        ),
      );

      await tester.pump();

      expect(find.text('2 - 1'), findsOneWidget);
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
    });

    testWidgets('renders SCHEDULED match correctly', (tester) async {
      final match = _createMockMatch(1, 'SCHEDULED');

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: MatchCardHome(match: match),
          ),
        ),
      );

      await tester.pump();

      expect(find.byType(LinearProgressIndicator), findsNothing);
    });

    testWidgets('renders TIMED match correctly', (tester) async {
      final match = _createMockMatch(1, 'TIMED');

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: MatchCardHome(match: match),
          ),
        ),
      );

      await tester.pump();

      expect(find.byType(LinearProgressIndicator), findsNothing);
    });

    testWidgets('renders FINISHED match correctly', (tester) async {
      final match = _createMockMatch(1, 'FINISHED');

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: MatchCardHome(match: match),
          ),
        ),
      );

      await tester.pump();

      expect(find.text('2 - 1'), findsOneWidget);
      expect(find.byType(LinearProgressIndicator), findsNothing);
    });

    testWidgets('displays correct team names', (tester) async {
      final match = _createMockMatch(1, 'SCHEDULED');

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: MatchCardHome(match: match),
          ),
        ),
      );

      await tester.pump();

      expect(find.text('CHE'), findsOneWidget);
      expect(find.text('ARS'), findsOneWidget);
    });
  });

  group('SettingsHome', () {
    testWidgets('renders correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: SettingsHome(),
          ),
        ),
      );

      expect(find.byType(SettingsHome), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.byType(ScrollText), findsOneWidget);
    });

    testWidgets('navigates to SettingsPage on tap', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routes: {
            SettingsPage.routeName: (context) => const Scaffold(
              body: Center(child: Text('Settings Page')),
            ),
          },
          home: const Scaffold(
            body: SettingsHome(),
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.text('Settings Page'), findsOneWidget);
    });

    testWidgets('handles navigation result correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routes: {
            SettingsPage.routeName: (context) => Scaffold(
              body: ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Back'),
              ),
            ),
          },
          home: BlocProvider<HomeCubit>.value(
            value: mockHomeCubit,
            child: const Scaffold(
              body: SettingsHome(),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton).first);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Back'));
      await tester.pumpAndSettle();

      verify(mockHomeCubit.reload()).called(greaterThan(0));
    });

    testWidgets('button has correct layout', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: SettingsHome(),
          ),
        ),
      );

      expect(find.byType(Row), findsWidgets);
      expect(find.byType(Padding), findsWidgets);
    });
  });
}

Match _createMockMatch(int id, String status) {
  return Match(
    id: id,
    status: status,
    utcDate: DateTime.now(),
    area: const Area(
      id: 1,
      name: 'England',
      code: 'ENG',
      flag: 'https://example.com/flag.svg',
    ),
    competition: const Competition(
      id: 1,
      name: 'Premier League',
      code: 'PL',
      type: 'LEAGUE',
      emblem: 'https://example.com/emblem.svg',
    ),
    season: Season(
      id: 1,
      startDate: DateTime(2024, 8),
      endDate: DateTime(2025, 5, 31),
      currentMatchday: 10,
      winner: Team.empty,
    ),
    matchday: 10,
    stage: 'REGULAR_SEASON',
    group: '',
    lastUpdated: DateTime.now(),
    homeTeam: const Team(
      id: 1,
      area: Area.empty,
      name: 'Chelsea FC',
      shortName: 'Chelsea',
      tla: 'CHE',
      crest: 'https://example.com/chelsea.svg',
      address: '',
      website: '',
      founded: 0,
      clubColors: '',
      venue: '',
      runningCompetitions: [],
      coach: Staff.empty,
      squad: [],
      staff: [],
    ),
    awayTeam: const Team(
      id: 2,
      area: Area.empty,
      name: 'Arsenal FC',
      shortName: 'Arsenal',
      tla: 'ARS',
      crest: 'https://example.com/arsenal.svg',
      address: '',
      website: '',
      founded: 0,
      clubColors: '',
      venue: '',
      runningCompetitions: [],
      coach: Staff.empty,
      squad: [],
      staff: [],
    ),
    score: const Score(
      winner: 'HOME_TEAM',
      duration: 'REGULAR',
      fullTime: Time(home: 2, away: 1),
      halfTime: Time(home: 1, away: 0),
    ),
    odds: Odds.empty,
    referees: const [],
  );
}

Map<String, dynamic> _matchToMap(Match match) {
  return {
    'id': match.id,
    'status': match.status,
    'utcDate': Timestamp.fromDate(match.utcDate!),
    'area': {
      'id': match.area.id,
      'name': match.area.name,
      'code': match.area.code,
      'flag': match.area.flag,
    },
    'competition': {
      'id': match.competition.id,
      'name': match.competition.name,
      'code': match.competition.code,
      'type': match.competition.type,
      'emblem': match.competition.emblem,
    },
    'season': {
      'id': match.season.id,
      'startDate': match.season.startDate?.toIso8601String(),
      'endDate': match.season.endDate?.toIso8601String(),
      'currentMatchday': match.season.currentMatchday,
    },
    'matchday': match.matchday,
    'stage': match.stage,
    'group': match.group,
    'lastUpdated': Timestamp.fromDate(match.lastUpdated!),
    'homeTeam': {
      'id': match.homeTeam.id,
      'area': {
        'id': 0,
        'name': '',
        'code': '',
        'flag': '',
      },
      'name': match.homeTeam.name,
      'shortName': match.homeTeam.shortName,
      'tla': match.homeTeam.tla,
      'crest': match.homeTeam.crest,
      'address': '',
      'website': '',
      'founded': 0,
      'clubColors': '',
      'venue': '',
      'runningCompetitions': <Map<String, dynamic>>[],
      'coach': {
        'id': 0,
        'firstName': '',
        'lastName': '',
        'name': '',
        'dateOfBirth': null,
        'nationality': '',
        'contract': null,
      },
      'squad': <Map<String, dynamic>>[],
      'staff': <Map<String, dynamic>>[],
    },
    'awayTeam': {
      'id': match.awayTeam.id,
      'area': {
        'id': 0,
        'name': '',
        'code': '',
        'flag': '',
      },
      'name': match.awayTeam.name,
      'shortName': match.awayTeam.shortName,
      'tla': match.awayTeam.tla,
      'crest': match.awayTeam.crest,
      'address': '',
      'website': '',
      'founded': 0,
      'clubColors': '',
      'venue': '',
      'runningCompetitions': <Map<String, dynamic>>[],
      'coach': {
        'id': 0,
        'firstName': '',
        'lastName': '',
        'name': '',
        'dateOfBirth': null,
        'nationality': '',
        'contract': null,
      },
      'squad': <Map<String, dynamic>>[],
      'staff': <Map<String, dynamic>>[],
    },
    'score': {
      'winner': match.score.winner,
      'duration': match.score.duration,
      'fullTime': {
        'home': match.score.fullTime.home,
        'away': match.score.fullTime.away,
      },
      'halfTime': {
        'home': match.score.halfTime.home,
        'away': match.score.halfTime.away,
      },
    },
    'odds': {
      'homeWin': match.odds.homeWin,
      'draw': match.odds.draw,
      'awayWin': match.odds.awayWin,
    },
    'referees': <Map<String, dynamic>>[],
  };
}
