import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';
import 'package:tiki_taka_scoreboard_wearos/l10n/l10n.dart';
import 'package:tiki_taka_scoreboard_wearos/team/team.dart';

class MockTeamCubit extends MockCubit<TeamState> implements TeamCubit {}

class MockDatabaseService extends Mock implements DatabaseService {}

class MockTeam extends Mock implements Team {}

class MockStaff extends Mock implements Staff {}

class MockContract extends Mock implements Contract {}

class MockLeague extends Mock implements League {}

void main() {
  group('TeamPage and TeamView', () {
    late MockTeamCubit teamCubit;
    late MockDatabaseService mockDatabase;

    setUpAll(() async {
      mockDatabase = MockDatabaseService();

      if (getIt.isRegistered<DatabaseService>()) {
        await getIt.unregister<DatabaseService>();
      }
      getIt.registerSingleton<DatabaseService>(mockDatabase);
    });

    setUp(() {
      teamCubit = MockTeamCubit();
      when(() => teamCubit.state).thenReturn(const TeamState(teamId: 10));
      when(() => teamCubit.initialize(teamId: 10)).thenAnswer((_) async {});
    });

    testWidgets('renders TeamPage properly and shows shimmers when loading',
        (tester) async {
      when(() => mockDatabase.getTeamStream(teamId: 10))
          .thenAnswer((_) => const Stream.empty());

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: BlocProvider<TeamCubit>.value(
            value: teamCubit,
            child: const TeamPage(teamId: 10),
          ),
        ),
      );

      expect(find.byType(TeamPage), findsOneWidget);
      expect(find.byType(TeamView), findsOneWidget);
    });

    testWidgets('shows error state when stream emits error', (tester) async {
      when(() => mockDatabase.getTeamStream(teamId: 10))
          .thenAnswer((_) => Stream.error('Error'));

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: BlocProvider<TeamCubit>.value(
            value: teamCubit,
            child: const TeamView(),
          ),
        ),
      );

      await tester.pump();
    });

    testWidgets('shows team data when stream emits data', (tester) async {
      final mockTeam = MockTeam();
      when(() => mockTeam.id).thenReturn(10);
      when(() => mockTeam.name).thenReturn('FC Barcelona');
      when(() => mockTeam.shortName).thenReturn('Barca');
      when(() => mockTeam.tla).thenReturn('FCB');
      when(() => mockTeam.crest).thenReturn('crest.png');
      when(() => mockTeam.clubColors).thenReturn('Blue / Red');
      when(() => mockTeam.venue).thenReturn('Camp Nou');
      when(() => mockTeam.founded).thenReturn(1899);
      when(() => mockTeam.address).thenReturn('Aristides Maillol s/n');
      when(() => mockTeam.website).thenReturn('http://www.fcbarcelona.cat');

      final mockCoach = MockStaff();
      final mockContract = MockContract();
      when(() => mockContract.until).thenReturn('2025-06-30');
      when(() => mockCoach.id).thenReturn(1);
      when(() => mockCoach.name).thenReturn('Xavi Hernandez');
      when(() => mockCoach.nationality).thenReturn('Spain');
      when(() => mockCoach.dateOfBirth).thenReturn('1980-01-25');
      when(() => mockCoach.contract).thenReturn(mockContract);

      final mockPlayer = MockStaff();
      when(() => mockPlayer.id).thenReturn(2);
      when(() => mockPlayer.position).thenReturn('Offence');
      when(() => mockPlayer.name).thenReturn('Robert Lewandowski');
      when(() => mockPlayer.nationality).thenReturn('Poland');
      when(() => mockPlayer.dateOfBirth).thenReturn('1988-08-21');

      final mockStaffMember = MockStaff();
      when(() => mockStaffMember.id).thenReturn(3);
      when(() => mockStaffMember.position).thenReturn('Assistant Coach');
      when(() => mockStaffMember.name).thenReturn('Ramon Canal');
      when(() => mockStaffMember.nationality).thenReturn('Spain');
      when(() => mockStaffMember.dateOfBirth).thenReturn('1961-08-11');

      final mockLeague = MockLeague();
      when(() => mockLeague.emblem).thenReturn('laliga.png');
      when(() => mockLeague.name).thenReturn('La Liga');
      when(() => mockLeague.type).thenReturn('LEAGUE');

      when(() => mockTeam.coach).thenReturn(mockCoach);
      when(() => mockTeam.squad).thenReturn([mockPlayer]);
      when(() => mockTeam.staff).thenReturn([mockStaffMember]);
      when(() => mockTeam.runningCompetitions).thenReturn([mockLeague]);

      when(() => mockDatabase.getTeamStream(teamId: 10))
          .thenAnswer((_) => Stream.value(mockTeam));

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: BlocProvider<TeamCubit>.value(
            value: teamCubit,
            child: const TeamView(),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('FC Barcelona'), findsOneWidget);
      expect(find.text('Xavi Hernandez'), findsOneWidget);

      await tester.tap(find.text('Squad'));
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('Robert Lewandowski'), findsOneWidget);

      final infoFinder = find.text('Info');
      await tester.ensureVisible(infoFinder);
      await tester.tap(infoFinder);
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('Camp Nou'), findsOneWidget);
    });
  });
}
