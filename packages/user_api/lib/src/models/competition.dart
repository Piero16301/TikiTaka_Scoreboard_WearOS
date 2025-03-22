import 'package:equatable/equatable.dart';

part 'competition.g.dart';

/// {@template competition}
/// Modelo de datos para una competición
/// {@endtemplate}
class Competition extends Equatable {
  /// {@macro competition}
  const Competition({
    required this.id,
    required this.name,
    required this.code,
    required this.type,
    required this.emblem,
  });

  /// Crea una instancia de [Competition] a partir de un [Map] json
  factory Competition.fromJson(Map<String, dynamic> json) =>
      _$CompetitionFromJson(json);

  /// Empty competition
  static const empty = Competition(
    id: 0,
    name: '',
    code: '',
    type: '',
    emblem: '',
  );

  /// Id de la competición
  final int id;

  /// Nombre de la competición
  final String name;

  /// Código de la competición
  final String code;

  /// Tipo de competición
  final String type;

  /// Emblema de la competición
  final String emblem;

  @override
  List<Object?> get props => [
        id,
        name,
        code,
        type,
        emblem,
      ];
}
