import 'package:equatable/equatable.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';

/// {@template team}
/// Modelo de datos para un equipo
/// {@endtemplate}
class Team extends Equatable {
  /// {@macro team}
  const Team({
    required this.id,
    required this.area,
    required this.name,
    required this.shortName,
    required this.tla,
    required this.crest,
    required this.address,
    required this.website,
    required this.founded,
    required this.clubColors,
    required this.venue,
    required this.runningCompetitions,
    required this.coach,
    required this.squad,
    required this.staff,
  });

  /// Crea una instancia de [Team] a partir de un [Map] json
  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['id'] as int? ?? 0,
      area: Area.fromJson(
        json['area'] as Map<String, dynamic>? ?? <String, dynamic>{},
      ),
      name: json['name'] as String? ?? '',
      shortName: json['shortName'] as String? ?? '',
      tla: json['tla'] as String? ?? '',
      crest: json['crest'] as String? ?? '',
      address: json['address'] as String? ?? '',
      website: json['website'] as String? ?? '',
      founded: json['founded'] as int? ?? 0,
      clubColors: json['clubColors'] as String? ?? '',
      venue: json['venue'] as String? ?? '',
      runningCompetitions: (json['runningCompetitions'] as List<dynamic>?)
              ?.map((e) => Competition.fromJson(e as Map<String, dynamic>))
              .toList() ??
          <Competition>[],
      coach: Staff.fromJson(
        json['coach'] as Map<String, dynamic>? ?? <String, dynamic>{},
      ),
      squad: (json['squad'] as List<dynamic>?)
              ?.map((e) => Staff.fromJson(e as Map<String, dynamic>))
              .toList() ??
          <Staff>[],
      staff: (json['staff'] as List<dynamic>?)
              ?.map((e) => Staff.fromJson(e as Map<String, dynamic>))
              .toList() ??
          <Staff>[],
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
    runningCompetitions: <Competition>[],
    coach: Staff.empty,
    squad: <Staff>[],
    staff: <Staff>[],
  );

  /// Id del equipo
  final int id;

  /// Area del equipo
  final Area area;

  /// Nombre del equipo
  final String name;

  /// Nombre corto del equipo
  final String shortName;

  /// Abreviatura del equipo
  final String tla;

  /// Escudo del equipo
  final String crest;

  /// Dirección del equipo
  final String address;

  /// Sitio web del equipo
  final String website;

  /// Año de fundación del equipo
  final int founded;

  /// Colores del club
  final String clubColors;

  /// Estadio del equipo
  final String venue;

  /// Competiciones en las que participa el equipo
  final List<Competition> runningCompetitions;

  /// Entrenador del equipo
  final Staff coach;

  /// Squad del equipo
  final List<Staff> squad;

  /// Staff del equipo
  final List<Staff> staff;

  @override
  List<Object> get props => [
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
