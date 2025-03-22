import 'package:equatable/equatable.dart';

part 'odds.g.dart';

/// {@template odds}
/// Modelo de datos para las cuotas de un partido
/// {@endtemplate}
class Odds extends Equatable {
  /// {@macro odds}
  const Odds({
    required this.homeWin,
    required this.draw,
    required this.awayWin,
  });

  /// Crea una instancia de [Odds] a partir de un [Map] json
  factory Odds.fromJson(Map<String, dynamic> json) => _$OddsFromJson(json);

  /// Empty odds
  static const empty = Odds(
    homeWin: 0,
    draw: 0,
    awayWin: 0,
  );

  /// Cuota para el equipo local
  final double homeWin;

  /// Cuota para el empate
  final double draw;

  /// Cuota para el equipo visitante
  final double awayWin;

  @override
  List<Object> get props => [
        homeWin,
        draw,
        awayWin,
      ];
}
