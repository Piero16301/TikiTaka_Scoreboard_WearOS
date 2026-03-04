import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tiki_taka_scoreboard_wearos/team/cubit/team_cubit.dart';

void main() {
  group('TeamCubit', () {
    test('initial state has teamId 0', () {
      expect(TeamCubit().state.teamId, 0);
    });

    blocTest<TeamCubit, TeamState>(
      'emits correct state when initialize is called',
      build: TeamCubit.new,
      act: (cubit) => cubit.initialize(teamId: 42),
      expect: () => [
        const TeamState(teamId: 42),
      ],
    );
  });
}
