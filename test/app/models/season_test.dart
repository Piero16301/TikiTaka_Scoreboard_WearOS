import 'package:flutter_test/flutter_test.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';

void main() {
  group('Season', () {
    const id = 1;
    final startDate = DateTime.utc(2023, 8).toLocal();
    final endDate = DateTime.utc(2024, 5).toLocal();
    const currentMatchday = 10;

    test('supports value comparisons', () {
      expect(
        Season(
          id: id,
          startDate: startDate,
          endDate: endDate,
          currentMatchday: currentMatchday,
          winner: Team.empty,
        ),
        Season(
          id: id,
          startDate: startDate,
          endDate: endDate,
          currentMatchday: currentMatchday,
          winner: Team.empty,
        ),
      );
    });

    test('fromJson works correctly', () {
      final json = <String, dynamic>{
        'id': id,
        'startDate': '2023-08-01T00:00:00Z',
        'endDate': '2024-05-01T00:00:00Z',
        'currentMatchday': currentMatchday,
      };

      final parsed = Season.fromJson(json);

      expect(parsed.id, id);
      expect(parsed.currentMatchday, currentMatchday);
      expect(
        parsed.startDate,
        DateTime.parse('2023-08-01T00:00:00Z').toLocal(),
      );
      expect(parsed.endDate, DateTime.parse('2024-05-01T00:00:00Z').toLocal());
    });

    test('fromJson works correctly with winner', () {
      final json = <String, dynamic>{
        'id': id,
        'startDate': '2023-08-01T00:00:00Z',
        'endDate': '2024-05-01T00:00:00Z',
        'currentMatchday': currentMatchday,
        'winner': {
          'id': 1,
          'name': 'Winner',
          'shortName': 'W',
          'tla': 'WWW',
          'crest': 'url',
        },
      };

      final parsed = Season.fromJson(json);
      expect(parsed.winner?.name, 'Winner');
    });

    test('fromJson handles null values and missing dates', () {
      final parsed = Season.fromJson(const {'id': 1, 'currentMatchday': 5});
      expect(parsed.id, 1);
      expect(parsed.startDate, isNull);
      expect(parsed.endDate, isNull);
    });

    test('empty season has correct default values', () {
      expect(Season.empty.id, 0);
      expect(Season.empty.startDate, null);
      expect(Season.empty.currentMatchday, 0);
    });
  });
}
