import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';

void main() {
  group('Match', () {
    const id = 1;
    const status = 'FINISHED';
    const matchday = 10;
    const stage = 'REGULAR_SEASON';
    const group = 'GROUP_A';
    final date = DateTime.utc(2023);

    test('supports value comparisons', () {
      expect(
        Match(
          area: Area.empty,
          competition: Competition.empty,
          season: Season.empty,
          id: id,
          utcDate: date,
          status: status,
          matchday: matchday,
          stage: stage,
          group: group,
          lastUpdated: date,
          homeTeam: Team.empty,
          awayTeam: Team.empty,
          score: Score.empty,
          odds: Odds.empty,
          referees: const [],
        ),
        Match(
          area: Area.empty,
          competition: Competition.empty,
          season: Season.empty,
          id: id,
          utcDate: date,
          status: status,
          matchday: matchday,
          stage: stage,
          group: group,
          lastUpdated: date,
          homeTeam: Team.empty,
          awayTeam: Team.empty,
          score: Score.empty,
          odds: Odds.empty,
          referees: const [],
        ),
      );
    });

    test('fromJson works correctly', () {
      final json = <String, dynamic>{
        'id': id,
        'utcDate': Timestamp.fromDate(date),
        'status': status,
        'matchday': matchday,
        'stage': stage,
        'group': group,
        'lastUpdated': Timestamp.fromDate(date),
        'season': {
          'startDate': '2023-01-01T00:00:00Z',
          'endDate': '2023-12-31T00:00:00Z',
        },
      };

      final match = Match.fromJson(json);
      expect(match.id, id);
      expect(match.status, status);
      expect(match.utcDate, date.toLocal());
      expect(match.lastUpdated, date.toLocal());
    });

    test('empty match has correct default values', () {
      expect(Match.empty.id, 0);
      expect(Match.empty.status, '');
      expect(Match.empty.utcDate, null);
    });
  });
}
