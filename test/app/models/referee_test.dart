import 'package:flutter_test/flutter_test.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';

void main() {
  group('Referee', () {
    const id = 1;
    const name = 'Pierluigi Collina';
    const type = 'REFEREE';
    const nationality = 'Italy';

    test('supports value comparisons', () {
      expect(
        const Referee(id: id, name: name, type: type, nationality: nationality),
        const Referee(id: id, name: name, type: type, nationality: nationality),
      );
    });

    test('fromJson works correctly', () {
      final json = <String, dynamic>{
        'id': id,
        'name': name,
        'type': type,
        'nationality': nationality,
      };

      expect(
        Referee.fromJson(json),
        const Referee(id: id, name: name, type: type, nationality: nationality),
      );
    });
  });
}
