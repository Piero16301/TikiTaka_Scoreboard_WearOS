import 'package:flutter_test/flutter_test.dart';
import 'package:tiki_taka_scoreboard_wearos/settings/cubit/settings_cubit.dart';

void main() {
  group('SettingsState', () {
    test('supports value equality', () {
      expect(
        const SettingsState(),
        const SettingsState(),
      );
    });

    test('copyWith works properly', () {
      const state = SettingsState();
      final newState = state.copyWith(status: SettingsStatus.failure);

      expect(newState.status, SettingsStatus.failure);
    });

    test('copyWith does not change if properties are null', () {
      const state = SettingsState();
      final newState = state.copyWith();

      expect(newState, state);
    });

    test('SettingsStatus enum getters work correctly', () {
      expect(SettingsStatus.initial.isInitial, isTrue);
      expect(SettingsStatus.initial.isLoading, isFalse);

      expect(SettingsStatus.loading.isLoading, isTrue);
      expect(SettingsStatus.loading.isInitial, isFalse);

      expect(SettingsStatus.success.isSuccess, isTrue);
      expect(SettingsStatus.success.isFailure, isFalse);

      expect(SettingsStatus.failure.isFailure, isTrue);
      expect(SettingsStatus.failure.isSuccess, isFalse);
    });
  });
}
