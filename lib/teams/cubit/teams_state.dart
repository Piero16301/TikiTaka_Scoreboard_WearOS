part of 'teams_cubit.dart';

class TeamsState extends Equatable {
  const TeamsState({
    this.leagueId = 0,
    this.teamsCollection,
    this.devicesCollection,
  });

  final int leagueId;
  final CollectionReference<Map<String, dynamic>>? teamsCollection;
  final CollectionReference<Map<String, dynamic>>? devicesCollection;

  TeamsState copyWith({
    int? leagueId,
    CollectionReference<Map<String, dynamic>>? teamsCollection,
    CollectionReference<Map<String, dynamic>>? devicesCollection,
  }) {
    return TeamsState(
      leagueId: leagueId ?? this.leagueId,
      teamsCollection: teamsCollection ?? this.teamsCollection,
      devicesCollection: devicesCollection ?? this.devicesCollection,
    );
  }

  @override
  List<Object?> get props => [
        leagueId,
        teamsCollection,
        devicesCollection,
      ];
}
