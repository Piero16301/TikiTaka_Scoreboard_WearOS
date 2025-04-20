part of 'teams_cubit.dart';

class TeamsState extends Equatable {
  const TeamsState({
    this.leagueId = 0,
    this.teamsCollection,
    this.enabledTeams = const <String, bool>{},
  });

  final int leagueId;
  final CollectionReference<Map<String, dynamic>>? teamsCollection;
  final Map<String, bool> enabledTeams;

  TeamsState copyWith({
    int? leagueId,
    CollectionReference<Map<String, dynamic>>? teamsCollection,
    Map<String, bool>? enabledTeams,
  }) {
    return TeamsState(
      leagueId: leagueId ?? this.leagueId,
      teamsCollection: teamsCollection ?? this.teamsCollection,
      enabledTeams: enabledTeams ?? this.enabledTeams,
    );
  }

  @override
  List<Object?> get props => [
        leagueId,
        teamsCollection,
        enabledTeams,
      ];
}
