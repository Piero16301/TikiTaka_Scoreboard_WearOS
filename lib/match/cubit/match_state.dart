part of 'match_cubit.dart';

enum StandingsStatus {
  initial,
  loading,
  success,
  failure;

  bool get isInitial => this == StandingsStatus.initial;
  bool get isLoading => this == StandingsStatus.loading;
  bool get isSuccess => this == StandingsStatus.success;
  bool get isFailure => this == StandingsStatus.failure;
}

class MatchState extends Equatable {
  const MatchState({
    this.status = StandingsStatus.initial,
    this.match = Match.empty,
    this.standings = const <Standing>[],
  });

  final StandingsStatus status;
  final Match match;
  final List<Standing> standings;

  MatchState copyWith({
    StandingsStatus? status,
    Match? match,
    List<Standing>? standings,
  }) {
    return MatchState(
      status: status ?? this.status,
      match: match ?? this.match,
      standings: standings ?? this.standings,
    );
  }

  @override
  List<Object> get props => [
        status,
        match,
        standings,
      ];
}
