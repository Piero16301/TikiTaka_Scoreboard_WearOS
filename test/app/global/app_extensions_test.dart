import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';

void main() {
  group('Global Extensions', () {
    group('LocaleParser', () {
      test('toShortString formats properly with country code', () {
        const locale = Locale('es', 'ES');
        expect(locale.toShortString, 'es_ES');
      });

      test('toShortString formats properly without country code', () {
        const locale = Locale('es');
        expect(locale.toShortString, 'es');
      });
    });
  });
}
