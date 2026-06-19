import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

/// {@template config}
/// Modelo de configuración
/// {@endtemplate}
class Config extends Equatable {
  /// {@macro address}
  const Config({
    required this.id,
    required this.lastUpdate,
  });

  /// Crea una instancia de [Config] a partir de un [Map] json
  factory Config.fromJson(Map<String, dynamic> json) {
    return Config(
      id: json['id'] as String? ?? '',
      lastUpdate: (json['lastUpdate'] as Timestamp? ?? Timestamp.now())
          .toDate()
          .toLocal(),
    );
  }

  /// Id de la configuración
  final String id;

  /// Última actualización de la configuración
  final DateTime lastUpdate;

  @override
  List<Object?> get props => [
    id,
    lastUpdate,
  ];
}
