import 'package:equatable/equatable.dart';

/// {@template time}
/// Modelo de datos para un tiempo
/// {@endtemplate}
class Time extends Equatable {
  /// {@macro time}
  const Time({
    required this.home,
    required this.away,
  });

  /// Crea una instancia de [Time] a partir de un [Map] json
  factory Time.fromJson(Map<String, dynamic> json) {
    return Time(
      home: json['home'] as int? ?? 0,
      away: json['away'] as int? ?? 0,
    );
  }

  /// Empty time
  static const empty = Time(
    home: 0,
    away: 0,
  );

  /// Goles del equipo local
  final int home;

  /// Goles del equipo visitante
  final int away;

  @override
  List<Object> get props => [
    home,
    away,
  ];
}
