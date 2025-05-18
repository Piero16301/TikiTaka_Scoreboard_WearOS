part of 'app_cubit.dart';

class AppState extends Equatable {
  const AppState({
    this.darkMode = true,
    this.language = 'es',
  });

  final bool darkMode;
  final String language;

  AppState copyWith({
    bool? darkMode,
    String? language,
  }) {
    return AppState(
      darkMode: darkMode ?? this.darkMode,
      language: language ?? this.language,
    );
  }

  @override
  List<Object?> get props => [
        darkMode,
        language,
      ];
}
