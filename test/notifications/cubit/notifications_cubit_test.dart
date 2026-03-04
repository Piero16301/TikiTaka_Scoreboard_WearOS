import 'package:flutter_test/flutter_test.dart';
import 'package:tiki_taka_scoreboard_wearos/notifications/cubit/notifications_cubit.dart';

void main() {
  group('NotificationsCubit', () {
    test('initial state is NotificationsState()', () {
      expect(NotificationsCubit().state, const NotificationsState());
    });
  });
}
