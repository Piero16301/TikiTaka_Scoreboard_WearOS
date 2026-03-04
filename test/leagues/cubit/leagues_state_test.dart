import 'package:flutter_test/flutter_test.dart';
import 'package:tiki_taka_scoreboard_wearos/leagues/cubit/leagues_cubit.dart';

void main() {
  group('LeaguesState', () {
    test('supports value equality', () {
      expect(
        const LeaguesState(),
        const LeaguesState(),
      );
    });

    test('copyWith works properly', () {
      const state = LeaguesState();
      final newState = state.copyWith(enabledLeagues: {'PL': true});

      expect(newState.enabledLeagues, {'PL': true});
    });

    test('copyWith does not change if properties are null', () {
      const state = LeaguesState();
      final newState = state.copyWith();

      expect(newState, state);
    });
  });
}
