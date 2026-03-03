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
    required this.fullTime,
    required this.halfTime,
  });

  /// Crea una instancia de [Score] a partir de un [Map] json
  factory Score.fromJson(Map<String, dynamic> json) {
    return Score(
      winner: json['winner'] as String? ?? '',
      duration: json['duration'] as String? ?? '',
      fullTime: Time.fromJson(json['fullTime'] as Map<String, dynamic>? ?? {}),
      halfTime: Time.fromJson(json['halfTime'] as Map<String, dynamic>? ?? {}),
    );
  }

  /// Empty score
  static const empty = Score(
    winner: '',
    duration: '',
    fullTime: Time.empty,
    halfTime: Time.empty,
  );

  /// Ganador del partido
  final String winner;

  /// Duración del partido
  final String duration;

  /// Marcador final del partido
  final Time fullTime;

  /// Marcador del primer tiempo
  final Time halfTime;

  @override
  List<Object> get props => [
        winner,
        duration,
        fullTime,
        halfTime,
      ];
}
