import 'package:flutter_test/flutter_test.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';

void main() {
  group('Competition', () {
    const id = 1;
    const name = 'Champions League';
    const code = 'CL';
    const type = 'CUP';
    const emblem = 'emblem.png';

    test('supports value comparisons', () {
      expect(
        const Competition(
          id: id,
          name: name,
          code: code,
          type: type,
          emblem: emblem,
        ),
        const Competition(
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
        Competition.fromJson(json),
        const Competition(
          id: id,
          name: name,
          code: code,
          type: type,
          emblem: emblem,
        ),
      );
    });

    test('empty competition has correct default values', () {
      expect(Competition.empty.id, 0);
      expect(Competition.empty.name, '');
      expect(Competition.empty.code, '');
    });
  });
}
