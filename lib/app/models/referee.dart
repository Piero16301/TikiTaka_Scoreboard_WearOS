import 'package:equatable/equatable.dart';

/// {@template referee}
/// Modelo de datos para un árbitro
/// {@endtemplate}
class Referee extends Equatable {
  /// {@macro referee}
  const Referee({
    required this.id,
    required this.name,
    required this.type,
    required this.nationality,
  });

  /// Crea una instancia de [Referee] a partir de un [Map] json
  factory Referee.fromJson(Map<String, dynamic> json) {
    return Referee(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      type: json['type'] as String? ?? '',
      nationality: json['nationality'] as String? ?? '',
    );
  }

  /// Id del árbitro
  final int id;

  /// Nombre del árbitro
  final String name;

  /// Tipo de árbitro
  final String type;

  /// Nacionalidad del árbitro
  final String nationality;

  @override
  List<Object> get props => [
    id,
    name,
    type,
    nationality,
  ];
}
