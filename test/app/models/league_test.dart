import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';

void main() {
  group('League', () {
    const id = 1;
    const name = 'La Liga';
    const code = 'LL';
    const type = 'LEAGUE';
    const emblem = 'emblem.png';
    const plan = 'TIER_ONE';
    const numberOfAvailableSeasons = 10;
    final date = DateTime.utc(2023);

    test('supports value comparisons', () {
      expect(
        League(
          id: id,
          area: Area.empty,
          name: name,
          code: code,
          type: type,
          emblem: emblem,
          plan: plan,
          currentSeason: Season.empty,
          numberOfAvailableSeasons: numberOfAvailableSeasons,
          lastUpdated: date,
        ),
        League(
          id: id,
          area: Area.empty,
          name: name,
          code: code,
          type: type,
          emblem: emblem,
          plan: plan,
          currentSeason: Season.empty,
          numberOfAvailableSeasons: numberOfAvailableSeasons,
          lastUpdated: date,
        ),
      );
    });

    test('fromJson works correctly', () {
      final json = <String, dynamic>{
        'id': id,
        'name': name,
        'code': code,
        'type': type,
        'emblem': emblem,
        'plan': plan,
        'numberOfAvailableSeasons': numberOfAvailableSeasons,
        'lastUpdated': Timestamp.fromDate(date),
        'currentSeason': {
          'startDate': '2023-01-01T00:00:00Z',
          'endDate': '2023-12-31T00:00:00Z',
        },
      };

      final parsed = League.fromJson(json);

      expect(parsed.id, id);
      expect(parsed.name, name);
      expect(parsed.code, code);
      expect(parsed.type, type);
      expect(parsed.lastUpdated, date.toLocal());
    });
  });
}
