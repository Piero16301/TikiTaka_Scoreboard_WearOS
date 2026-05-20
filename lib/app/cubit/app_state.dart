part of 'app_cubit.dart';

class AppState extends Equatable {
  const AppState({
    this.language = const Locale('en', 'US'),
    this.baseColor = Colors.green,
    this.fontFamily = 'Poppins',
    this.device,
  });

  final Locale language;
  final Color baseColor;
  final String fontFamily;
  final Device? device;

  AppState copyWith({
    Locale? language,
    Color? baseColor,
    String? fontFamily,
    Device? device,
  }) {
    return AppState(
      baseColor: baseColor ?? this.baseColor,
      language: language ?? this.language,
      fontFamily: fontFamily ?? this.fontFamily,
      device: device ?? this.device,
    );
  }

  @override
  List<Object?> get props => [
        baseColor,
        language,
        fontFamily,
        device,
      ];
}
