import 'package:equatable/equatable.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';

/// {@template season}
/// Modelo de datos para una temporada
/// {@endtemplate}
class Season extends Equatable {
  /// {@macro season}
  const Season({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.currentMatchday,
    this.winner,
  });

  /// Crea una instancia de [Season] a partir de un [Map] json
  factory Season.fromJson(Map<String, dynamic> json) {
    return Season(
      id: json['id'] as int? ?? 0,
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'] as String).toLocal()
          : null,
      endDate: json['endDate'] != null
          ? DateTime.parse(json['endDate'] as String).toLocal()
          : null,
      currentMatchday: json['currentMatchday'] as int? ?? 0,
      winner: json['winner'] != null
          ? Team.fromJson(json['winner'] as Map<String, dynamic>)
          : null,
    );
  }

  /// Empty season
  static const empty = Season(
    id: 0,
    startDate: null,
    endDate: null,
    currentMatchday: 0,
    winner: Team.empty,
  );

  /// Id de la temporada
  final int id;

  /// Inicio de la temporada
  final DateTime? startDate;

  /// Fin de la temporada
  final DateTime? endDate;

  /// Fecha actual de la temporada
  final int currentMatchday;

  /// Ganador de la temporada
  final Team? winner;

  @override
  List<Object?> get props => [
        id,
        startDate,
        endDate,
        currentMatchday,
        winner,
      ];
}
