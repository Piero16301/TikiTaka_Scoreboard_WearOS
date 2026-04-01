import 'package:flutter_test/flutter_test.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';

void main() {
  group('Table', () {
    const position = 1;
    const playedGames = 38;
    const form = 'W,W,W,W,W';
    const won = 30;
    const draw = 5;
    const lost = 3;
    const points = 95;
    const goalsFor = 100;
    const goalsAgainst = 30;
    const goalDifference = 70;

    test('supports value comparisons', () {
      expect(
        const Table(
          position: position,
          team: Team.empty,
          playedGames: playedGames,
          form: form,
          won: won,
          draw: draw,
          lost: lost,
          points: points,
          goalsFor: goalsFor,
          goalsAgainst: goalsAgainst,
          goalDifference: goalDifference,
        ),
        const Table(
          position: position,
          team: Team.empty,
          playedGames: playedGames,
          form: form,
          won: won,
          draw: draw,
          lost: lost,
          points: points,
          goalsFor: goalsFor,
          goalsAgainst: goalsAgainst,
          goalDifference: goalDifference,
        ),
      );
    });

    test('fromJson works correctly', () {
      final json = <String, dynamic>{
        'position': position,
        'playedGames': playedGames,
        'form': form,
        'won': won,
        'draw': draw,
        'lost': lost,
        'points': points,
        'goalsFor': goalsFor,
        'goalsAgainst': goalsAgainst,
        'goalDifference': goalDifference,
      };

      expect(
        Table.fromJson(json),
        Table(
          position: position,
          team: Team.fromJson(const {}),
          playedGames: playedGames,
          form: form,
          won: won,
          draw: draw,
          lost: lost,
          points: points,
          goalsFor: goalsFor,
          goalsAgainst: goalsAgainst,
          goalDifference: goalDifference,
        ),
      );
    });

    test('empty table has correct default values', () {
      expect(Table.empty.position, 0);
      expect(Table.empty.playedGames, 0);
      expect(Table.empty.points, 0);
    });
  });
}
