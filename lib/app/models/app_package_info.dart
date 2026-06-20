import 'package:equatable/equatable.dart';

/// {@template app_package_info}
/// Modelo de datos para la información del paquete
/// {@endtemplate}
class AppPackageInfo extends Equatable {
  /// {@macro app_package_info}
  const AppPackageInfo({
    required this.appName,
    required this.version,
    required this.buildNumber,
    required this.updateTime,
  });

  /// Crea un [Map] a partir de una instancia de [AppPackageInfo]
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'appName': appName,
      'version': version,
      'buildNumber': buildNumber,
      'updateTime': updateTime.toUtc(),
    };
  }

  /// Nombre de la aplicación
  final String appName;

  /// Versión de la aplicación
  final String version;

  /// Número de build de la aplicación
  final String buildNumber;

  /// Fecha de actualización de la aplicación
  final DateTime updateTime;

  @override
  List<Object> get props => [
    appName,
    version,
    buildNumber,
    updateTime,
  ];
}
