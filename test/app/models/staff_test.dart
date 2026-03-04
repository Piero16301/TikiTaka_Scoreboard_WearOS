import 'package:flutter_test/flutter_test.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';

void main() {
  group('Staff', () {
    const id = 1;
    const firstName = 'Pep';
    const lastName = 'Guardiola';
    const name = 'Pep Guardiola';
    const dateOfBirth = '1971-01-18';
    const nationality = 'Spain';
    const position = 'Manager';

    test('supports value comparisons', () {
      expect(
        const Staff(
          id: id,
          firstName: firstName,
          lastName: lastName,
          name: name,
          dateOfBirth: dateOfBirth,
          nationality: nationality,
          contract: Contract.empty,
          position: position,
        ),
        const Staff(
          id: id,
          firstName: firstName,
          lastName: lastName,
          name: name,
          dateOfBirth: dateOfBirth,
          nationality: nationality,
          contract: Contract.empty,
          position: position,
        ),
      );
    });

    test('fromJson works correctly', () {
      final json = <String, dynamic>{
        'id': id,
        'firstName': firstName,
        'lastName': lastName,
        'name': name,
        'dateOfBirth': dateOfBirth,
        'nationality': nationality,
        'position': position,
      };

      expect(
        Staff.fromJson(json),
        const Staff(
          id: id,
          firstName: firstName,
          lastName: lastName,
          name: name,
          dateOfBirth: dateOfBirth,
          nationality: nationality,
          contract: Contract.empty,
          position: position,
        ),
      );
    });

    test('empty staff has correct default values', () {
      expect(Staff.empty.id, 0);
      expect(Staff.empty.name, '');
    });
  });
}
