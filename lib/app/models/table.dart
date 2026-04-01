import 'package:equatable/equatable.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';

/// {@template standing_table}
/// Modelo de datos para una tabla de clasificación
/// {@endtemplate}
class Table extends Equatable {
  /// {@macro standing_table}
  const Table({
    required this.position,
    required this.team,
    required this.playedGames,
    required this.won,
    required this.draw,
    required this.lost,
    required this.points,
    required this.goalsFor,
    required this.goalsAgainst,
    required this.goalDifference,
    this.form,
  });

  /// Crea una instancia de [Table] a partir de un [Map] json
  factory Table.fromJson(Map<String, dynamic> json) {
    return Table(
      position: json['position'] as int? ?? 0,
      team: Team.fromJson(json['team'] as Map<String, dynamic>? ?? const {}),
      playedGames: json['playedGames'] as int? ?? 0,
      form: json['form'] != null ? json['form'] as String? : null,
      won: json['won'] as int? ?? 0,
      draw: json['draw'] as int? ?? 0,
      lost: json['lost'] as int? ?? 0,
      points: json['points'] as int? ?? 0,
      goalsFor: json['goalsFor'] as int? ?? 0,
      goalsAgainst: json['goalsAgainst'] as int? ?? 0,
      goalDifference: json['goalDifference'] as int? ?? 0,
    );
  }

  /// Empty standing table
  static const empty = Table(
    position: 0,
    team: Team.empty,
    playedGames: 0,
    form: '',
    won: 0,
    draw: 0,
    lost: 0,
    points: 0,
    goalsFor: 0,
    goalsAgainst: 0,
    goalDifference: 0,
  );

  /// Posición en la tabla
  final int position;

  /// Equipo
  final Team team;

  /// Partidos jugados
  final int playedGames;

  /// Forma del equipo
  final String? form;

  /// Partidos ganados
  final int won;

  /// Partidos empatados
  final int draw;

  /// Partidos perdidos
  final int lost;

  /// Puntos
  final int points;

  /// Goles a favor
  final int goalsFor;

  /// Goles en contra
  final int goalsAgainst;

  /// Diferencia de goles
  final int goalDifference;

  @override
  List<Object?> get props => [
        position,
        team,
        playedGames,
        form,
        won,
        draw,
        lost,
        points,
        goalsFor,
        goalsAgainst,
        goalDifference,
      ];
}
