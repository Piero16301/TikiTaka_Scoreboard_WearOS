import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tiki_taka_scoreboard_wearos/app/cubit/app_cubit.dart';
import 'package:user_repository/user_repository.dart';

import '../../helpers/mock_firebase_platform.dart';
import 'app_cubit_test.mocks.dart';

@GenerateMocks([UserRepository])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AppCubit', () {
    late UserRepository userRepository;

    setUpAll(() async {
      await setupFirebaseCoreMocks();
      await Firebase.initializeApp();
    });

    setUp(() {
      userRepository = MockUserRepository();
    });

    test('initial state has default values', () {
      final cubit = AppCubit(userRepository);

      expect(cubit.state, const AppState());
      expect(cubit.state.baseColor, 'INDIGO');
      expect(cubit.state.language, 'en_US');
    });

    group('initialLoad', () {
      blocTest<AppCubit, AppState>(
        'emits state with saved baseColor and language when both exist',
        setUp: () {
          when(userRepository.getBaseColor()).thenReturn('BLUE');
          when(userRepository.getLanguage()).thenReturn('es_ES');
        },
        build: () => AppCubit(userRepository),
        act: (cubit) => cubit.initialLoad(),
        expect: () => [
          const AppState(
            baseColor: 'BLUE',
            language: 'es_ES',
          ),
        ],
        verify: (_) {
          verify(userRepository.getBaseColor()).called(2);
          verify(userRepository.getLanguage()).called(2);
        },
      );

      blocTest<AppCubit, AppState>(
        'saves and emits default baseColor when baseColor is null',
        setUp: () {
          when(userRepository.getBaseColor()).thenReturn(null);
          when(userRepository.getLanguage()).thenReturn('en_US');
          when(
            userRepository.saveBaseColor(),
          ).thenAnswer((_) async {});
        },
        build: () => AppCubit(userRepository),
        act: (cubit) => cubit.initialLoad(),
        expect: () => [
          const AppState(),
        ],
        verify: (_) {
          verify(
            userRepository.saveBaseColor(),
          ).called(1);
        },
      );

      blocTest<AppCubit, AppState>(
        'saves and emits default language when language is null',
        setUp: () {
          when(userRepository.getBaseColor()).thenReturn('INDIGO');
          when(userRepository.getLanguage()).thenReturn(null);
          when(
            userRepository.saveLanguage(language: 'en_US'),
          ).thenAnswer((_) async {});
        },
        build: () => AppCubit(userRepository),
        act: (cubit) => cubit.initialLoad(),
        expect: () => [
          const AppState(),
        ],
        verify: (_) {
          verify(
            userRepository.saveLanguage(language: 'en_US'),
          ).called(1);
        },
      );

      blocTest<AppCubit, AppState>(
        'saves both defaults when both baseColor and language are null',
        setUp: () {
          when(userRepository.getBaseColor()).thenReturn(null);
          when(userRepository.getLanguage()).thenReturn(null);
          when(
            userRepository.saveBaseColor(),
          ).thenAnswer((_) async {});
          when(
            userRepository.saveLanguage(language: 'en_US'),
          ).thenAnswer((_) async {});
        },
        build: () => AppCubit(userRepository),
        act: (cubit) => cubit.initialLoad(),
        expect: () => [
          const AppState(),
        ],
        verify: (_) {
          verify(
            userRepository.saveBaseColor(),
          ).called(1);
          verify(
            userRepository.saveLanguage(language: 'en_US'),
          ).called(1);
        },
      );
    });

    group('changeBaseColor', () {
      blocTest<AppCubit, AppState>(
        'saves baseColor to repository and emits new state',
        setUp: () {
          when(
            userRepository.saveBaseColor(baseColor: 'RED'),
          ).thenAnswer((_) async {});
        },
        build: () => AppCubit(userRepository),
        act: (cubit) => cubit.changeBaseColor('RED'),
        expect: () => [
          const AppState(baseColor: 'RED'),
        ],
        errors: () => [
          isA<ArgumentError>(),
        ],
        verify: (_) {
          verify(
            userRepository.saveBaseColor(baseColor: 'RED'),
          ).called(1);
        },
      );
    });

    group('changeLanguage', () {
      blocTest<AppCubit, AppState>(
        'saves language to repository and emits new state',
        setUp: () {
          when(
            userRepository.saveLanguage(),
          ).thenAnswer((_) async {});
        },
        build: () => AppCubit(userRepository),
        act: (cubit) => cubit.changeLanguage('es_ES'),
        expect: () => [
          const AppState(language: 'es_ES'),
        ],
        errors: () => [
          isA<ArgumentError>(),
        ],
        verify: (_) {
          verify(
            userRepository.saveLanguage(),
          ).called(1);
        },
      );
    });

    group('AppState', () {
      test('supports value equality', () {
        const state1 = AppState(baseColor: 'BLUE', language: 'es_ES');
        const state2 = AppState(baseColor: 'BLUE', language: 'es_ES');
        const state3 = AppState(baseColor: 'RED', language: 'es_ES');

        expect(state1, equals(state2));
        expect(state1, isNot(equals(state3)));
      });

      test('copyWith returns new instance with updated values', () {
        const state = AppState();
        final newState = state.copyWith(baseColor: 'PURPLE');

        expect(newState.baseColor, 'PURPLE');
        expect(newState.language, 'en_US');
        expect(newState, isNot(same(state)));
      });

      test('copyWith preserves old values when null is passed', () {
        const state = AppState(baseColor: 'ORANGE', language: 'it_IT');
        final newState = state.copyWith();

        expect(newState.baseColor, 'ORANGE');
        expect(newState.language, 'it_IT');
      });

      test('props contains all fields', () {
        const state = AppState();

        expect(state.props, [
          'INDIGO',
          'en_US',
        ]);
      });
    });
  });
}
