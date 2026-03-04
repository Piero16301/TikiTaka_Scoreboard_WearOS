import 'package:flutter_test/flutter_test.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';

void main() {
  group('Time', () {
    const home = 2;
    const away = 1;

    test('supports value comparisons', () {
      expect(
        const Time(home: home, away: away),
        const Time(home: home, away: away),
      );
    });

    test('fromJson works correctly', () {
      final json = <String, dynamic>{
        'home': home,
        'away': away,
      };

      expect(
        Time.fromJson(json),
        const Time(home: home, away: away),
      );
    });

    test('empty time has correct default values', () {
      expect(Time.empty.home, 0);
      expect(Time.empty.away, 0);
    });
  });
}
