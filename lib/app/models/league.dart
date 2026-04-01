import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';

/// {@template league}
/// Modelo de liga
/// {@endtemplate}
class League extends Equatable {
  /// {@macro address}
  const League({
    required this.id,
    required this.name,
    required this.code,
    required this.type,
    required this.emblem,
    this.area,
    this.plan,
    this.currentSeason,
    this.numberOfAvailableSeasons,
    this.lastUpdated,
  });

  /// Crea una instancia de [League] a partir de un [Map] json
  factory League.fromJson(Map<String, dynamic> json) {
    return League(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      code: json['code'] as String? ?? '',
      type: json['type'] as String? ?? '',
      emblem: json['emblem'] as String? ?? '',
      area: json['area'] != null
          ? Area.fromJson(json['area'] as Map<String, dynamic>)
          : null,
      plan: json['plan'] != null ? json['plan'] as String : null,
      currentSeason: json['currentSeason'] != null
          ? Season.fromJson(json['currentSeason'] as Map<String, dynamic>)
          : null,
      numberOfAvailableSeasons: json['numberOfAvailableSeasons'] != null
          ? json['numberOfAvailableSeasons'] as int
          : null,
      lastUpdated: json['lastUpdated'] != null
          ? (json['lastUpdated'] as Timestamp).toDate().toLocal()
          : null,
    );
  }

  /// Empty league
  static final empty = League(
    id: 0,
    name: '',
    code: '',
    type: '',
    emblem: '',
    area: Area.empty,
    plan: '',
    currentSeason: Season.empty,
    numberOfAvailableSeasons: 0,
    lastUpdated: DateTime.now(),
  );

  /// Id de la liga
  final int id;

  /// Área de la liga
  final Area? area;

  /// Nombre de la liga
  final String name;

  /// Código de la liga
  final String code;

  /// Tipo de liga
  final String type;

  /// Emblema de la liga
  final String emblem;

  /// Plan de la liga
  final String? plan;

  /// Temporada actual de la liga
  final Season? currentSeason;

  /// Temporadas disponibles de la liga
  final int? numberOfAvailableSeasons;

  /// Última actualización de la liga
  final DateTime? lastUpdated;

  @override
  List<Object?> get props => [
        id,
        area,
        name,
        code,
        type,
        emblem,
        plan,
        currentSeason,
        numberOfAvailableSeasons,
        lastUpdated,
      ];
}
