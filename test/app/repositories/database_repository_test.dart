import 'package:flutter_test/flutter_test.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';

void main() {
  group('MockDatabaseRepository', () {
    late MockDatabaseRepository mockRepository;

    setUp(() {
      mockRepository = MockDatabaseRepository();
    });

    test('updateDeviceSettings does not crash', () {
      expect(
        () => mockRepository.updateDeviceSettings(
          token: 'token',
          deviceInfo: const AppDeviceInfo(id: 'id'),
        ),
        returnsNormally,
      );
    });

    test('getMatchStream returns barca vs madrid', () async {
      final match = await mockRepository.getMatchStream(matchId: 1).first;
      expect(match.homeTeam.id, 81);
    });

    test('getMatchesStream returns all matches', () async {
      final matches = await mockRepository
          .getMatchesStream(enabledLeagues: const [])
          .first;
      expect(matches, isNotEmpty);
    });

    test('getConfigStream returns Config', () async {
      final cfg = await mockRepository.getConfigStream(id: '123').first;
      expect(cfg.id, '123');
    });

    test('getLeaguesStream returns dummy leagues', () async {
      final leagues = await mockRepository.getLeaguesStream().first;
      expect(leagues.length, 2);
    });

    test('getStandingsStream returns standings', () async {
      final standings = await mockRepository
          .getStandingsStream(leagueId: '123')
          .first;
      expect(standings.standings, isNotEmpty);
    });

    test('getTeamStream returns barca', () async {
      final team = await mockRepository.getTeamStream(teamId: 81).first;
      expect(team.id, 81);
    });

    test('getTeamsStream returns all teams', () async {
      final teams = await mockRepository.getTeamsStream().first;
      expect(teams.length, 6);
    });

    test('getDeviceStream returns dummy device', () async {
      final dev = await mockRepository.getDeviceStream(token: 'ttt').first;
      expect(dev.token, 'ttt');
      expect(dev.platform, Platform.wearOS);
    });
  });
}
