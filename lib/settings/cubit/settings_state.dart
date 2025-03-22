part of 'settings_cubit.dart';

enum SettingsStatus {
  initial,
  loading,
  success,
  failure;

  bool get isInitial => this == SettingsStatus.initial;
  bool get isLoading => this == SettingsStatus.loading;
  bool get isSuccess => this == SettingsStatus.success;
  bool get isFailure => this == SettingsStatus.failure;
}

class SettingsState extends Equatable {
  const SettingsState({
    this.status = SettingsStatus.success,
  });

  final SettingsStatus status;

  SettingsState copyWith({
    SettingsStatus? status,
  }) {
    return SettingsState(
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [
        status,
      ];
}
