// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Table _$TableFromJson(Map<String, dynamic> json) {
  return Table(
    position: json['position'] as int? ?? 0,
    team: Team.fromJson(json['team'] as Map<String, dynamic>? ?? const {}),
    playedGames: json['playedGames'] as int? ?? 0,
    form: json['form'] as String? ?? '',
    won: json['won'] as int? ?? 0,
    draw: json['draw'] as int? ?? 0,
    lost: json['lost'] as int? ?? 0,
    points: json['points'] as int? ?? 0,
    goalsFor: json['goalsFor'] as int? ?? 0,
    goalsAgainst: json['goalsAgainst'] as int? ?? 0,
    goalDifference: json['goalDifference'] as int? ?? 0,
  );
}
