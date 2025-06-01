import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:tiki_taka/app/models/models.dart';

part 'notification_payload.g.dart';

/// {@template notification_payload}
/// Notification Payload Model
/// {@endtemplate}
class NotificationPayload extends Equatable {
  /// {@macro notification_payload}
  const NotificationPayload({
    required this.type,
    required this.deepLink,
    required this.homeTeam,
    required this.awayTeam,
    required this.status,
  });

  /// Creates a new instance of [NotificationPayload] from a [Map]
  factory NotificationPayload.fromJson(Map<String, dynamic> json) =>
      _$NotificationPayloadFromJson(json);

  /// Converts the [NotificationPayload] instance to a [Map]
  Map<String, dynamic> toJson() => _$NotificationPayloadToJson(this);

  /// The type of the notification.
  final String type;

  /// The deep link associated with the notification.
  final String deepLink;

  /// The home team of the match.
  final NotificationTeam homeTeam;

  /// The away team of the match.
  final NotificationTeam awayTeam;

  /// The status of the match.
  final String status;

  @override
  List<Object?> get props => [
        type,
        deepLink,
        homeTeam,
        awayTeam,
        status,
      ];
}
