import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';

class MockAndroidBuildVersion extends Mock implements AndroidBuildVersion {}

class MockAndroidDeviceInfo extends Mock implements AndroidDeviceInfo {}

void main() {
  group('DatabaseService', () {
    late FakeFirebaseFirestore fakeFirestore;
    late DatabaseService databaseService;

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
      databaseService = DatabaseService(firestore: fakeFirestore);
    });

    test('saveLanguage saves language to firestore', () async {
      const token = 'test_token';
      const language = Locale('es', 'ES');

      databaseService.saveLanguage(token: token, language: language);

      await Future<void>.delayed(const Duration(milliseconds: 100));

      final doc = await fakeFirestore
          .collection(AppVariables.devicesCollection)
          .doc(token)
          .get();

      expect(doc.exists, isTrue);
      expect(doc.data()?['language'], 'es-ES');
    });

    test('setLocalSettingsDevice saves settings to firestore', () async {
      const token = 'test_token';

      final version = MockAndroidBuildVersion();
      when(() => version.codename).thenReturn('');
      when(() => version.incremental).thenReturn('');
      when(() => version.previewSdkInt).thenReturn(0);
      when(() => version.release).thenReturn('');
      when(() => version.sdkInt).thenReturn(0);
      when(() => version.securityPatch).thenReturn('');

      final androidInfo = MockAndroidDeviceInfo();
      when(() => androidInfo.version).thenReturn(version);
      when(() => androidInfo.board).thenReturn('');
      when(() => androidInfo.bootloader).thenReturn('');
      when(() => androidInfo.brand).thenReturn('');
      when(() => androidInfo.device).thenReturn('');
      when(() => androidInfo.display).thenReturn('');
      when(() => androidInfo.fingerprint).thenReturn('');
      when(() => androidInfo.hardware).thenReturn('');
      when(() => androidInfo.host).thenReturn('');
      when(() => androidInfo.id).thenReturn('');
      when(() => androidInfo.manufacturer).thenReturn('');
      when(() => androidInfo.model).thenReturn('');
      when(() => androidInfo.product).thenReturn('');
      when(() => androidInfo.supported32BitAbis).thenReturn(<String>[]);
      when(() => androidInfo.supported64BitAbis).thenReturn(<String>[]);
      when(() => androidInfo.supportedAbis).thenReturn(<String>[]);
      when(() => androidInfo.tags).thenReturn('');
      when(() => androidInfo.type).thenReturn('');
      when(() => androidInfo.isPhysicalDevice).thenReturn(true);
      when(() => androidInfo.systemFeatures).thenReturn(<String>[]);
      when(() => androidInfo.isLowRamDevice).thenReturn(false);
      when(() => androidInfo.physicalRamSize).thenReturn(0);
      when(() => androidInfo.availableRamSize).thenReturn(0);

      databaseService.setLocalSettingsDevice(
        token: token,
        androidInfo: androidInfo,
        localLanguage: const Locale('en', 'US'),
      );

      await Future<void>.delayed(const Duration(milliseconds: 100));

      final doc = await fakeFirestore
          .collection(AppVariables.devicesCollection)
          .doc(token)
          .get();

      expect(doc.exists, isTrue);
      expect(doc.data()?['token'], token);
      expect(doc.data()?['language'], 'en-US');
      expect(doc.data()?['platform'], AppVariables.appOS);
    });

    test('getConfigs returns config stream', () async {
      await fakeFirestore.collection(AppVariables.configsCollection).add({
        'id': 'test_config',
        'lastUpdate': Timestamp.now(),
      });

      final stream = databaseService.getConfigs(id: 'test_config');
      final configs = await stream.first;

      expect(configs, isNotEmpty);
      expect(configs.first.id, 'test_config');
    });

    test('getLeagues returns league stream', () async {
      await fakeFirestore.collection(AppVariables.leaguesCollection).add({
        'id': 2014,
        'name': 'La Liga',
        'currentSeason': {
          'startDate': '2023-01-01T00:00:00Z',
          'endDate': '2023-12-31T00:00:00Z',
        },
      });

      final stream = databaseService.getLeagues();
      final leagues = await stream.first;

      expect(leagues, isNotEmpty);
      expect(leagues.first.id, 2014);
    });

    test('getMatch returns specific match stream', () async {
      await fakeFirestore.collection(AppVariables.matchesCollection).add({
        'id': 100,
        'status': 'FINISHED',
        'season': {
          'startDate': '2023-01-01T00:00:00Z',
          'endDate': '2023-12-31T00:00:00Z',
        },
      });

      final stream = databaseService.getMatch(matchId: 100);
      final matches = await stream.first;

      expect(matches, isNotEmpty);
      expect(matches.first.id, 100);
    });

    test('getStandings returns standings stream', () async {
      await fakeFirestore.collection(AppVariables.standingsCollection).add({
        'id': 'PD',
        'stage': 'REGULAR_SEASON',
      });

      final stream = databaseService.getStandings(leagueId: 'PD');
      final standings = await stream.first;

      expect(standings, isNotEmpty);
      expect(standings.first['stage'], 'REGULAR_SEASON');
    });

    test('getTeam returns specific team stream', () async {
      await fakeFirestore.collection(AppVariables.teamsCollection).add({
        'id': 81,
        'name': 'FC Barcelona',
      });

      final stream = databaseService.getTeam(teamId: 81);
      final teams = await stream.first;

      expect(teams, isNotEmpty);
      expect(teams.first.id, 81);
    });

    test('getTeamsByLeague returns team stream for league', () async {
      await fakeFirestore.collection(AppVariables.teamsCollection).add({
        'id': 81,
        'name': 'FC Barcelona',
        'competition': {'id': 2014},
      });

      final stream = databaseService.getTeamsByLeague(leagueId: 2014);
      final teams = await stream.first;

      expect(teams, isNotEmpty);
      expect(teams.first.id, 81);
    });

    test('getDevices returns specific device stream', () async {
      await fakeFirestore.collection(AppVariables.devicesCollection).add({
        'token': 'my_token',
        'platform': 'WearOS',
      });

      final stream = databaseService.getDevices(token: 'my_token');
      final devices = await stream.first;

      expect(devices, isNotEmpty);
      expect(devices.first['token'], 'my_token');
    });

    test('changeEnabledTeams adds or removes team from array', () async {
      const token = 'my_token_2';
      await fakeFirestore
          .collection(AppVariables.devicesCollection)
          .doc(token)
          .set({
        'enabledTeams': <String>[],
      });

      databaseService.changeEnabledTeams(
        teamId: 81,
        token: token,
        enabledTeams: <String>[],
      );

      await Future<void>.delayed(const Duration(milliseconds: 200));

      final doc1 = await fakeFirestore
          .collection(AppVariables.devicesCollection)
          .doc(token)
          .get();
      expect(doc1.data()?['enabledTeams'], contains('81'));

      databaseService.changeEnabledTeams(
        teamId: 81,
        token: token,
        enabledTeams: ['81'],
      );

      await Future<void>.delayed(const Duration(milliseconds: 200));

      final doc2 = await fakeFirestore
          .collection(AppVariables.devicesCollection)
          .doc(token)
          .get();
      expect(doc2.data()?['enabledTeams'], isNot(contains('81')));
    });

    test('getMatches returns match stream based on date filters', () async {
      final now = DateTime.now();

      await fakeFirestore.collection(AppVariables.matchesCollection).add({
        'id': 200,
        'competition': {'code': 'PL'},
        'utcDate':
            Timestamp.fromDate(DateTime(now.year, now.month, now.day, 12)),
        'season': {
          'startDate': '2023-01-01T00:00:00Z',
          'endDate': '2023-12-31T00:00:00Z',
        },
      });

      final stream = databaseService.getMatches(enabledLeagues: ['PL']);
      final matches = await stream.first;

      expect(matches, isNotEmpty);
      expect(matches.first.id, 200);
    });
  });
}
