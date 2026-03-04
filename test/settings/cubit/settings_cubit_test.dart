import 'package:flutter_test/flutter_test.dart';
import 'package:tiki_taka_scoreboard_wearos/settings/cubit/settings_cubit.dart';

void main() {
  group('SettingsCubit', () {
    test('initial state is SettingsState()', () {
      expect(SettingsCubit().state, const SettingsState());
    });
  });
}
