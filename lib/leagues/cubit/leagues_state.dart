part of 'leagues_cubit.dart';

class LeaguesState extends Equatable {
  const LeaguesState({
    this.leaguesCollection,
    this.enabledLeagues = const <String, bool>{},
  });

  final CollectionReference<Map<String, dynamic>>? leaguesCollection;
  final Map<String, bool> enabledLeagues;

  LeaguesState copyWith({
    CollectionReference<Map<String, dynamic>>? leaguesCollection,
    Map<String, bool>? enabledLeagues,
  }) {
    return LeaguesState(
      leaguesCollection: leaguesCollection ?? this.leaguesCollection,
      enabledLeagues: enabledLeagues ?? this.enabledLeagues,
    );
  }

  @override
  List<Object?> get props => [
        leaguesCollection,
        enabledLeagues,
      ];
}
