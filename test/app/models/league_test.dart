import 'package:flutter_test/flutter_test.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';

void main() {
  group('League', () {
    const id = 1;
    const name = 'Champions League';
    const code = 'CL';
    const type = 'CUP';
    const emblem = 'emblem.png';

    test('supports value comparisons', () {
      expect(
        const League(
          id: id,
          name: name,
          code: code,
          type: type,
          emblem: emblem,
        ),
        const League(
          id: id,
          name: name,
          code: code,
          type: type,
          emblem: emblem,
        ),
      );
    });

    test('fromJson works correctly', () {
      final json = <String, dynamic>{
        'id': id,
        'name': name,
        'code': code,
        'type': type,
        'emblem': emblem,
      };

      expect(
        League.fromJson(json),
        const League(
          id: id,
          name: name,
          code: code,
          type: type,
          emblem: emblem,
        ),
      );
    });

    test('empty league has correct default values', () {
      expect(League.empty.id, 0);
      expect(League.empty.name, '');
      expect(League.empty.code, '');
    });
  });
}
