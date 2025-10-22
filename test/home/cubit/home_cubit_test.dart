import 'package:bloc_test/bloc_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';
import 'package:tiki_taka_scoreboard_wearos/home/cubit/home_cubit.dart';
import 'package:user_repository/user_repository.dart';

import '../../helpers/mock_firebase_platform.dart';
import 'home_cubit_test.mocks.dart';

@GenerateMocks([UserRepository])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('HomeCubit', () {
    late UserRepository userRepository;
    late FakeFirebaseFirestore fakeFirestore;

    setUpAll(() async {
      await setupFirebaseCoreMocks();
      await Firebase.initializeApp();
    });

    setUp(() {
      userRepository = MockUserRepository();
      fakeFirestore = FakeFirebaseFirestore();
    });

    test('initial state has default values', () {
      final cubit = HomeCubit(userRepository);

      expect(cubit.state, const HomeState());
      expect(cubit.state.matchesCollection, isNull);
      expect(cubit.state.configsCollection, isNull);
      expect(cubit.state.reload, false);
    });

    group('initCollections', () {
      blocTest<HomeCubit, HomeState>(
        'emits state with initialized collections',
        build: () => HomeCubit(userRepository),
        act: (cubit) => cubit.initCollections(),
        expect: () => [
          predicate<HomeState>(
            (state) =>
                state.matchesCollection != null &&
                state.configsCollection != null,
          ),
        ],
      );
    });

    group('reload', () {
      blocTest<HomeCubit, HomeState>(
        'emits state with reload set to true by default',
        build: () => HomeCubit(userRepository),
        act: (cubit) => cubit.reload(),
        expect: () => [
          const HomeState(reload: true),
        ],
      );

      blocTest<HomeCubit, HomeState>(
        'emits state with reload set to false when specified',
        build: () => HomeCubit(userRepository),
        act: (cubit) => cubit.reload(value: false),
        expect: () => [
          const HomeState(),
        ],
      );
    });

    group('getMatchConfigs', () {
      test('returns null when configsCollection is not initialized', () {
        final cubit = HomeCubit(userRepository);

        final result = cubit.getMatchConfigs();

        expect(result, isNull);
      });

      test(
        'returns stream with correct query when configsCollection exists',
        () async {
          await fakeFirestore.collection(configsCollection).doc('config1').set({
            'id': matchesCollection,
            'lastUpdate': '2025-10-22T10:00:00Z',
          });

          await fakeFirestore.collection(configsCollection).doc('config2').set({
            'id': 'otherCollection',
            'lastUpdate': '2025-10-22T11:00:00Z',
          });

          final cubit = HomeCubit(userRepository);
          final state = cubit.state.copyWith(
            configsCollection: fakeFirestore.collection(configsCollection),
          );
          cubit.emit(state);

          final stream = cubit.getMatchConfigs();

          expect(stream, isNotNull);

          final snapshot = await stream!.first;

          expect(snapshot.docs.length, 1);
          expect(snapshot.docs.first.data()['id'], matchesCollection);
        },
      );

      test('returns empty stream when no matching configs exist', () async {
        await fakeFirestore.collection(configsCollection).doc('config1').set({
          'id': 'otherCollection',
          'lastUpdate': '2025-10-22T10:00:00Z',
        });

        final cubit = HomeCubit(userRepository);
        final state = cubit.state.copyWith(
          configsCollection: fakeFirestore.collection(configsCollection),
        );
        cubit.emit(state);

        final stream = cubit.getMatchConfigs();

        expect(stream, isNotNull);

        final snapshot = await stream!.first;

        expect(snapshot.docs.length, 0);
      });

      test('stream emits updates when new matching config is added', () async {
        final cubit = HomeCubit(userRepository);
        final state = cubit.state.copyWith(
          configsCollection: fakeFirestore.collection(configsCollection),
        );
        cubit.emit(state);

        await fakeFirestore.collection(configsCollection).doc('config1').set({
          'id': matchesCollection,
          'lastUpdate': '2025-10-22T10:00:00Z',
        });

        final stream = cubit.getMatchConfigs();
        expect(stream, isNotNull);

        final snapshot = await stream!.first;

        expect(snapshot.docs.length, 1);
        expect(snapshot.docs.first.data()['id'], matchesCollection);
      });
    });

    group('getMatches', () {
      test('returns null when matchesCollection is not initialized', () {
        when(userRepository.getEnabledLeagues()).thenReturn(['PL', 'PD']);
        final cubit = HomeCubit(userRepository);

        final result = cubit.getMatches();

        expect(result, isNull);
      });

      test('uses emptyLeague when no enabled leagues exist', () async {
        when(userRepository.getEnabledLeagues()).thenReturn([]);

        final cubit = HomeCubit(userRepository);
        final state = cubit.state.copyWith(
          matchesCollection: fakeFirestore.collection(matchesCollection),
        );
        cubit.emit(state);

        final stream = cubit.getMatches();

        expect(stream, isNotNull);
        verify(userRepository.getEnabledLeagues()).called(1);
      });

      test('queries with enabled leagues when available', () async {
        when(userRepository.getEnabledLeagues()).thenReturn(['PL', 'PD']);

        final now = DateTime.now();
        await fakeFirestore.collection(matchesCollection).doc('match1').set({
          'competition': {'code': 'PL'},
          'utcDate': DateTime(
            now.year,
            now.month,
            now.day,
            15,
          ).toIso8601String(),
        });

        final cubit = HomeCubit(userRepository);
        final state = cubit.state.copyWith(
          matchesCollection: fakeFirestore.collection(matchesCollection),
        );
        cubit.emit(state);

        final stream = cubit.getMatches();

        expect(stream, isNotNull);
        verify(userRepository.getEnabledLeagues()).called(1);
      });
    });
  });
}
