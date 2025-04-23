part of 'teams_cubit.dart';

class TeamsState extends Equatable {
  const TeamsState({
    this.leagueId = 0,
    this.teamsCollection,
    this.notDevicesCollection,
  });

  final int leagueId;
  final CollectionReference<Map<String, dynamic>>? teamsCollection;
  final CollectionReference<Map<String, dynamic>>? notDevicesCollection;

  TeamsState copyWith({
    int? leagueId,
    CollectionReference<Map<String, dynamic>>? teamsCollection,
    CollectionReference<Map<String, dynamic>>? notDevicesCollection,
  }) {
    return TeamsState(
      leagueId: leagueId ?? this.leagueId,
      teamsCollection: teamsCollection ?? this.teamsCollection,
      notDevicesCollection: notDevicesCollection ?? this.notDevicesCollection,
    );
  }

  @override
  List<Object?> get props => [
        leagueId,
        teamsCollection,
        notDevicesCollection,
      ];
}
