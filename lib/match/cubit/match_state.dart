part of 'match_cubit.dart';

class MatchState extends Equatable {
  const MatchState({
    this.matchId = 0,
  });

  final int matchId;

  MatchState copyWith({
    int? matchId,
  }) {
    return MatchState(
      matchId: matchId ?? this.matchId,
    );
  }

  @override
  List<Object> get props => [
    matchId,
  ];
}
