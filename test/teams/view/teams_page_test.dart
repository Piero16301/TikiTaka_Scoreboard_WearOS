import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';
import 'package:tiki_taka_scoreboard_wearos/l10n/l10n.dart';
import 'package:tiki_taka_scoreboard_wearos/teams/teams.dart';

class MockTeamsCubit extends MockCubit<TeamsState> implements TeamsCubit {}

class MockAppCubit extends MockCubit<AppState> implements AppCubit {}

class MockDatabaseService extends Mock implements DatabaseService {}

class MockNotificationService extends Mock implements NotificationService {}

class MockTeam extends Mock implements Team {}

class MockAnalyticsService extends Mock implements AnalyticsService {}

void main() {
  group('TeamsPage and TeamsView', () {
    late MockTeamsCubit teamsCubit;
    late MockAppCubit appCubit;
    late MockDatabaseService mockDatabase;
    late MockNotificationService mockNotification;
    late MockAnalyticsService mockAnalytics;

    setUpAll(() async {
      mockDatabase = MockDatabaseService();
      mockNotification = MockNotificationService();
      mockAnalytics = MockAnalyticsService();

      if (getIt.isRegistered<DatabaseService>()) {
        await getIt.unregister<DatabaseService>();
      }
      getIt.registerSingleton<DatabaseService>(mockDatabase);

      if (getIt.isRegistered<NotificationService>()) {
        getIt.unregister<NotificationService>();
      }
      getIt.registerSingleton<NotificationService>(mockNotification);

      if (getIt.isRegistered<AnalyticsService>()) {
        await getIt.unregister<AnalyticsService>();
      }
      getIt.registerSingleton<AnalyticsService>(mockAnalytics);
    });

    setUp(() {
      teamsCubit = MockTeamsCubit();
      appCubit = MockAppCubit();
      when(() => teamsCubit.state).thenReturn(const TeamsState(leagueId: 1));
      when(() => teamsCubit.initialize(leagueId: 1)).thenAnswer((_) async {});
      when(() => appCubit.state).thenReturn(AppState(device: Device.empty));
      when(() => mockNotification.token).thenReturn('mock_token');
      when(
        () => mockAnalytics.logEvent(
          name: any(named: 'name'),
          parameters: any(named: 'parameters'),
        ),
      ).thenAnswer((_) async {});

      // Add default stubs to avoid Null errors
      when(
        () => mockDatabase.getDeviceStream(token: any(named: 'token')),
      ).thenAnswer((_) => const Stream.empty());
    });

    testWidgets('renders TeamsPage properly and shows shimmers when loading', (
      tester,
    ) async {
      when(
        () => mockDatabase.getTeamsStream(leagueId: 1),
      ).thenAnswer((_) => const Stream.empty());

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: BlocProvider<AppCubit>.value(
            value: appCubit,
            child: BlocProvider<TeamsCubit>.value(
              value: teamsCubit,
              child: const TeamsPage(leagueId: 1),
            ),
          ),
        ),
      );

      await tester.pump();

      expect(find.byType(TeamsPage), findsOneWidget);
      expect(find.byType(TeamsView), findsOneWidget);
    });

    testWidgets('shows error state when stream emits error', (tester) async {
      when(
        () => mockDatabase.getTeamsStream(leagueId: 1),
      ).thenAnswer((_) => Stream.error('Error'));

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: BlocProvider<AppCubit>.value(
            value: appCubit,
            child: BlocProvider<TeamsCubit>.value(
              value: teamsCubit,
              child: const TeamsView(),
            ),
          ),
        ),
      );

      await tester.pump();

      expect(find.text('Error loading teams'), findsOneWidget);
    });

    testWidgets('shows empty state when stream emits empty list', (
      tester,
    ) async {
      when(
        () => mockDatabase.getTeamsStream(leagueId: 1),
      ).thenAnswer((_) => Stream.value([]));

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: BlocProvider<AppCubit>.value(
            value: appCubit,
            child: BlocProvider<TeamsCubit>.value(
              value: teamsCubit,
              child: const TeamsView(),
            ),
          ),
        ),
      );

      await tester.pump();

      expect(find.text('No teams available'), findsOneWidget);
    });

    testWidgets('shows list of teams when stream emits data', (tester) async {
      final mockTeam = MockTeam();
      when(() => mockTeam.id).thenReturn(99);
      when(() => mockTeam.name).thenReturn('FC Barcelona');
      when(() => mockTeam.crest).thenReturn('crest.png');

      when(
        () => mockDatabase.getTeamsStream(leagueId: 1),
      ).thenAnswer((_) => Stream.value([mockTeam]));
      when(() => appCubit.state).thenReturn(
        AppState(
          device: Device.fromJson(const {
            'enabledTeams': ['99'],
          }),
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: BlocProvider<AppCubit>.value(
            value: appCubit,
            child: BlocProvider<TeamsCubit>.value(
              value: teamsCubit,
              child: const TeamsView(),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.textContaining('FC Barcelona'), findsOneWidget);
      expect(find.byType(TeamCardTeams), findsOneWidget);
      expect(find.byType(Switch), findsOneWidget);
    });

    testWidgets('toggles enabled state properly', (tester) async {
      final mockTeam = MockTeam();
      when(() => mockTeam.id).thenReturn(99);
      when(() => mockTeam.name).thenReturn('FC Barcelona');
      when(() => mockTeam.crest).thenReturn('crest.png');

      when(
        () => mockDatabase.getTeamsStream(leagueId: 1),
      ).thenAnswer((_) => Stream.value([mockTeam]));
      when(() => appCubit.state).thenReturn(
        AppState(
          device: Device.fromJson(const {
            'enabledTeams': ['99'],
          }),
        ),
      );
      when(
        () => mockDatabase.updateDeviceSettings(
          teamToModify: 99,
          token: 'mock_token',
          enabledTeams: ['99'],
        ),
      ).thenReturn(null);

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: BlocProvider<AppCubit>.value(
            value: appCubit,
            child: BlocProvider<TeamsCubit>.value(
              value: teamsCubit,
              child: const TeamsView(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final switchFinder = find.byType(Switch);
      await tester.tap(switchFinder);
      await tester.pumpAndSettle();

      verify(
        () => mockDatabase.updateDeviceSettings(
          teamToModify: 99,
          token: 'mock_token',
          enabledTeams: ['99'],
        ),
      ).called(1);
    });
  });
}
