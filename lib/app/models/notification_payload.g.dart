// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationPayload _$NotificationPayloadFromJson(Map<String, dynamic> json) =>
    NotificationPayload(
      type: json['type'] as String? ?? '',
      deepLink: json['deepLink'] as String? ?? '',
      homeTeam: NotificationTeam.fromJson(
        jsonDecode(json['homeTeam'] as String? ?? '')
                as Map<String, dynamic>? ??
            {},
      ),
      awayTeam: NotificationTeam.fromJson(
        jsonDecode(json['awayTeam'] as String? ?? '')
                as Map<String, dynamic>? ??
            {},
      ),
      status: json['status'] as String? ?? '',
    );

Map<String, dynamic> _$NotificationPayloadToJson(
  NotificationPayload instance,
) =>
    <String, dynamic>{
      'type': instance.type,
      'deepLink': instance.deepLink,
      'homeTeam': instance.homeTeam.toJson(),
      'awayTeam': instance.awayTeam.toJson(),
      'status': instance.status,
    };
