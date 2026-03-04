import 'package:flutter_test/flutter_test.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';

void main() {
  group('Standing', () {
    const stage = 'REGULAR_SEASON';
    const type = 'TOTAL';
    const group = 'GROUP_A';

    test('supports value comparisons', () {
      expect(
        const Standing(stage: stage, type: type, group: group, table: []),
        const Standing(stage: stage, type: type, group: group, table: []),
      );
    });

    test('fromJson works correctly', () {
      final json = <String, dynamic>{
        'stage': stage,
        'type': type,
        'group': group,
      };

      expect(
        Standing.fromJson(json),
        const Standing(stage: stage, type: type, group: group, table: []),
      );
    });

    test('empty standing has correct default values', () {
      expect(Standing.empty.stage, '');
      expect(Standing.empty.type, '');
      expect(Standing.empty.group, '');
    });
  });
}
