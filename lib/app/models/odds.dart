import 'package:equatable/equatable.dart';

/// {@template odds}
/// Modelo de datos para las cuotas de un partido
/// {@endtemplate}
class Odds extends Equatable {
  /// {@macro odds}
  const Odds({
    this.homeWin,
    this.draw,
    this.awayWin,
    this.message = '',
  });

  /// Crea una instancia de [Odds] a partir de un [Map] json
  factory Odds.fromJson(Map<String, dynamic> json) {
    return Odds(
      homeWin: json['homeWin'] != null
          ? (json['homeWin'] as num?)?.toDouble()
          : null,
      draw: json['draw'] != null ? (json['draw'] as num?)?.toDouble() : null,
      awayWin: json['awayWin'] != null
          ? (json['awayWin'] as num?)?.toDouble()
          : null,
      message: json['message'] as String? ?? '',
    );
  }

  /// Empty odds
  static const empty = Odds(
    homeWin: 0,
    draw: 0,
    awayWin: 0,
  );

  /// Cuota para el equipo local
  final double? homeWin;

  /// Cuota para el empate
  final double? draw;

  /// Cuota para el equipo visitante
  final double? awayWin;

  /// Mensaje de error
  final String message;

  @override
  List<Object?> get props => [
    homeWin,
    draw,
    awayWin,
    message,
  ];
}
