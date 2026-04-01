import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart' hide Table;
import 'package:flutter_test/flutter_test.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';

void main() {
  group('FirestoreDatabaseRepository', () {
    late FakeFirebaseFirestore fakeFirestore;
    late FirestoreDatabaseRepository repository;

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
      repository = FirestoreDatabaseRepository(firestore: fakeFirestore);
    });

    test('updateDeviceSettings stores data in firestore', () async {
      const deviceInfo = AppDeviceInfo(
        id: '123',
        model: 'test-model',
      );

      repository.updateDeviceSettings(
        token: 'test-token',
        deviceInfo: deviceInfo,
        language: const Locale('es', 'ES'),
        enabledTeams: const ['1', '2'],
        teamToModify: 3,
      );

      await Future<void>.delayed(const Duration(milliseconds: 50));

      final doc = await fakeFirestore
          .collection(AppVariables.devicesCollection)
          .doc('test-token')
          .get();

      expect(doc.exists, true);
      final data = doc.data()!;
      expect(data['language'], 'es_ES');
      expect(data['token'], 'test-token');
      expect((data['enabledTeams'] as List).contains('3'), true);
    });

    test('updateDeviceSettings removes team if already enabled', () async {
      await fakeFirestore
          .collection(AppVariables.devicesCollection)
          .doc('test-token')
          .set({
        'enabledTeams': ['3', '4'],
      });

      repository.updateDeviceSettings(
        token: 'test-token',
        enabledTeams: const ['3', '4'],
        teamToModify: 3,
      );

      await Future<void>.delayed(const Duration(milliseconds: 50));

      final doc = await fakeFirestore
          .collection(AppVariables.devicesCollection)
          .doc('test-token')
          .get();

      final data = doc.data()!;
      expect((data['enabledTeams'] as List).contains('3'), false);
    });

    test('getMatchStream streams team correctly', () async {
      final matchData = <String, dynamic>{
        'id': 99,
        'utcDate':
            Timestamp.fromDate(DateTime.parse('2026-03-31T23:04:31.000Z')),
        'status': 'SCHEDULED',
        'matchday': 1,
        'stage': 'GROUP',
        'lastUpdated':
            Timestamp.fromDate(DateTime.parse('2026-03-31T23:04:31.000Z')),
        'competition': {
          'id': 2000,
          'name': 'dummy',
          'code': 'DM',
          'type': 'LEAGUE',
          'emblem': '',
        },
        'season': {
          'id': 1,
          'startDate': '2026-01-01',
          'endDate': '2026-12-31',
          'currentMatchday': 1,
        },
        'area': {'id': 1, 'name': 'dummy', 'code': 'DM', 'flag': ''},
        'homeTeam': {
          'id': 1,
          'name': 'hh',
          'shortName': 'h',
          'tla': 'HHH',
          'crest': '',
        },
        'awayTeam': {
          'id': 2,
          'name': 'aa',
          'shortName': 'a',
          'tla': 'AAA',
          'crest': '',
        },
      };

      await fakeFirestore
          .collection(AppVariables.matchesCollection)
          .doc('99')
          .set(matchData);

      final stream = repository.getMatchStream(matchId: 99);
      final match = await stream.first;
      expect(match.id, 99);
    });

    test('getTeamStream streams correctly', () async {
      final mockTeam = <String, dynamic>{
        'id': 42,
        'name': 'Test Team',
        'shortName': 'Test',
        'tla': 'TES',
        'crest': 'url',
      };
      await fakeFirestore
          .collection(AppVariables.teamsCollection)
          .add(mockTeam);

      final stream = repository.getTeamStream(teamId: 42);
      final team = await stream.first;
      expect(team.id, 42);
    });

    test('getDeviceStream streams correctly', () async {
      final mockDevice = <String, dynamic>{
        'token': 'token1',
        'platform': 'wearOS',
        'enabledTeams': ['42'],
        'language': 'en_US',
        'lastOpenAt':
            Timestamp.fromDate(DateTime.parse('2026-03-31T23:04:31.000Z')),
      };

      await fakeFirestore
          .collection(AppVariables.devicesCollection)
          .doc('token1')
          .set(mockDevice);

      final stream = repository.getDeviceStream(token: 'token1');
      final device = await stream.first;
      expect(device.token, 'token1');
    });

    test('getConfigStream streams correctly', () async {
      final mockConfig = <String, dynamic>{
        'id': 'cfg_id',
        'lastUpdate': Timestamp.fromDate(DateTime(2025)),
      };

      await fakeFirestore
          .collection(AppVariables.configsCollection)
          .doc('cfg_id')
          .set(mockConfig);

      final stream = repository.getConfigStream(id: 'cfg_id');
      final cfg = await stream.first;
      expect(cfg.id, 'cfg_id');
    });

    test('getLeaguesStream streams correctly', () async {
      final mockLeague = <String, dynamic>{
        'id': 1,
        'name': 'Lg 1',
        'code': 'LG1',
        'type': 'LEAGUE',
        'emblem': '',
        'area': {'id': 1, 'name': 'A', 'code': 'A', 'flag': ''},
        'currentSeason': {
          'id': 1,
          'startDate': '2024-01-01',
          'endDate': '2024-12-31',
          'currentMatchday': 1,
        },
        'plan': 'test',
        'numberOfAvailableSeasons': 2,
        'lastUpdated':
            Timestamp.fromDate(DateTime.parse('2026-03-31T23:04:31.000Z')),
      };
      await fakeFirestore
          .collection(AppVariables.leaguesCollection)
          .add(mockLeague);

      final stream = repository.getLeaguesStream();
      final items = await stream.first;
      expect(items.length, 1);
      expect(items.first.id, 1);
    });

    test('getMatchesStream returns empty due to static nowDate inside function',
        () async {
      final stream = repository.getMatchesStream(enabledLeagues: const []);
      final items = await stream.first;
      expect(items, isEmpty);
    });
  });

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
      final matches =
          await mockRepository.getMatchesStream(enabledLeagues: const []).first;
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
      final standings =
          await mockRepository.getStandingsStream(leagueId: '123').first;
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
