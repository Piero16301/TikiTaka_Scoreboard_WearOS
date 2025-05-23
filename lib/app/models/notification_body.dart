import 'package:equatable/equatable.dart';
import 'package:tiki_taka/app/models/models.dart';

part 'notification_body.g.dart';

/// {@template notification_body}
/// Notification Body Model
/// {@endtemplate}
class NotificationBody extends Equatable {
  /// {@macro notification_body}
  const NotificationBody({
    required this.homeTeam,
    required this.awayTeam,
    required this.status,
  });

  /// Creates a new instance of [NotificationBody] from a [Map]
  factory NotificationBody.fromJson(Map<String, dynamic> json) =>
      _$NotificationBodyFromJson(json);

  /// Converts the [NotificationBody] instance to a [Map]
  Map<String, dynamic> toJson() => _$NotificationBodyToJson(this);

  /// The home team of the match.
  final NotificationTeam homeTeam;

  /// The away team of the match.
  final NotificationTeam awayTeam;

  /// The status of the match.
  final String status;

  @override
  List<Object?> get props => [
        homeTeam,
        awayTeam,
        status,
      ];
}
