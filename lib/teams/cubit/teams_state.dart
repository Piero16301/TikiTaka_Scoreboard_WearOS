part of 'teams_cubit.dart';

class TeamsState extends Equatable {
  const TeamsState({
    this.leagueId = 0,
  });

  final int leagueId;

  TeamsState copyWith({
    int? leagueId,
  }) {
    return TeamsState(
      leagueId: leagueId ?? this.leagueId,
    );
  }

  @override
  List<Object> get props => [
    leagueId,
  ];
}
