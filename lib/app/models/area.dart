import 'package:equatable/equatable.dart';

/// {@template area}
/// Modelo de datos para un área
/// {@endtemplate}
class Area extends Equatable {
  /// {@macro area}
  const Area({
    required this.id,
    required this.name,
    required this.code,
    required this.flag,
  });

  /// Crea una instancia de [Area] a partir de un [Map] json
  factory Area.fromJson(Map<String, dynamic> json) {
    return Area(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      code: json['code'] as String? ?? '',
      flag: json['flag'] as String? ?? '',
    );
  }

  /// Empty area
  static const empty = Area(
    id: 0,
    name: '',
    code: '',
    flag: '',
  );

  /// Id del área
  final int id;

  /// Nombre del área
  final String name;

  /// Código del área
  final String code;

  /// Bandera del área
  final String flag;

  @override
  List<Object?> get props => [
    id,
    name,
    code,
    flag,
  ];
}
