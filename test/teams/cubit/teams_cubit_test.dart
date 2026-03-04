import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';
import 'package:tiki_taka_scoreboard_wearos/teams/cubit/teams_cubit.dart';

class MockNotificationService extends Mock implements NotificationService {}

void main() {
  group('TeamsCubit', () {
    late NotificationService notificationService;

    setUp(() {
      notificationService = MockNotificationService();
      getIt.registerSingleton<NotificationService>(notificationService);
    });

    tearDown(getIt.reset);

    test('initial state has leagueId 0', () {
      expect(TeamsCubit().state.leagueId, 0);
    });

    blocTest<TeamsCubit, TeamsState>(
      'emits correct state when initialize is called',
      build: TeamsCubit.new,
      act: (cubit) => cubit.initialize(leagueId: 42),
      expect: () => [
        const TeamsState(leagueId: 42),
      ],
    );
  });
}
