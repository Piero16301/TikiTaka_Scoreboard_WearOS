import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';
import 'package:tiki_taka_scoreboard_wearos/home/cubit/home_cubit.dart';

class MockLocalStorageService extends Mock implements LocalStorageService {}

void main() {
  group('HomeCubit', () {
    late LocalStorageService localStorageService;

    setUp(() {
      localStorageService = MockLocalStorageService();
      getIt.registerSingleton<LocalStorageService>(localStorageService);
    });

    tearDown(getIt.reset);

    test('initial state has reload false', () {
      expect(HomeCubit().state.reload, isFalse);
    });

    blocTest<HomeCubit, HomeState>(
      'emits correct state when reload is called with no args',
      build: HomeCubit.new,
      act: (cubit) => cubit.reload(),
      expect: () => [
        const HomeState(reload: true),
      ],
    );

    blocTest<HomeCubit, HomeState>(
      'emits correct state when reload is called with false',
      build: HomeCubit.new,
      act: (cubit) => cubit.reload(value: false),
      expect: () => [
        const HomeState(),
      ],
    );
  });
}
