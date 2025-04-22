// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Team _$TeamFromJson(Map<String, dynamic> json) {
  return Team(
    id: json['id'] as int? ?? 0,
    area: Area.fromJson(
      json['area'] as Map<String, dynamic>? ?? <String, dynamic>{},
    ),
    name: json['name'] as String? ?? '',
    shortName: json['shortName'] as String? ?? '',
    tla: json['tla'] as String? ?? '',
    crest: json['crest'] as String? ?? '',
    address: json['address'] as String? ?? '',
    website: json['website'] as String? ?? '',
    founded: json['founded'] as int? ?? 0,
    clubColors: (json['clubColors'] as String? ?? '').split(' / '),
    venue: json['venue'] as String? ?? '',
    runningCompetitions: (json['runningCompetitions'] as List<dynamic>?)
            ?.map((e) => Competition.fromJson(e as Map<String, dynamic>))
            .toList() ??
        <Competition>[],
    coach: Staff.fromJson(
      json['coach'] as Map<String, dynamic>? ?? <String, dynamic>{},
    ),
    squad: (json['squad'] as List<dynamic>?)
            ?.map((e) => Staff.fromJson(e as Map<String, dynamic>))
            .toList() ??
        <Staff>[],
    staff: (json['staff'] as List<dynamic>?)
            ?.map((e) => Staff.fromJson(e as Map<String, dynamic>))
            .toList() ??
        <Staff>[],
    lastUpdated: (json['lastUpdated'] as Timestamp? ?? Timestamp.now())
        .toDate()
        .toLocal(),
  );
}
