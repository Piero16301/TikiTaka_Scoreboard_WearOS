// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_team.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationTeam _$NotificationTeamFromJson(Map<String, dynamic> json) =>
    NotificationTeam(
      colors: json['colors'] as String? ?? '',
      name: json['name'] as String? ?? '',
      shortName: json['shortName'] as String? ?? '',
      score: int.parse(json['score'] as String? ?? ''),
    );

Map<String, dynamic> _$NotificationTeamToJson(NotificationTeam instance) =>
    <String, dynamic>{
      'colors': instance.colors,
      'name': instance.name,
      'shortName': instance.shortName,
      'score': instance.score,
    };
