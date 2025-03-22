part of 'home_cubit.dart';

enum HomeStatus {
  initial,
  loading,
  success,
  failure;

  bool get isInitial => this == HomeStatus.initial;
  bool get isLoading => this == HomeStatus.loading;
  bool get isSuccess => this == HomeStatus.success;
  bool get isFailure => this == HomeStatus.failure;
}

class HomeState extends Equatable {
  const HomeState({
    this.status = HomeStatus.success,
    this.matches = const <Match>[],
    this.updatedAt,
    this.lastUpdated = 0,
  });

  final HomeStatus status;
  final List<Match> matches;
  final DateTime? updatedAt;
  final int lastUpdated;

  HomeState copyWith({
    HomeStatus? status,
    List<Match>? matches,
    DateTime? updatedAt,
    int? lastUpdated,
  }) {
    return HomeState(
      status: status ?? this.status,
      matches: matches ?? this.matches,
      updatedAt: updatedAt ?? this.updatedAt,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  List<Object?> get props => [
        status,
        matches,
        updatedAt,
        lastUpdated,
      ];
}
