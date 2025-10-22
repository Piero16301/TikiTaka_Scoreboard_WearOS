import 'package:bloc_test/bloc_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tiki_taka_scoreboard_wearos/leagues/cubit/leagues_cubit.dart';
import 'package:user_repository/user_repository.dart';

import '../../helpers/mock_firebase_platform.dart';
import 'leagues_cubit_test.mocks.dart';

@GenerateMocks([UserRepository])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LeaguesCubit', () {
    late UserRepository userRepository;

    setUpAll(() async {
      await setupFirebaseCoreMocks();
      await Firebase.initializeApp();
    });

    setUp(() {
      userRepository = MockUserRepository();
    });

    test('initial state has default values', () {
      final cubit = LeaguesCubit(userRepository);

      expect(cubit.state, const LeaguesState());
      expect(cubit.state.leaguesCollection, isNull);
      expect(cubit.state.enabledLeagues, isEmpty);
    });

    group('LeaguesState', () {
      test('copyWith returns same instance when no parameters provided', () {
        const state = LeaguesState(
          enabledLeagues: {'premier-league': true},
        );

        final newState = state.copyWith();

        expect(newState.leaguesCollection, state.leaguesCollection);
        expect(newState.enabledLeagues, state.enabledLeagues);
      });

      test('copyWith updates only provided parameters', () {
        const state = LeaguesState(
          enabledLeagues: {'premier-league': true},
        );

        final newState = state.copyWith(
          enabledLeagues: {'la-liga': false},
        );

        expect(newState.leaguesCollection, state.leaguesCollection);
        expect(newState.enabledLeagues, {'la-liga': false});
      });

      test('supports value equality', () {
        const state1 = LeaguesState(
          enabledLeagues: {'premier-league': true},
        );

        const state2 = LeaguesState(
          enabledLeagues: {'premier-league': true},
        );

        expect(state1, equals(state2));
      });
    });

    group('initCollections', () {
      blocTest<LeaguesCubit, LeaguesState>(
        'emits state with leagues collection and empty enabled leagues '
        'when no leagues are enabled',
        setUp: () {
          when(userRepository.getEnabledLeagues()).thenReturn([]);
        },
        build: () => LeaguesCubit(userRepository),
        act: (cubit) => cubit.initCollections(),
        expect: () => [
          isA<LeaguesState>()
              .having(
                (s) => s.leaguesCollection,
                'leaguesCollection',
                isNotNull,
              )
              .having(
                (s) => s.enabledLeagues,
                'enabledLeagues',
                isEmpty,
              ),
        ],
        verify: (_) {
          verify(userRepository.getEnabledLeagues()).called(1);
        },
      );

      blocTest<LeaguesCubit, LeaguesState>(
        'emits state with enabled leagues when leagues are returned',
        setUp: () {
          when(userRepository.getEnabledLeagues()).thenReturn([
            'premier-league',
            'la-liga',
            'serie-a',
          ]);
        },
        build: () => LeaguesCubit(userRepository),
        act: (cubit) => cubit.initCollections(),
        expect: () => [
          isA<LeaguesState>()
              .having(
                (s) => s.leaguesCollection,
                'leaguesCollection',
                isNotNull,
              )
              .having(
                (s) => s.enabledLeagues,
                'enabledLeagues',
                {
                  'premier-league': true,
                  'la-liga': true,
                  'serie-a': true,
                },
              ),
        ],
        verify: (_) {
          verify(userRepository.getEnabledLeagues()).called(1);
        },
      );
    });

    group('getLeagues', () {
      test('returns null when leaguesCollection is null', () {
        final cubit = LeaguesCubit(userRepository);

        final result = cubit.getLeagues();

        expect(result, isNull);
      });

      test(
        'returns snapshots stream when leaguesCollection is initialized',
        () async {
          when(userRepository.getEnabledLeagues()).thenReturn([]);

          final cubit = LeaguesCubit(userRepository)..initCollections();

          final result = cubit.getLeagues();

          expect(result, isNotNull);
          expect(result, isA<Stream<QuerySnapshot<Map<String, dynamic>>>>());
        },
      );
    });

    group('toggleLeague', () {
      blocTest<LeaguesCubit, LeaguesState>(
        'emits state with league enabled and saves to repository',
        setUp: () {
          when(userRepository.getEnabledLeagues()).thenReturn([]);
          when(
            userRepository.saveEnabledLeague(
              league: 'premier-league',
              enabled: true,
            ),
          ).thenAnswer((_) async {});
        },
        build: () => LeaguesCubit(userRepository),
        seed: () => const LeaguesState(),
        act: (cubit) => cubit.toggleLeague(
          league: 'premier-league',
          enabled: true,
        ),
        expect: () => [
          const LeaguesState(
            enabledLeagues: {'premier-league': true},
          ),
        ],
        verify: (_) {
          verify(
            userRepository.saveEnabledLeague(
              league: 'premier-league',
              enabled: true,
            ),
          ).called(1);
        },
      );

      blocTest<LeaguesCubit, LeaguesState>(
        'emits state with league disabled and saves to repository',
        setUp: () {
          when(userRepository.getEnabledLeagues()).thenReturn([]);
          when(
            userRepository.saveEnabledLeague(
              league: 'premier-league',
              enabled: false,
            ),
          ).thenAnswer((_) async {});
        },
        build: () => LeaguesCubit(userRepository),
        seed: () => const LeaguesState(
          enabledLeagues: {'premier-league': true},
        ),
        act: (cubit) => cubit.toggleLeague(
          league: 'premier-league',
          enabled: false,
        ),
        expect: () => [
          const LeaguesState(
            enabledLeagues: {'premier-league': false},
          ),
        ],
        verify: (_) {
          verify(
            userRepository.saveEnabledLeague(
              league: 'premier-league',
              enabled: false,
            ),
          ).called(1);
        },
      );

      blocTest<LeaguesCubit, LeaguesState>(
        'emits state with updated league when toggling multiple leagues',
        setUp: () {
          when(userRepository.getEnabledLeagues()).thenReturn([]);
          when(
            userRepository.saveEnabledLeague(
              league: 'la-liga',
              enabled: true,
            ),
          ).thenAnswer((_) async {});
        },
        build: () => LeaguesCubit(userRepository),
        seed: () => const LeaguesState(
          enabledLeagues: {
            'premier-league': true,
            'la-liga': false,
          },
        ),
        act: (cubit) => cubit.toggleLeague(
          league: 'la-liga',
          enabled: true,
        ),
        expect: () => [
          const LeaguesState(
            enabledLeagues: {
              'premier-league': true,
              'la-liga': true,
            },
          ),
        ],
        verify: (_) {
          verify(
            userRepository.saveEnabledLeague(
              league: 'la-liga',
              enabled: true,
            ),
          ).called(1);
        },
      );

      blocTest<LeaguesCubit, LeaguesState>(
        'reverts state when saveEnabledLeague throws exception',
        setUp: () {
          when(userRepository.getEnabledLeagues()).thenReturn([]);
          when(
            userRepository.saveEnabledLeague(
              league: 'premier-league',
              enabled: true,
            ),
          ).thenThrow(Exception('Failed to save'));
        },
        build: () => LeaguesCubit(userRepository),
        seed: () => const LeaguesState(
          enabledLeagues: {'premier-league': false},
        ),
        act: (cubit) => cubit.toggleLeague(
          league: 'premier-league',
          enabled: true,
        ),
        expect: () => [
          const LeaguesState(
            enabledLeagues: {'premier-league': true},
          ),
          const LeaguesState(
            enabledLeagues: {'premier-league': false},
          ),
        ],
        verify: (_) {
          verify(
            userRepository.saveEnabledLeague(
              league: 'premier-league',
              enabled: true,
            ),
          ).called(1);
        },
      );

      blocTest<LeaguesCubit, LeaguesState>(
        'reverts state when saveEnabledLeague throws exception (disable case)',
        setUp: () {
          when(userRepository.getEnabledLeagues()).thenReturn([]);
          when(
            userRepository.saveEnabledLeague(
              league: 'la-liga',
              enabled: false,
            ),
          ).thenThrow(Exception('Failed to save'));
        },
        build: () => LeaguesCubit(userRepository),
        seed: () => const LeaguesState(
          enabledLeagues: {'la-liga': true},
        ),
        act: (cubit) => cubit.toggleLeague(
          league: 'la-liga',
          enabled: false,
        ),
        expect: () => [
          const LeaguesState(
            enabledLeagues: {'la-liga': false},
          ),
          const LeaguesState(
            enabledLeagues: {'la-liga': true},
          ),
        ],
        verify: (_) {
          verify(
            userRepository.saveEnabledLeague(
              league: 'la-liga',
              enabled: false,
            ),
          ).called(1);
        },
      );
    });
  });
}
