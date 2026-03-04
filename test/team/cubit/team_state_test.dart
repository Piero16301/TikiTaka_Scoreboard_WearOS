import 'package:flutter_test/flutter_test.dart';
import 'package:tiki_taka_scoreboard_wearos/team/cubit/team_cubit.dart';

void main() {
  group('TeamState', () {
    test('supports value equality', () {
      expect(
        const TeamState(),
        const TeamState(),
      );
    });

    test('copyWith works properly', () {
      const state = TeamState();
      final newState = state.copyWith(teamId: 42);

      expect(newState.teamId, 42);
    });

    test('copyWith does not change if properties are null', () {
      const state = TeamState();
      final newState = state.copyWith();

      expect(newState, state);
    });
  });
}
