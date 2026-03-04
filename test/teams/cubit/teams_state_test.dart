import 'package:flutter_test/flutter_test.dart';
import 'package:tiki_taka_scoreboard_wearos/teams/cubit/teams_cubit.dart';

void main() {
  group('TeamsState', () {
    test('supports value equality', () {
      expect(
        const TeamsState(),
        const TeamsState(),
      );
    });

    test('copyWith works properly', () {
      const state = TeamsState();
      final newState = state.copyWith(leagueId: 42);

      expect(newState.leagueId, 42);
    });

    test('copyWith does not change if properties are null', () {
      const state = TeamsState();
      final newState = state.copyWith();

      expect(newState, state);
    });
  });
}
