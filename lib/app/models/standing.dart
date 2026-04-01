import 'package:equatable/equatable.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';

/// {@template standing}
/// Modelo de datos para una clasificación
/// {@endtemplate}
class Standing extends Equatable {
  /// {@macro standing}
  const Standing({
    required this.stage,
    required this.type,
    required this.table,
    this.group,
  });

  /// Crea una instancia de [Standing] a partir de un [Map] json
  factory Standing.fromJson(Map<String, dynamic> json) {
    return Standing(
      stage: json['stage'] as String? ?? '',
      type: json['type'] as String? ?? '',
      group: json['group'] != null ? json['group'] as String? : null,
      table: (json['table'] as List<dynamic>? ?? [])
          .map(
            (e) => Table.fromJson(e as Map<String, dynamic>? ?? const {}),
          )
          .toList(),
    );
  }

  /// Empty standing
  static const empty = Standing(
    stage: '',
    type: '',
    group: '',
    table: <Table>[],
  );

  /// Etapa de la clasificación
  final String stage;

  /// Tipo de clasificación
  final String type;

  /// Grupo de la clasificación
  final String? group;

  /// Tabla de clasificación
  final List<Table> table;

  @override
  List<Object?> get props => [
        stage,
        type,
        group,
        table,
      ];
}
