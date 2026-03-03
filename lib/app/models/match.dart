import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';

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
  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
      area: Area.fromJson(
        json['area'] as Map<String, dynamic>? ?? <String, dynamic>{},
      ),
      competition: Competition.fromJson(
        json['competition'] as Map<String, dynamic>? ?? <String, dynamic>{},
      ),
      season: Season.fromJson(
        json['season'] as Map<String, dynamic>? ?? <String, dynamic>{},
      ),
      id: json['id'] as int? ?? 0,
      utcDate:
          (json['utcDate'] as Timestamp? ?? Timestamp.now()).toDate().toLocal(),
      status: json['status'] as String? ?? '-',
      matchday: json['matchday'] as int? ?? 1,
      stage: json['stage'] as String? ?? '-',
      group: json['group'] as String? ?? '-',
      lastUpdated: (json['lastUpdated'] as Timestamp? ?? Timestamp.now())
          .toDate()
          .toLocal(),
      homeTeam: Team.fromJson(
        json['homeTeam'] as Map<String, dynamic>? ?? <String, dynamic>{},
      ),
      awayTeam: Team.fromJson(
        json['awayTeam'] as Map<String, dynamic>? ?? <String, dynamic>{},
      ),
      score: Score.fromJson(json['score'] as Map<String, dynamic>? ?? {}),
      odds: Odds.fromJson(json['odds'] as Map<String, dynamic>? ?? {}),
      referees: (json['referees'] as List<dynamic>?)
              ?.map(
                (e) => Referee.fromJson(
                  e as Map<String, dynamic>? ?? <String, dynamic>{},
                ),
              )
              .toList() ??
          <Referee>[],
    );
  }

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
