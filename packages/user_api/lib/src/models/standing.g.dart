// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'standing.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Standing _$StandingFromJson(Map<String, dynamic> json) {
  return Standing(
    stage: json['stage'] as String? ?? '',
    type: json['type'] as String? ?? '',
    group: json['group'] as String? ?? '',
    table: (json['table'] as List<dynamic>? ?? [])
        .map(
          (e) => StandingTable.fromJson(e as Map<String, dynamic>? ?? const {}),
        )
        .toList(),
  );
}
