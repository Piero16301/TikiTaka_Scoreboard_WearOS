import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

/// {@template device}
/// Modelo de datos para un dispositivo
/// {@endtemplate}
class Device extends Equatable {
  /// {@macro device}
  const Device({
    required this.enabledTeams,
    required this.language,
    required this.lastOpenAt,
    required this.platform,
    required this.token,
    this.wearOSInfo,
  });

  /// Crea una instancia de [Device] a partir de un [Map] json
  factory Device.fromJson(Map<String, dynamic> json) {
    final languageParts = (json['language'] as String? ?? 'en_US').split('_');

    return Device(
      enabledTeams: List<String>.from(json['enabledTeams'] as List? ?? []),
      language: Locale(
        languageParts.first,
        languageParts.length > 1 ? languageParts.last : '',
      ),
      lastOpenAt: (json['lastOpenAt'] as Timestamp? ?? Timestamp.now())
          .toDate()
          .toLocal(),
      platform: Platform.values.firstWhere(
        (e) =>
            e.name.toUpperCase() ==
            (json['platform'] as String? ?? '').toUpperCase(),
        orElse: () => Platform.wearOS,
      ),
      token: json['token'] as String? ?? '',
      wearOSInfo: json['wearOSInfo'] != null
          ? Map<String, dynamic>.from(
              json['wearOSInfo'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  /// Empty device
  static final empty = Device(
    enabledTeams: const [],
    language: const Locale('en'),
    lastOpenAt: DateTime.now(),
    platform: Platform.wearOS,
    token: '',
    wearOSInfo: const {},
  );

  /// Códigos de equipos activos
  final List<String> enabledTeams;

  /// Idioma del dispositivo
  final Locale language;

  /// Fecha de última apertura
  final DateTime lastOpenAt;

  /// Plataforma del dispositivo
  final Platform platform;

  /// Token del dispositivo
  final String token;

  /// Información del dispositivo
  final Map<String, dynamic>? wearOSInfo;

  @override
  List<Object?> get props => [
        enabledTeams,
        language,
        lastOpenAt,
        platform,
        token,
        wearOSInfo,
      ];
}

enum Platform {
  android,
  ios,
  web,
  macOS,
  windows,
  linux,
  wearOS,
}
