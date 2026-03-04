import 'package:flutter_test/flutter_test.dart';
import 'package:tiki_taka_scoreboard_wearos/match/cubit/match_cubit.dart';

void main() {
  group('MatchState', () {
    test('supports value equality', () {
      expect(
        const MatchState(),
        const MatchState(),
      );
    });

    test('copyWith works properly', () {
      const state = MatchState();
      final newState = state.copyWith(matchId: 42);

      expect(newState.matchId, 42);
    });

    test('copyWith does not change if properties are null', () {
      const state = MatchState();
      final newState = state.copyWith();

      expect(newState, state);
    });
  });
}
