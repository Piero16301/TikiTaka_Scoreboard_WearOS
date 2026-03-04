import 'package:flutter_test/flutter_test.dart';
import 'package:tiki_taka_scoreboard_wearos/app/models/area.dart';

void main() {
  group('Area', () {
    const id = 1;
    const name = 'Europe';
    const code = 'EUR';
    const flag = '🇪🇺';

    test('supports value comparisons', () {
      expect(
        const Area(id: id, name: name, code: code, flag: flag),
        const Area(id: id, name: name, code: code, flag: flag),
      );
    });

    test('fromJson works correctly', () {
      final json = <String, dynamic>{
        'id': id,
        'name': name,
        'code': code,
        'flag': flag,
      };

      expect(
        Area.fromJson(json),
        const Area(id: id, name: name, code: code, flag: flag),
      );
    });

    test('empty area has correct default values', () {
      expect(Area.empty.id, 0);
      expect(Area.empty.name, '');
      expect(Area.empty.code, '');
      expect(Area.empty.flag, '');
    });
  });
}
