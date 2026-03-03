import 'package:equatable/equatable.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';

/// {@template staff}
/// Modelo de datos para un staff
/// {@endtemplate}
class Staff extends Equatable {
  /// {@macro staff}
  const Staff({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.name,
    required this.dateOfBirth,
    required this.nationality,
    required this.contract,
    required this.position,
  });

  /// Crea una instancia de [Staff] a partir de un [Map] json
  factory Staff.fromJson(Map<String, dynamic> json) {
    return Staff(
      id: json['id'] as int? ?? 0,
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      name: json['name'] as String? ?? '',
      dateOfBirth: json['dateOfBirth'] as String? ?? '',
      nationality: json['nationality'] as String? ?? '',
      contract: Contract.fromJson(
        json['contract'] as Map<String, dynamic>? ?? <String, dynamic>{},
      ),
      position: json['position'] as String? ?? '',
    );
  }

  /// Empty staff
  static const empty = Staff(
    id: 0,
    firstName: '',
    lastName: '',
    name: '',
    dateOfBirth: '',
    nationality: '',
    contract: Contract.empty,
    position: '',
  );

  /// Id del staff
  final int id;

  /// Nombre del staff
  final String firstName;

  /// Apellido del staff
  final String lastName;

  /// Nombre completo del staff
  final String name;

  /// Fecha de nacimiento del staff
  final String dateOfBirth;

  /// Nacionalidad del staff
  final String nationality;

  /// Contrato del staff
  final Contract contract;

  /// Posición del staff
  final String position;

  @override
  List<Object> get props => [
        id,
        firstName,
        lastName,
        name,
        dateOfBirth,
        nationality,
        contract,
        position,
      ];
}
