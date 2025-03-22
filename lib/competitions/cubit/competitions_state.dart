part of 'competitions_cubit.dart';

enum CompetitionsStatus {
  initial,
  loading,
  success,
  failure;

  bool get isInitial => this == CompetitionsStatus.initial;
  bool get isLoading => this == CompetitionsStatus.loading;
  bool get isSuccess => this == CompetitionsStatus.success;
  bool get isFailure => this == CompetitionsStatus.failure;
}

class CompetitionsState extends Equatable {
  const CompetitionsState({
    this.status = CompetitionsStatus.success,
    this.leagues = const <League>[],
    this.enabled = const <String, bool>{},
  });

  final CompetitionsStatus status;
  final List<League> leagues;
  final Map<String, bool> enabled;

  CompetitionsState copyWith({
    CompetitionsStatus? status,
    List<League>? leagues,
    Map<String, bool>? enabled,
  }) {
    return CompetitionsState(
      status: status ?? this.status,
      leagues: leagues ?? this.leagues,
      enabled: enabled ?? this.enabled,
    );
  }

  @override
  List<Object> get props => [
        status,
        leagues,
        enabled,
      ];
}
