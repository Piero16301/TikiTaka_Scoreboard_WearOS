import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';

void main() {
  group('LocalStorageService', () {
    late LocalStorageService service;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      service = LocalStorageService();
      await service.initialize();
    });

    test('initializes correctly', () {
      expect(service.getEnabledLeagues(), null);
    });

    group('Enabled Leagues', () {
      test('saves single string properly', () {
        service.saveEnabledLeague(league: 'PL', enabled: true);
        expect(service.getEnabledLeagues(), ['PL']);
      });

      test('removes league properly', () {
        service
          ..saveEnabledLeague(league: 'PL', enabled: true)
          ..saveEnabledLeague(league: 'LL', enabled: true)
          ..saveEnabledLeague(league: 'PL', enabled: false);
        expect(service.getEnabledLeagues(), ['LL']);
      });

      test('does not add duplicate league', () {
        service
          ..saveEnabledLeague(league: 'PL', enabled: true)
          ..saveEnabledLeague(league: 'PL', enabled: true);
        expect(service.getEnabledLeagues(), ['PL']);
      });
    });

    group('Language', () {
      test('saves and gets language properly', () {
        const locale = Locale('es', 'ES');
        service.saveLanguage(language: locale);
        expect(service.getLanguage(), locale);
      });

      test('returns null if no language is set', () {
        expect(service.getLanguage(), null);
      });
    });

    group('Base Color', () {
      test('saves and gets base color properly', () {
        const color = Colors.red;
        service.saveBaseColor(baseColor: color);
        expect(service.getBaseColor(), color);
      });

      test('returns null if no color is set', () {
        expect(service.getBaseColor(), null);
      });
    });

    group('Font Family', () {
      test('saves and gets font family properly', () {
        const font = 'Roboto';
        service.saveFontFamily(fontFamily: font);
        expect(service.getFontFamily(), font);
      });

      test('returns null if no font family is set', () {
        expect(service.getFontFamily(), null);
      });
    });
  });
}
