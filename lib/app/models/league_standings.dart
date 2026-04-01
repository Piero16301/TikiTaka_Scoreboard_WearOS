import 'package:equatable/equatable.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';

/// {@template league_standings}
/// Modelo de datos para la clasificación de una liga
/// {@endtemplate}
class LeagueStandings extends Equatable {
  /// {@macro league_standings}
  const LeagueStandings({
    required this.leagueId,
    required this.standings,
  });

  /// Crea una instancia de [LeagueStandings] a partir de un [Map] json
  factory LeagueStandings.fromJson(Map<String, dynamic> json) {
    return LeagueStandings(
      leagueId: json['leagueId'] as String? ?? '',
      standings: (json['standings'] as List<dynamic>? ?? [])
          .map(
            (e) => Standing.fromJson(e as Map<String, dynamic>? ?? const {}),
          )
          .toList(),
    );
  }

  /// Crea una instancia vacía de [LeagueStandings]
  static const empty = LeagueStandings(
    leagueId: '',
    standings: <Standing>[],
  );

  /// ID de la liga
  final String leagueId;

  /// Clasificaciones de la liga
  final List<Standing> standings;

  @override
  List<Object?> get props => [
        leagueId,
        standings,
      ];
}
