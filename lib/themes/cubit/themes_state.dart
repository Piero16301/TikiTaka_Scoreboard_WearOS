part of 'themes_cubit.dart';

enum ThemesStatus {
  initial,
  loading,
  success,
  failure;

  bool get isInitial => this == ThemesStatus.initial;
  bool get isLoading => this == ThemesStatus.loading;
  bool get isSuccess => this == ThemesStatus.success;
  bool get isFailure => this == ThemesStatus.failure;
}

class ThemesState extends Equatable {
  const ThemesState({
    this.status = ThemesStatus.success,
  });

  final ThemesStatus status;

  ThemesState copyWith({
    ThemesStatus? status,
  }) {
    return ThemesState(
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [
        status,
      ];
}
