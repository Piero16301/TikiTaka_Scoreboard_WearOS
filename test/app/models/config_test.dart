import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tiki_taka_scoreboard_wearos/app/models/config.dart';

void main() {
  group('Config', () {
    const id = 'config_id';
    final date = DateTime.utc(2023);

    test('supports value comparisons', () {
      expect(
        Config(id: id, lastUpdate: date),
        Config(id: id, lastUpdate: date),
      );
    });

    test('fromJson works correctly', () {
      final json = <String, dynamic>{
        'id': id,
        'lastUpdate': Timestamp.fromDate(date),
      };

      expect(
        Config.fromJson(json),
        Config(id: id, lastUpdate: date.toLocal()),
      );
    });
  });
}
