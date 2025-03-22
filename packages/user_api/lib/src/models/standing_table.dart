import 'package:equatable/equatable.dart';
import 'package:user_api/user_api.dart';

part 'standing_table.g.dart';

/// {@template standing_table}
/// Modelo de datos para una tabla de clasificación
/// {@endtemplate}
class StandingTable extends Equatable {
  /// {@macro standing_table}
  const StandingTable({
    required this.position,
    required this.team,
    required this.playedGames,
    required this.form,
    required this.won,
    required this.draw,
    required this.lost,
    required this.points,
    required this.goalsFor,
    required this.goalsAgainst,
    required this.goalDifference,
  });

  /// Crea una instancia de [StandingTable] a partir de un [Map] json
  factory StandingTable.fromJson(Map<String, dynamic> json) =>
      _$StandingTableFromJson(json);

  /// Empty standing table
  static const empty = StandingTable(
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
  final String form;

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
