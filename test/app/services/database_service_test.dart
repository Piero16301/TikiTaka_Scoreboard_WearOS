import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';

class MockDatabaseRepository extends Mock implements DatabaseRepository {}

class MockAppDeviceInfo extends Mock implements AppDeviceInfo {}

class MockMatch extends Mock implements Match {}

class MockConfig extends Mock implements Config {}

class MockLeague extends Mock implements League {}

class MockLeagueStandings extends Mock implements LeagueStandings {}

class MockTeam extends Mock implements Team {}

class MockDevice extends Mock implements Device {}

void main() {
  group('DatabaseService', () {
    late MockDatabaseRepository mockRepository;
    late DatabaseService databaseService;

    setUp(() {
      mockRepository = MockDatabaseRepository();
      databaseService = DatabaseService(databaseRepository: mockRepository);
    });

    test('updateDeviceSettings delegates to repository', () {
      final mockDeviceInfo = MockAppDeviceInfo();
      when(
        () => mockRepository.updateDeviceSettings(
          token: any(named: 'token'),
          deviceInfo: any(named: 'deviceInfo'),
          language: any(named: 'language'),
          teamToModify: any(named: 'teamToModify'),
          enabledTeams: any(named: 'enabledTeams'),
        ),
      ).thenReturn(null);

      databaseService.updateDeviceSettings(
        token: 'test_token',
        deviceInfo: mockDeviceInfo,
        language: const Locale('en', 'US'),
        teamToModify: 123,
        enabledTeams: ['team1', 'team2'],
      );

      verify(
        () => mockRepository.updateDeviceSettings(
          token: 'test_token',
          deviceInfo: mockDeviceInfo,
          language: const Locale('en', 'US'),
          teamToModify: 123,
          enabledTeams: const ['team1', 'team2'],
        ),
      ).called(1);
    });

    test('getMatchStream delegates to repository', () {
      final mockMatchStream = Stream.value(MockMatch());
      when(
        () => mockRepository.getMatchStream(matchId: 1),
      ).thenAnswer((_) => mockMatchStream);

      final stream = databaseService.getMatchStream(matchId: 1);
      expect(stream, equals(mockMatchStream));
      verify(() => mockRepository.getMatchStream(matchId: 1)).called(1);
    });

    test('getMatchesStream delegates to repository', () {
      final mockMatchesStream = Stream.value([MockMatch()]);
      when(
        () => mockRepository.getMatchesStream(enabledLeagues: ['PL']),
      ).thenAnswer((_) => mockMatchesStream);

      final stream = databaseService.getMatchesStream(
        enabledLeagues: const ['PL'],
      );
      expect(stream, equals(mockMatchesStream));
      verify(
        () => mockRepository.getMatchesStream(enabledLeagues: const ['PL']),
      ).called(1);
    });

    test('getConfigStream delegates to repository', () {
      final mockConfigStream = Stream.value(MockConfig());
      when(
        () => mockRepository.getConfigStream(id: 'conf1'),
      ).thenAnswer((_) => mockConfigStream);

      final stream = databaseService.getConfigStream(id: 'conf1');
      expect(stream, equals(mockConfigStream));
      verify(() => mockRepository.getConfigStream(id: 'conf1')).called(1);
    });

    test('getLeaguesStream delegates to repository', () {
      final mockLeaguesStream = Stream.value([MockLeague()]);
      when(
        () => mockRepository.getLeaguesStream(),
      ).thenAnswer((_) => mockLeaguesStream);

      final stream = databaseService.getLeaguesStream();
      expect(stream, equals(mockLeaguesStream));
      verify(() => mockRepository.getLeaguesStream()).called(1);
    });

    test('getStandingsStream delegates to repository', () {
      final mockStandingsStream = Stream.value(MockLeagueStandings());
      when(
        () => mockRepository.getStandingsStream(leagueId: 'lg1'),
      ).thenAnswer((_) => mockStandingsStream);

      final stream = databaseService.getStandingsStream(leagueId: 'lg1');
      expect(stream, equals(mockStandingsStream));
      verify(
        () => mockRepository.getStandingsStream(leagueId: 'lg1'),
      ).called(1);
    });

    test('getTeamStream delegates to repository', () {
      final mockTeamStream = Stream.value(MockTeam());
      when(
        () => mockRepository.getTeamStream(teamId: 10),
      ).thenAnswer((_) => mockTeamStream);

      final stream = databaseService.getTeamStream(teamId: 10);
      expect(stream, equals(mockTeamStream));
      verify(() => mockRepository.getTeamStream(teamId: 10)).called(1);
    });

    test('getTeamsStream delegates to repository', () {
      final mockTeamsStream = Stream.value([MockTeam()]);
      when(
        () => mockRepository.getTeamsStream(leagueId: 5),
      ).thenAnswer((_) => mockTeamsStream);

      final stream = databaseService.getTeamsStream(leagueId: 5);
      expect(stream, equals(mockTeamsStream));
      verify(() => mockRepository.getTeamsStream(leagueId: 5)).called(1);
    });

    test('getDeviceStream delegates to repository', () {
      final mockDeviceStream = Stream.value(MockDevice());
      when(
        () => mockRepository.getDeviceStream(token: 'tok1'),
      ).thenAnswer((_) => mockDeviceStream);

      final stream = databaseService.getDeviceStream(token: 'tok1');
      expect(stream, equals(mockDeviceStream));
      verify(() => mockRepository.getDeviceStream(token: 'tok1')).called(1);
    });
  });
}
