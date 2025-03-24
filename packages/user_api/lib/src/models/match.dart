import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:user_api/user_api.dart';

part 'match.g.dart';

/// {@template match}
/// Modelo de datos para un partido
/// {@endtemplate}
class Match extends Equatable {
  /// {@macro match}
  const Match({
    required this.area,
    required this.competition,
    required this.season,
    required this.id,
    required this.utcDate,
    required this.status,
    required this.matchday,
    required this.stage,
    required this.group,
    required this.lastUpdated,
    required this.homeTeam,
    required this.awayTeam,
    required this.score,
    required this.odds,
    required this.referees,
  });

  /// Crea una instancia de [Match] a partir de un [Map] json
  factory Match.fromJson(Map<String, dynamic> json) => _$MatchFromJson(json);

  /// Empty match
  static const empty = Match(
    area: Area.empty,
    competition: Competition.empty,
    season: Season.empty,
    id: 0,
    utcDate: null,
    status: '',
    matchday: 0,
    stage: '',
    group: '',
    lastUpdated: null,
    homeTeam: Team.empty,
    awayTeam: Team.empty,
    score: Score.empty,
    odds: Odds.empty,
    referees: [],
  );

  /// Área del partido
  final Area area;

  /// Competición del partido
  final Competition competition;

  /// Temporada del partido
  final Season season;

  /// Id del partido
  final int id;

  /// Fecha del partido
  final DateTime? utcDate;

  /// Estado del partido
  final String status;

  /// Jornada del partido
  final int matchday;

  /// Etapa del partido
  final String stage;

  /// Grupo del partido
  final String group;

  /// Última actualización del partido
  final DateTime? lastUpdated;

  /// Equipo local del partido
  final Team homeTeam;

  /// Equipo visitante del partido
  final Team awayTeam;

  /// Marcador del partido
  final Score score;

  /// Cuotas del partido
  final Odds odds;

  /// Árbitros del partido
  final List<Referee> referees;

  @override
  List<Object?> get props => [
        area,
        competition,
        season,
        id,
        utcDate,
        status,
        matchday,
        stage,
        group,
        lastUpdated,
        homeTeam,
        awayTeam,
        score,
        odds,
        referees,
      ];
}
