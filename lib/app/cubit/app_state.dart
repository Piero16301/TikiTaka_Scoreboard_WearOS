part of 'app_cubit.dart';

class AppState extends Equatable {
  const AppState({
    this.language = const Locale('en', 'US'),
    this.baseColor = Colors.green,
    this.fontFamily = 'Poppins',
  });

  final Locale language;
  final Color baseColor;
  final String fontFamily;

  AppState copyWith({
    Locale? language,
    Color? baseColor,
    String? fontFamily,
  }) {
    return AppState(
      baseColor: baseColor ?? this.baseColor,
      language: language ?? this.language,
      fontFamily: fontFamily ?? this.fontFamily,
    );
  }

  @override
  List<Object> get props => [
        baseColor,
        language,
        fontFamily,
      ];
}
