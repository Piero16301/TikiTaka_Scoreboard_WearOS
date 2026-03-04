import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';
import 'package:tiki_taka_scoreboard_wearos/leagues/cubit/leagues_cubit.dart';

class MockLocalStorageService extends Mock implements LocalStorageService {}

void main() {
  group('LeaguesCubit', () {
    late LocalStorageService localStorageService;

    setUp(() {
      localStorageService = MockLocalStorageService();
      getIt.registerSingleton<LocalStorageService>(localStorageService);
    });

    tearDown(getIt.reset);

    test('initial state has empty enabledLeagues', () {
      expect(LeaguesCubit().state.enabledLeagues, isEmpty);
    });

    blocTest<LeaguesCubit, LeaguesState>(
      'emits correct state when initialize is called and localStorage '
      'has leagues',
      setUp: () {
        when(() => localStorageService.getEnabledLeagues())
            .thenReturn(['PL', 'LL']);
      },
      build: LeaguesCubit.new,
      act: (cubit) => cubit.initialize(),
      expect: () => [
        const LeaguesState(enabledLeagues: {'PL': true, 'LL': true}),
      ],
      verify: (_) {
        verify(() => localStorageService.getEnabledLeagues()).called(1);
      },
    );

    blocTest<LeaguesCubit, LeaguesState>(
      'emits correct state when toggleLeague is called successfully',
      build: LeaguesCubit.new,
      seed: () => const LeaguesState(enabledLeagues: {'PL': true}),
      setUp: () {
        when(
          () => localStorageService.saveEnabledLeague(
            league: 'LL',
            enabled: true,
          ),
        ).thenReturn(null);
      },
      act: (cubit) => cubit.toggleLeague(league: 'LL', enabled: true),
      expect: () => [
        const LeaguesState(enabledLeagues: {'PL': true, 'LL': true}),
      ],
    );

    blocTest<LeaguesCubit, LeaguesState>(
      'emits correct state when toggleLeague throws exception',
      build: LeaguesCubit.new,
      seed: () => const LeaguesState(enabledLeagues: {'PL': true}),
      setUp: () {
        when(
          () => localStorageService.saveEnabledLeague(
            league: 'LL',
            enabled: true,
          ),
        ).thenThrow(Exception('Error'));
      },
      act: (cubit) => cubit.toggleLeague(league: 'LL', enabled: true),
      expect: () => [
        const LeaguesState(enabledLeagues: {'PL': true, 'LL': false}),
      ],
    );
  });
}
