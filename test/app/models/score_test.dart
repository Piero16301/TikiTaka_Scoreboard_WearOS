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
        ),
        const Score(
          winner: winner,
          duration: duration,
          fullTime: Time.empty,
          halfTime: Time.empty,
        ),
      );
    });

    test('fromJson works correctly', () {
      final json = <String, dynamic>{
        'winner': winner,
        'duration': duration,
      };

      expect(
        Score.fromJson(json),
        const Score(
          winner: winner,
          duration: duration,
          fullTime: Time.empty,
          halfTime: Time.empty,
        ),
      );
    });

    test('empty score has correct default values', () {
      expect(Score.empty.winner, '');
      expect(Score.empty.duration, '');
    });
  });
}
