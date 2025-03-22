// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'odds.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Odds _$OddsFromJson(Map<String, dynamic> json) {
  return Odds(
    homeWin: (json['homeWin'] as num?)?.toDouble() ?? 0.0,
    draw: (json['draw'] as num?)?.toDouble() ?? 0.0,
    awayWin: (json['awayWin'] as num?)?.toDouble() ?? 0.0,
  );
}
