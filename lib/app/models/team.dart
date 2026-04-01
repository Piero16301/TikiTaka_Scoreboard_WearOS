import 'package:equatable/equatable.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';

/// {@template team}
/// Modelo de datos para un equipo
/// {@endtemplate}
class Team extends Equatable {
  /// {@macro team}
  const Team({
    required this.id,
    required this.name,
    required this.shortName,
    required this.tla,
    required this.crest,
    this.address,
    this.website,
    this.founded,
    this.clubColors,
    this.venue,
    this.runningCompetitions,
    this.coach,
    this.squad,
    this.staff,
    this.area,
  });

  /// Crea una instancia de [Team] a partir de un [Map] json
  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['id'] as int? ?? 0,
      area: json['area'] != null
          ? Area.fromJson(json['area'] as Map<String, dynamic>)
          : null,
      name: json['name'] as String? ?? '',
      shortName: json['shortName'] as String? ?? '',
      tla: json['tla'] as String? ?? '',
      crest: json['crest'] as String? ?? '',
      address:
          json['address'] != null ? json['address'] as String? ?? '' : null,
      website:
          json['website'] != null ? json['website'] as String? ?? '' : null,
      founded: json['founded'] != null ? json['founded'] as int? ?? 0 : null,
      clubColors: json['clubColors'] != null
          ? json['clubColors'] as String? ?? ''
          : null,
      venue: json['venue'] != null ? json['venue'] as String? ?? '' : null,
      runningCompetitions: json['runningCompetitions'] != null
          ? (json['runningCompetitions'] as List<dynamic>?)
              ?.map((e) => League.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      coach: json['coach'] != null
          ? Staff.fromJson(json['coach'] as Map<String, dynamic>)
          : null,
      squad: json['squad'] != null
          ? (json['squad'] as List<dynamic>?)
              ?.map((e) => Staff.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      staff: json['staff'] != null
          ? (json['staff'] as List<dynamic>?)
              ?.map((e) => Staff.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  /// Empty team
  static const empty = Team(
    id: 0,
    area: Area.empty,
    name: '',
    shortName: '',
    tla: '',
    crest: '',
    address: '',
    website: '',
    founded: 0,
    clubColors: '',
    venue: '',
    runningCompetitions: <League>[],
    coach: Staff.empty,
    squad: <Staff>[],
    staff: <Staff>[],
  );

  /// Id del equipo
  final int id;

  /// Area del equipo
  final Area? area;

  /// Nombre del equipo
  final String name;

  /// Nombre corto del equipo
  final String shortName;

  /// Abreviatura del equipo
  final String tla;

  /// Escudo del equipo
  final String crest;

  /// Dirección del equipo
  final String? address;

  /// Sitio web del equipo
  final String? website;

  /// Año de fundación del equipo
  final int? founded;

  /// Colores del club
  final String? clubColors;

  /// Estadio del equipo
  final String? venue;

  /// Competiciones en las que participa el equipo
  final List<League>? runningCompetitions;

  /// Entrenador del equipo
  final Staff? coach;

  /// Squad del equipo
  final List<Staff>? squad;

  /// Staff del equipo
  final List<Staff>? staff;

  @override
  List<Object?> get props => [
        id,
        area,
        name,
        shortName,
        tla,
        crest,
        address,
        website,
        founded,
        clubColors,
        venue,
        runningCompetitions,
        coach,
        squad,
        staff,
      ];
}
