import 'package:flutter_test/flutter_test.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';

void main() {
  group('Score', () {
    const winner = 'HOME_TEAM';
    const duration = 'REGULAR';

    test('supports value comparisons', () {
      expect(
        const Score(
          winner: winner,
          duration: duration,
          fullTime: Time.empty,
          halfTime: Time.empty,
        ).props,
        isNotEmpty,
      );
    });

    test('fromJson works correctly with all fields', () {
      final json = <String, dynamic>{
        'winner': winner,
        'duration': duration,
        'halfTime': {'home': 0, 'away': 0},
        'fullTime': {'home': 1, 'away': 1},
        'regularTime': {'home': 1, 'away': 1},
        'extraTime': {'home': 0, 'away': 0},
        'penalties': {'home': 4, 'away': 5},
      };

      final score = Score.fromJson(json);
      expect(score.winner, winner);
      expect(score.duration, duration);
      expect(score.regularTime, isNotNull);
      expect(score.extraTime, isNotNull);
      expect(score.penalties, isNotNull);
    });

    test('empty score has correct default values', () {
      expect(Score.empty.winner, '');
      expect(Score.empty.duration, '');
    });
  });
}
