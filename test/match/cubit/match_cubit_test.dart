import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tiki_taka_scoreboard_wearos/match/cubit/match_cubit.dart';

void main() {
  group('MatchCubit', () {
    test('initial state has matchId 0', () {
      expect(MatchCubit().state.matchId, 0);
    });

    blocTest<MatchCubit, MatchState>(
      'emits correct state when initialize is called',
      build: MatchCubit.new,
      act: (cubit) => cubit.initialize(matchId: 42),
      expect: () => [
        const MatchState(matchId: 42),
      ],
    );
  });
}
