import 'package:equatable/equatable.dart';
import 'package:user_api/user_api.dart';

part 'standing.g.dart';

/// {@template standing}
/// Modelo de datos para una clasificación
/// {@endtemplate}
class Standing extends Equatable {
  /// {@macro standing}
  const Standing({
    required this.stage,
    required this.type,
    required this.group,
    required this.table,
  });

  /// Crea una instancia de [Standing] a partir de un [Map] json
  factory Standing.fromJson(Map<String, dynamic> json) =>
      _$StandingFromJson(json);

  /// Empty standing
  static const empty = Standing(
    stage: '',
    type: '',
    group: '',
    table: <StandingTable>[],
  );

  /// Etapa de la clasificación
  final String stage;

  /// Tipo de clasificación
  final String type;

  /// Grupo de la clasificación
  final String group;

  /// Tabla de clasificación
  final List<StandingTable> table;

  @override
  List<Object?> get props => [
        stage,
        type,
        group,
        table,
      ];
}
