import 'package:flutter_test/flutter_test.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';

void main() {
  group('Contract', () {
    const start = '2023-01-01';
    const until = '2024-01-01';

    test('supports value comparisons', () {
      expect(
        const Contract(start: start, until: until),
        const Contract(start: start, until: until),
      );
    });

    test('fromJson works correctly', () {
      final json = <String, dynamic>{
        'start': start,
        'until': until,
      };

      expect(
        Contract.fromJson(json),
        const Contract(start: start, until: until),
      );
    });

    test('empty contract has correct default values', () {
      expect(Contract.empty.start, '');
      expect(Contract.empty.until, '');
    });
  });
}
