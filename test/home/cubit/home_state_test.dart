import 'package:flutter_test/flutter_test.dart';
import 'package:tiki_taka_scoreboard_wearos/home/cubit/home_cubit.dart';

void main() {
  group('HomeState', () {
    test('supports value equality', () {
      expect(
        const HomeState(),
        const HomeState(),
      );
    });

    test('copyWith works properly', () {
      const state = HomeState();
      final newState = state.copyWith(reload: true);

      expect(newState.reload, isTrue);
    });

    test('copyWith does not change if properties are null', () {
      const state = HomeState();
      final newState = state.copyWith();

      expect(newState, state);
    });
  });
}
