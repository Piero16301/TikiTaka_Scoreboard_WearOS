part of 'team_cubit.dart';

class TeamState extends Equatable {
  const TeamState({
    this.teamId = 0,
    this.teamsCollection,
    this.configsCollection,
  });

  final int teamId;
  final CollectionReference<Map<String, dynamic>>? teamsCollection;
  final CollectionReference<Map<String, dynamic>>? configsCollection;

  TeamState copyWith({
    int? teamId,
    CollectionReference<Map<String, dynamic>>? teamsCollection,
    CollectionReference<Map<String, dynamic>>? configsCollection,
  }) {
    return TeamState(
      teamId: teamId ?? this.teamId,
      teamsCollection: teamsCollection ?? this.teamsCollection,
      configsCollection: configsCollection ?? this.configsCollection,
    );
  }

  @override
  List<Object?> get props => [
        teamId,
        teamsCollection,
        configsCollection,
      ];
}
