import 'package:flutter_test/flutter_test.dart';
import 'package:tiki_taka_scoreboard_wearos/notifications/cubit/notifications_cubit.dart';

void main() {
  group('NotificationsState', () {
    test('supports value equality', () {
      expect(
        const NotificationsState(),
        const NotificationsState(),
      );
    });

    test('copyWith works properly', () {
      const state = NotificationsState();
      final newState = state.copyWith();

      expect(newState, state);
    });
  });
}
