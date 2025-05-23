import 'package:equatable/equatable.dart';

part 'notification_team.g.dart';

/// {@template notification_team}
/// Notification Team Model
/// {@endtemplate}
class NotificationTeam extends Equatable {
  /// {@macro notification_team}
  const NotificationTeam({
    required this.colors,
    required this.name,
    required this.shortName,
    required this.score,
  });

  /// Creates a new instance of [NotificationTeam] from a [Map]
  factory NotificationTeam.fromJson(Map<String, dynamic> json) =>
      _$NotificationTeamFromJson(json);

  /// Converts a [Map] to a [NotificationTeam]
  Map<String, dynamic> toJson() => _$NotificationTeamToJson(this);

  /// The colors of the team.
  final String colors;

  /// The name of the team.
  final String name;

  /// The short name of the team.
  final String shortName;

  /// The score of the team.
  final int score;

  @override
  List<Object> get props => [
        colors,
        name,
        shortName,
        score,
      ];
}
