// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Config _$ConfigFromJson(Map<String, dynamic> json) {
  return Config(
    id: json['id'] as String? ?? '',
    lastUpdate: (json['lastUpdate'] as Timestamp? ?? Timestamp.now())
        .toDate()
        .toLocal(),
  );
}
