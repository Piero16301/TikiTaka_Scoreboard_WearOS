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
    required this.area,
    required this.name,
    required this.code,
    required this.type,
    required this.emblem,
    required this.plan,
    required this.currentSeason,
    required this.numberOfAvailableSeasons,
    required this.lastUpdated,
  });

  /// Crea una instancia de [League] a partir de un [Map] json
  factory League.fromJson(Map<String, dynamic> json) {
    return League(
      id: json['id'] as int? ?? 0,
      area: Area.fromJson(json['area'] as Map<String, dynamic>? ?? {}),
      name: json['name'] as String? ?? '',
      code: json['code'] as String? ?? '',
      type: json['type'] as String? ?? '',
      emblem: json['emblem'] as String? ?? '',
      plan: json['plan'] as String? ?? '',
      currentSeason:
          Season.fromJson(json['currentSeason'] as Map<String, dynamic>? ?? {}),
      numberOfAvailableSeasons: json['numberOfAvailableSeasons'] as int? ?? 0,
      lastUpdated: (json['lastUpdated'] as Timestamp? ?? Timestamp.now())
          .toDate()
          .toLocal(),
    );
  }

  /// Id de la liga
  final int id;

  /// Área de la liga
  final Area area;

  /// Nombre de la liga
  final String name;

  /// Código de la liga
  final String code;

  /// Tipo de liga
  final String type;

  /// Emblema de la liga
  final String emblem;

  /// Plan de la liga
  final String plan;

  /// Temporada actual de la liga
  final Season currentSeason;

  /// Temporadas disponibles de la liga
  final int numberOfAvailableSeasons;

  /// Última actualización de la liga
  final DateTime lastUpdated;

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
