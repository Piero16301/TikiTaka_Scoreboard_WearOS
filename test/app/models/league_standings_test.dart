import 'package:flutter_test/flutter_test.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';

void main() {
  group('LeagueStandings', () {
    const standing = Standing(
      stage: 'REGULAR',
      type: 'TOTAL',
      table: [
        Table(
          position: 1,
          team: Team(
            id: 1,
            name: 'Team A',
            shortName: 'A',
            tla: 'AAA',
            crest: 'url',
          ),
          playedGames: 1,
          form: 'W',
          won: 1,
          draw: 0,
          lost: 0,
          points: 3,
          goalsFor: 2,
          goalsAgainst: 0,
          goalDifference: 2,
        ),
      ],
    );

    const leagueStandings = LeagueStandings(
      leagueId: 'PL',
      standings: [standing],
    );

    test('supports value equality', () {
      expect(
        leagueStandings,
        equals(
          const LeagueStandings(
            leagueId: 'PL',
            standings: [standing],
          ),
        ),
      );
    });

    test('props are correct', () {
      expect(leagueStandings.props, [
        'PL',
        [standing],
      ]);
    });

    test('fromJson returns correct instance', () {
      final json = {
        'leagueId': 'PL',
        'standings': [
          {
            'stage': 'REGULAR',
            'type': 'TOTAL',
            'group': null,
            'table': [
              {
                'position': 1,
                'team': {
                  'id': 1,
                  'name': 'Team A',
                  'shortName': 'A',
                  'tla': 'AAA',
                  'crest': 'url',
                },
                'playedGames': 1,
                'form': 'W',
                'won': 1,
                'draw': 0,
                'lost': 0,
                'points': 3,
                'goalsFor': 2,
                'goalsAgainst': 0,
                'goalDifference': 2,
              },
            ],
          },
        ],
      };

      expect(LeagueStandings.fromJson(json), leagueStandings);
    });

    test('fromJson handles missing fields with defaults', () {
      final parsed = LeagueStandings.fromJson(const {});
      expect(parsed.leagueId, isEmpty);
      expect(parsed.standings, isEmpty);
    });

    test('LeagueStandings.empty is correct', () {
      expect(LeagueStandings.empty.leagueId, isEmpty);
      expect(LeagueStandings.empty.standings, isEmpty);
    });
  });
}
