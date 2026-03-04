import 'package:flutter_test/flutter_test.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';

void main() {
  group('Odds', () {
    const homeWin = 1.5;
    const draw = 3.5;
    const awayWin = 5.0;

    test('supports value comparisons', () {
      expect(
        const Odds(homeWin: homeWin, draw: draw, awayWin: awayWin),
        const Odds(homeWin: homeWin, draw: draw, awayWin: awayWin),
      );
    });

    test('fromJson works correctly', () {
      final json = <String, dynamic>{
        'homeWin': homeWin,
        'draw': draw,
        'awayWin': awayWin,
      };

      expect(
        Odds.fromJson(json),
        const Odds(homeWin: homeWin, draw: draw, awayWin: awayWin),
      );
    });

    test('empty odds has correct default values', () {
      expect(Odds.empty.homeWin, 0.0);
      expect(Odds.empty.draw, 0.0);
      expect(Odds.empty.awayWin, 0.0);
    });
  });
}
