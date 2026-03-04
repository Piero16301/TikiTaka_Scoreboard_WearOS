import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tiki_taka_scoreboard_wearos/app/cubit/app_cubit.dart';

void main() {
  group('AppState', () {
    test('supports value equality', () {
      expect(
        const AppState(),
        const AppState(),
      );
    });

    test('copyWith works properly', () {
      const state = AppState();
      final newState = state.copyWith(
        language: const Locale('es', 'ES'),
        baseColor: Colors.red,
        fontFamily: 'Roboto',
      );

      expect(newState.language, const Locale('es', 'ES'));
      expect(newState.baseColor, Colors.red);
      expect(newState.fontFamily, 'Roboto');
    });

    test('copyWith does not change if properties are null', () {
      const state = AppState();
      final newState = state.copyWith();

      expect(newState, state);
    });
  });
}
