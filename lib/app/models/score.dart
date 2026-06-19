import 'package:equatable/equatable.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';

/// {@template score}
/// Modelo de datos para un marcador
/// {@endtemplate}
class Score extends Equatable {
  /// {@macro score}
  const Score({
    required this.winner,
    required this.duration,
    required this.halfTime,
    required this.fullTime,
    this.regularTime,
    this.extraTime,
    this.penalties,
  });

  /// Crea una instancia de [Score] a partir de un [Map] json
  factory Score.fromJson(Map<String, dynamic> json) {
    return Score(
      winner: json['winner'] as String? ?? '',
      duration: json['duration'] as String? ?? '',
      halfTime: Time.fromJson(json['halfTime'] as Map<String, dynamic>? ?? {}),
      fullTime: Time.fromJson(json['fullTime'] as Map<String, dynamic>? ?? {}),
      regularTime: json['regularTime'] != null
          ? Time.fromJson(json['regularTime'] as Map<String, dynamic>? ?? {})
          : null,
      extraTime: json['extraTime'] != null
          ? Time.fromJson(json['extraTime'] as Map<String, dynamic>? ?? {})
          : null,
      penalties: json['penalties'] != null
          ? Time.fromJson(json['penalties'] as Map<String, dynamic>? ?? {})
          : null,
    );
  }

  /// Empty score
  static const empty = Score(
    winner: '',
    duration: '',
    halfTime: Time.empty,
    fullTime: Time.empty,
  );

  /// Ganador del partido
  final String winner;

  /// Duración del partido
  final String duration;

  /// Marcador del primer tiempo
  final Time halfTime;

  /// Marcador final del partido
  final Time fullTime;

  /// Marcador del tiempo regular
  final Time? regularTime;

  /// Marcador del tiempo extra
  final Time? extraTime;

  /// Marcador de los penales
  final Time? penalties;

  @override
  List<Object?> get props => [
    winner,
    duration,
    halfTime,
    fullTime,
    regularTime,
    extraTime,
    penalties,
  ];
}
