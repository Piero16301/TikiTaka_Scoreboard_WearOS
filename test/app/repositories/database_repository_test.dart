// Mocking sealed Firestore classes for unit tests.
// ignore_for_file: subtype_of_sealed_class

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart' hide Table;
import 'package:mocktail/mocktail.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockCollectionReference extends Mock
    implements CollectionReference<Map<String, dynamic>> {}

class MockDocumentReference extends Mock
    implements DocumentReference<Map<String, dynamic>> {}

class MockDocumentSnapshot extends Mock
    implements DocumentSnapshot<Map<String, dynamic>> {}

class MockQuery extends Mock implements Query<Map<String, dynamic>> {}

class MockQuerySnapshot extends Mock
    implements QuerySnapshot<Map<String, dynamic>> {}

class MockQueryDocumentSnapshot extends Mock
    implements QueryDocumentSnapshot<Map<String, dynamic>> {}

class MockCrashService extends Mock implements CrashService {}

class FakeSetOptions extends Fake implements SetOptions {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(FakeSetOptions());
  });

  group('MockDatabaseRepository', () {
    late MockDatabaseRepository mockRepository;

    setUp(() {
      mockRepository = MockDatabaseRepository();
    });

    test('updateDeviceSettings does not crash with all parameters', () {
      expect(
        () => mockRepository.updateDeviceSettings(
          token: 'token',
          deviceInfo: const AppDeviceInfo(id: 'id'),
          language: const Locale('en', 'US'),
          teamToModify: 81,
          enabledTeams: const ['81', '86'],
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

    test('getTeamsStream returns all teams without leagueId', () async {
      final teams = await mockRepository.getTeamsStream().first;
      expect(teams.length, 6);
    });

    test('getTeamsStream returns all teams with leagueId', () async {
      final teams = await mockRepository.getTeamsStream(leagueId: 2014).first;
      expect(teams.length, 6);
    });

    test('getDeviceStream returns dummy device', () async {
      final dev = await mockRepository.getDeviceStream(token: 'ttt').first;
      expect(dev.token, 'ttt');
      expect(dev.platform, Platform.wearOS);
    });
  });

  group('FirestoreDatabaseRepository', () {
    late MockFirebaseFirestore mockFirestore;
    late MockCollectionReference mockCollection;
    late MockDocumentReference mockDocument;
    late MockDocumentSnapshot mockDocSnapshot;
    late MockQuery mockQuery;
    late MockQuerySnapshot mockQuerySnapshot;
    late MockQueryDocumentSnapshot mockQueryDocSnapshot;
    late FirestoreDatabaseRepository repository;

    setUp(() {
      mockFirestore = MockFirebaseFirestore();
      mockCollection = MockCollectionReference();
      mockDocument = MockDocumentReference();
      mockDocSnapshot = MockDocumentSnapshot();
      mockQuery = MockQuery();
      mockQuerySnapshot = MockQuerySnapshot();
      mockQueryDocSnapshot = MockQueryDocumentSnapshot();

      when(() => mockFirestore.collection(any())).thenReturn(mockCollection);
      when(() => mockCollection.doc(any())).thenReturn(mockDocument);
      when(
        () => mockCollection.snapshots(),
      ).thenAnswer((_) => Stream.value(mockQuerySnapshot));
      when(
        () =>
            mockCollection.orderBy(any(), descending: any(named: 'descending')),
      ).thenReturn(mockQuery);
      when(
        () => mockCollection.where(any(), whereIn: any(named: 'whereIn')),
      ).thenReturn(mockQuery);
      when(
        () => mockCollection.where(any(), isEqualTo: any(named: 'isEqualTo')),
      ).thenReturn(mockQuery);

      when(
        () => mockQuery.where(any(), whereIn: any(named: 'whereIn')),
      ).thenReturn(mockQuery);
      when(
        () => mockQuery.where(any(), isEqualTo: any(named: 'isEqualTo')),
      ).thenReturn(mockQuery);
      when(
        () =>
            mockQuery.where(any(), isGreaterThan: any(named: 'isGreaterThan')),
      ).thenReturn(mockQuery);
      when(
        () => mockQuery.where(any(), isLessThan: any(named: 'isLessThan')),
      ).thenReturn(mockQuery);
      when(
        () =>
            mockQuery.where(any(), arrayContains: any(named: 'arrayContains')),
      ).thenReturn(mockQuery);
      when(
        () => mockQuery.orderBy(any(), descending: any(named: 'descending')),
      ).thenReturn(mockQuery);
      when(
        () => mockQuery.snapshots(),
      ).thenAnswer((_) => Stream.value(mockQuerySnapshot));

      when(
        () => mockDocument.snapshots(),
      ).thenAnswer((_) => Stream.value(mockDocSnapshot));
      when(() => mockDocument.set(any(), any())).thenAnswer((_) async {});
      when(() => mockDocument.update(any())).thenAnswer((_) async {});

      repository = FirestoreDatabaseRepository(firestore: mockFirestore);
    });

    tearDown(() async {
      if (getIt.isRegistered<CrashService>()) {
        await getIt.unregister<CrashService>();
      }
    });

    group('updateDeviceSettings', () {
      test('does nothing when token is empty', () {
        repository.updateDeviceSettings(
          token: '',
          deviceInfo: const AppDeviceInfo(id: 'id-1'),
          language: const Locale('es', 'ES'),
          teamToModify: 81,
          enabledTeams: const ['81'],
        );

        verifyNever(() => mockFirestore.collection(any()));
      });

      test('sets data with deviceInfo and language', () async {
        repository.updateDeviceSettings(
          token: 'token-123',
          deviceInfo: const AppDeviceInfo(id: 'dev-1', model: 'Galaxy Watch'),
          language: const Locale('es', 'ES'),
        );

        await pumpEventQueue();

        verify(
          () => mockFirestore.collection(AppVariables.devicesCollection),
        ).called(1);
        verify(() => mockCollection.doc('token-123')).called(1);
        verify(() => mockDocument.set(any(), any())).called(1);
      });

      test('does not call set when data is empty', () async {
        repository.updateDeviceSettings(token: 'token-123');

        await pumpEventQueue();

        verifyNever(() => mockDocument.set(any(), any()));
      });

      test('records error in CrashService when set fails', () async {
        final mockCrash = MockCrashService();
        getIt.registerSingleton<CrashService>(mockCrash);
        when(
          () => mockCrash.recordError(
            any<Object>(),
            any<StackTrace?>(),
            reason: any<String>(named: 'reason'),
          ),
        ).thenAnswer((_) async {});

        final exception = Exception('Firestore set failed');
        when(
          () => mockDocument.set(any(), any()),
        ).thenAnswer((_) => Future.error(exception));

        repository.updateDeviceSettings(
          token: 'token-123',
          deviceInfo: const AppDeviceInfo(id: 'dev-1'),
        );

        await pumpEventQueue();

        verify(
          () => mockCrash.recordError(
            exception,
            any<StackTrace?>(),
            reason: 'updateDeviceSettings set error',
          ),
        ).called(1);
      });

      test(
        'does not throw when set fails and CrashService not registered',
        () async {
          when(
            () => mockDocument.set(any(), any()),
          ).thenAnswer((_) => Future.error(Exception('Firestore set failed')));

          expect(
            () => repository.updateDeviceSettings(
              token: 'token-123',
              deviceInfo: const AppDeviceInfo(id: 'dev-1'),
            ),
            returnsNormally,
          );

          await pumpEventQueue();
        },
      );

      test('removes team when enabledTeams contains teamToModify', () async {
        repository.updateDeviceSettings(
          token: 'token-123',
          teamToModify: 81,
          enabledTeams: const ['81', '86'],
        );

        await pumpEventQueue();

        verify(
          () => mockDocument.update({
            'enabledTeams': FieldValue.arrayRemove(['81']),
          }),
        ).called(1);
      });

      test(
        'adds team when enabledTeams does not contain teamToModify',
        () async {
          repository.updateDeviceSettings(
            token: 'token-123',
            teamToModify: 94,
            enabledTeams: const ['81', '86'],
          );

          await pumpEventQueue();

          verify(
            () => mockDocument.update({
              'enabledTeams': FieldValue.arrayUnion(['94']),
            }),
          ).called(1);
        },
      );

      test('does not throw and ignores team modification when enabledTeams is '
          'null', () async {
        expect(
          () => repository.updateDeviceSettings(
            token: 'token-123',
            teamToModify: 94,
          ),
          returnsNormally,
        );

        await pumpEventQueue();

        verifyNever(() => mockDocument.update(any()));
      });

      test(
        'records error in CrashService when arrayRemove update fails',
        () async {
          final mockCrash = MockCrashService();
          getIt.registerSingleton<CrashService>(mockCrash);
          when(
            () => mockCrash.recordError(
              any<Object>(),
              any<StackTrace?>(),
              reason: any<String>(named: 'reason'),
            ),
          ).thenAnswer((_) async {});

          final exception = Exception('Firestore update failed');
          when(
            () => mockDocument.update(any()),
          ).thenAnswer((_) => Future.error(exception));

          repository.updateDeviceSettings(
            token: 'token-123',
            teamToModify: 81,
            enabledTeams: const ['81'],
          );

          await pumpEventQueue();

          verify(
            () => mockCrash.recordError(
              exception,
              any<StackTrace?>(),
              reason: 'updateDeviceSettings arrayRemove error',
            ),
          ).called(1);
        },
      );
    });

    group('getMatchStream', () {
      test('returns mapped Match from snapshot', () async {
        when(
          () => mockDocSnapshot.data(),
        ).thenReturn({'id': 42, 'status': 'FINISHED'});

        final match = await repository.getMatchStream(matchId: 42).first;

        verify(
          () => mockFirestore.collection(AppVariables.matchesCollection),
        ).called(1);
        verify(() => mockCollection.doc('42')).called(1);
        expect(match.id, 42);
        expect(match.status, 'FINISHED');
      });

      test('returns empty Match when snapshot data is null', () async {
        when(() => mockDocSnapshot.data()).thenReturn(null);

        final match = await repository.getMatchStream(matchId: 42).first;

        expect(match, Match.empty);
      });
    });

    group('getMatchesStream', () {
      test('queries with emptyLeague when enabledLeagues is empty', () async {
        when(
          () => mockQueryDocSnapshot.data(),
        ).thenReturn({'id': 101, 'status': 'TIMED'});
        when(() => mockQuerySnapshot.docs).thenReturn([mockQueryDocSnapshot]);

        final matches = await repository
            .getMatchesStream(enabledLeagues: const [])
            .first;

        verify(
          () => mockFirestore.collection(AppVariables.matchesCollection),
        ).called(1);
        verify(
          () => mockCollection.where(
            'competition.code',
            whereIn: [AppVariables.emptyLeague],
          ),
        ).called(1);
        expect(matches.length, 1);
        expect(matches.first.id, 101);
      });

      test('queries with enabledLeagues when not empty', () async {
        when(
          () => mockQueryDocSnapshot.data(),
        ).thenReturn({'id': 202, 'status': 'IN_PLAY'});
        when(() => mockQuerySnapshot.docs).thenReturn([mockQueryDocSnapshot]);

        final matches = await repository
            .getMatchesStream(enabledLeagues: const ['PD', 'CL'])
            .first;

        verify(
          () => mockCollection.where('competition.code', whereIn: ['PD', 'CL']),
        ).called(1);
        expect(matches.length, 1);
        expect(matches.first.id, 202);
      });
    });

    group('getConfigStream', () {
      test('returns mapped Config from snapshot', () async {
        when(() => mockDocSnapshot.data()).thenReturn({
          'id': 'cfg-1',
          'lastUpdate': Timestamp.fromDate(DateTime.utc(2025)),
        });

        final config = await repository.getConfigStream(id: 'cfg-1').first;

        verify(
          () => mockFirestore.collection(AppVariables.configsCollection),
        ).called(1);
        verify(() => mockCollection.doc('cfg-1')).called(1);
        expect(config.id, 'cfg-1');
      });

      test('returns empty Config when snapshot data is null', () async {
        when(() => mockDocSnapshot.data()).thenReturn(null);

        final config = await repository.getConfigStream(id: 'cfg-1').first;

        expect(config, Config.empty);
      });
    });

    group('getLeaguesStream', () {
      test('returns list of mapped Leagues', () async {
        when(
          () => mockQueryDocSnapshot.data(),
        ).thenReturn({'id': 2014, 'name': 'La Liga', 'code': 'PD'});
        when(() => mockQuerySnapshot.docs).thenReturn([mockQueryDocSnapshot]);

        final leagues = await repository.getLeaguesStream().first;

        verify(
          () => mockFirestore.collection(AppVariables.leaguesCollection),
        ).called(1);
        expect(leagues.length, 1);
        expect(leagues.first.id, 2014);
        expect(leagues.first.code, 'PD');
      });
    });

    group('getStandingsStream', () {
      test('returns mapped LeagueStandings from snapshot', () async {
        when(
          () => mockDocSnapshot.data(),
        ).thenReturn({'leagueId': 'PD', 'standings': <Map<String, dynamic>>[]});

        final standings = await repository
            .getStandingsStream(leagueId: 'PD')
            .first;

        verify(
          () => mockFirestore.collection(AppVariables.standingsCollection),
        ).called(1);
        verify(() => mockCollection.doc('PD')).called(1);
        expect(standings.leagueId, 'PD');
      });

      test(
        'returns empty LeagueStandings when snapshot data is null',
        () async {
          when(() => mockDocSnapshot.data()).thenReturn(null);

          final standings = await repository
              .getStandingsStream(leagueId: 'PD')
              .first;

          expect(standings, LeagueStandings.empty);
        },
      );
    });

    group('getTeamStream', () {
      test('returns mapped Team from query', () async {
        when(
          () => mockQueryDocSnapshot.data(),
        ).thenReturn({'id': 81, 'name': 'FC Barcelona'});
        when(() => mockQuerySnapshot.docs).thenReturn([mockQueryDocSnapshot]);

        final team = await repository.getTeamStream(teamId: 81).first;

        verify(
          () => mockFirestore.collection(AppVariables.teamsCollection),
        ).called(1);
        verify(() => mockCollection.where('id', isEqualTo: 81)).called(1);
        expect(team.id, 81);
        expect(team.name, 'FC Barcelona');
      });

      test('returns empty Team when query snapshot has no docs', () async {
        when(() => mockQuerySnapshot.docs).thenReturn([]);

        final team = await repository.getTeamStream(teamId: 81).first;

        expect(team, Team.empty);
      });
    });

    group('getTeamsStream', () {
      test('returns list of Teams without leagueId', () async {
        when(
          () => mockQueryDocSnapshot.data(),
        ).thenReturn({'id': 86, 'name': 'Real Madrid'});
        when(() => mockQuerySnapshot.docs).thenReturn([mockQueryDocSnapshot]);

        final teams = await repository.getTeamsStream().first;

        verify(
          () => mockFirestore.collection(AppVariables.teamsCollection),
        ).called(1);
        verify(() => mockCollection.orderBy('name')).called(1);
        verifyNever(
          () => mockQuery.where(
            'runningCompetitionIds',
            arrayContains: any(named: 'arrayContains'),
          ),
        );
        expect(teams.length, 1);
        expect(teams.first.id, 86);
      });

      test('filters by runningCompetitionIds when leagueId provided', () async {
        when(
          () => mockQueryDocSnapshot.data(),
        ).thenReturn({'id': 81, 'name': 'FC Barcelona'});
        when(() => mockQuerySnapshot.docs).thenReturn([mockQueryDocSnapshot]);

        final teams = await repository.getTeamsStream(leagueId: 2014).first;

        verify(
          () => mockFirestore.collection(AppVariables.teamsCollection),
        ).called(1);
        verify(() => mockCollection.orderBy('name')).called(1);
        verify(
          () => mockQuery.where('runningCompetitionIds', arrayContains: 2014),
        ).called(1);
        expect(teams.length, 1);
        expect(teams.first.id, 81);
      });
    });

    group('getDeviceStream', () {
      test('returns empty stream when token is empty', () async {
        final stream = repository.getDeviceStream(token: '');
        expect(await stream.isEmpty, isTrue);
        verifyNever(() => mockFirestore.collection(any()));
      });

      test(
        'returns mapped Device when snapshot exists and data is not null',
        () async {
          when(() => mockDocSnapshot.exists).thenReturn(true);
          when(() => mockDocSnapshot.data()).thenReturn({
            'token': 'my-token',
            'platform': 'WEAROS',
            'enabledTeams': ['81', '86'],
          });

          final device = await repository
              .getDeviceStream(token: 'my-token')
              .first;

          verify(
            () => mockFirestore.collection(AppVariables.devicesCollection),
          ).called(1);
          verify(() => mockCollection.doc('my-token')).called(1);
          expect(device.token, 'my-token');
          expect(device.enabledTeams, ['81', '86']);
        },
      );

      test('returns Device.empty when snapshot exists is false', () async {
        when(() => mockDocSnapshot.exists).thenReturn(false);
        when(() => mockDocSnapshot.data()).thenReturn(null);

        final device = await repository
            .getDeviceStream(token: 'my-token')
            .first;

        expect(device, Device.empty);
      });

      test('returns Device.empty when snapshot.data() is null', () async {
        when(() => mockDocSnapshot.exists).thenReturn(true);
        when(() => mockDocSnapshot.data()).thenReturn(null);

        final device = await repository
            .getDeviceStream(token: 'my-token')
            .first;

        expect(device, Device.empty);
      });
    });
  });
}
