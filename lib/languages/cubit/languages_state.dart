part of 'languages_cubit.dart';

enum LanguagesStatus {
  initial,
  loading,
  success,
  failure;

  bool get isInitial => this == LanguagesStatus.initial;
  bool get isLoading => this == LanguagesStatus.loading;
  bool get isSuccess => this == LanguagesStatus.success;
  bool get isFailure => this == LanguagesStatus.failure;
}

class LanguagesState extends Equatable {
  const LanguagesState({
    this.status = LanguagesStatus.success,
  });

  final LanguagesStatus status;

  LanguagesState copyWith({
    LanguagesStatus? status,
  }) {
    return LanguagesState(
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [
        status,
      ];
}
