part of 'match_cubit.dart';

class MatchState extends Equatable {
  const MatchState({
    this.match = Match.empty,
    this.standingsCollection,
  });

  final Match match;
  final CollectionReference<Map<String, dynamic>>? standingsCollection;

  MatchState copyWith({
    Match? match,
    CollectionReference<Map<String, dynamic>>? standingsCollection,
  }) {
    return MatchState(
      match: match ?? this.match,
      standingsCollection: standingsCollection ?? this.standingsCollection,
    );
  }

  @override
  List<Object?> get props => [
        match,
        standingsCollection,
      ];
}
