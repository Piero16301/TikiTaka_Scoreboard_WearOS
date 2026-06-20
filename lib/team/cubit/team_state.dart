part of 'team_cubit.dart';

class TeamState extends Equatable {
  const TeamState({
    this.teamId = 0,
  });

  final int teamId;

  TeamState copyWith({
    int? teamId,
  }) {
    return TeamState(
      teamId: teamId ?? this.teamId,
    );
  }

  @override
  List<Object> get props => [
    teamId,
  ];
}
