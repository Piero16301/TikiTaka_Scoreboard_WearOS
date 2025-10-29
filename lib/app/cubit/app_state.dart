part of 'app_cubit.dart';

class AppState extends Equatable {
  const AppState({
    this.baseColor = 'INDIGO',
    this.language = 'en_US',
  });

  final String baseColor;
  final String language;

  AppState copyWith({
    String? baseColor,
    String? language,
  }) {
    return AppState(
      baseColor: baseColor ?? this.baseColor,
      language: language ?? this.language,
    );
  }

  @override
  List<Object> get props => [
    baseColor,
    language,
  ];
}
