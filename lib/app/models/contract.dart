import 'package:equatable/equatable.dart';

/// {@template contract}
/// Modelo de datos para un contrato
/// {@endtemplate}
class Contract extends Equatable {
  /// {@macro contract}
  const Contract({
    required this.start,
    required this.until,
  });

  /// Crea una instancia de [Contract] a partir de un [Map] json
  factory Contract.fromJson(Map<String, dynamic> json) {
    return Contract(
      start: json['start'] as String? ?? '',
      until: json['until'] as String? ?? '',
    );
  }

  /// Empty contract
  static const empty = Contract(
    start: '',
    until: '',
  );

  /// Fecha de inicio del contrato
  final String start;

  /// Fecha de finalización del contrato
  final String until;

  @override
  List<Object> get props => [
    start,
    until,
  ];
}
