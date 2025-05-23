// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationBody _$NotificationBodyFromJson(Map<String, dynamic> json) =>
    NotificationBody(
      homeTeam: NotificationTeam.fromJson(
        json['homeTeam'] as Map<String, dynamic>? ?? {},
      ),
      awayTeam: NotificationTeam.fromJson(
        json['awayTeam'] as Map<String, dynamic>? ?? {},
      ),
      status: json['status'] as String? ?? '',
    );

Map<String, dynamic> _$NotificationBodyToJson(NotificationBody instance) =>
    <String, dynamic>{
      'homeTeam': instance.homeTeam.toJson(),
      'awayTeam': instance.awayTeam.toJson(),
      'status': instance.status,
    };
