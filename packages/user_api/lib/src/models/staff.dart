import 'package:equatable/equatable.dart';
import 'package:user_api/src/models/models.dart';

part 'staff.g.dart';

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
  factory Staff.fromJson(Map<String, dynamic> json) => _$StaffFromJson(json);

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
