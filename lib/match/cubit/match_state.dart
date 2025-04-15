part of 'match_cubit.dart';

class MatchState extends Equatable {
  const MatchState({
    this.matchId = 0,
    this.matchesCollection,
    this.configsCollection,
    this.standingsCollection,
  });

  final int matchId;
  final CollectionReference<Map<String, dynamic>>? matchesCollection;
  final CollectionReference<Map<String, dynamic>>? configsCollection;
  final CollectionReference<Map<String, dynamic>>? standingsCollection;

  MatchState copyWith({
    int? matchId,
    CollectionReference<Map<String, dynamic>>? matchesCollection,
    CollectionReference<Map<String, dynamic>>? configsCollection,
    CollectionReference<Map<String, dynamic>>? standingsCollection,
  }) {
    return MatchState(
      matchId: matchId ?? this.matchId,
      matchesCollection: matchesCollection ?? this.matchesCollection,
      configsCollection: configsCollection ?? this.configsCollection,
      standingsCollection: standingsCollection ?? this.standingsCollection,
    );
  }

  @override
  List<Object?> get props => [
        matchId,
        matchesCollection,
        configsCollection,
        standingsCollection,
      ];
}
