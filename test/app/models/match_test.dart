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
          competition: League.empty,
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
          competition: League.empty,
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

    test('fromJson works correctly with all fields', () {
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
        'homeTeam': {'id': 1, 'name': 'H'},
        'awayTeam': {'id': 2, 'name': 'A'},
        'score': {'winner': 'HOME_TEAM'},
        'odds': {'message': 'odds'},
        'referees': [
          {'id': 1, 'name': 'R'},
          null,
        ],
        'area': {'id': 1, 'name': 'Area'},
        'competition': {'id': 1, 'name': 'League'},
      };

      final match = Match.fromJson(json);
      expect(match.id, id);
      expect(match.status, status);
      expect(match.utcDate, date.toLocal());
      expect(match.lastUpdated, date.toLocal());
      expect(match.homeTeam.id, 1);
      expect(match.awayTeam.id, 2);
      expect(match.score.winner, 'HOME_TEAM');
      expect(match.odds.message, 'odds');
      expect(match.referees, hasLength(2));
      expect(match.referees.last.id, 0);
      expect(match.area.name, 'Area');
      expect(match.competition.name, 'League');
    });

    test('fromJson handles missing fields with defaults', () {
      final match = Match.fromJson(const {});
      expect(match.id, 0);
      expect(match.status, '-');
      expect(match.matchday, 1);
      expect(match.referees, isEmpty);
    });

    test('empty match has correct default values', () {
      expect(Match.empty.id, 0);
      expect(Match.empty.status, '');
      expect(Match.empty.utcDate, null);
    });

    test('props is correct', () {
      expect(Match.empty.props, isNotEmpty);
    });
  });
}
