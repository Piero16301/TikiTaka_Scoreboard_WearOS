import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  group('SharedPrefsLocalStorageRepository', () {
    late MockSharedPreferences mockPrefs;
    late SharedPrefsLocalStorageRepository repository;

    setUp(() {
      mockPrefs = MockSharedPreferences();
      repository = SharedPrefsLocalStorageRepository(prefs: mockPrefs);
    });

    group('Leagues', () {
      test('saveEnabledLeague adds league if not present', () async {
        when(
          () => mockPrefs.getStringList(LocalStorageRepository.kUserLeagues),
        ).thenReturn(['CL']);
        when(
          () => mockPrefs.setStringList(
            LocalStorageRepository.kUserLeagues,
            any(),
          ),
        ).thenAnswer((_) async => true);

        repository.saveEnabledLeague(league: 'PL', enabled: true);

        verify(
          () => mockPrefs.setStringList(
            LocalStorageRepository.kUserLeagues,
            ['CL', 'PL'],
          ),
        ).called(1);
      });

      test('saveEnabledLeague removes league if disabled', () async {
        when(
          () => mockPrefs.getStringList(LocalStorageRepository.kUserLeagues),
        ).thenReturn(['CL', 'PL']);
        when(
          () => mockPrefs.setStringList(
            LocalStorageRepository.kUserLeagues,
            any(),
          ),
        ).thenAnswer((_) async => true);

        repository.saveEnabledLeague(league: 'PL', enabled: false);

        verify(
          () => mockPrefs.setStringList(
            LocalStorageRepository.kUserLeagues,
            ['CL'],
          ),
        ).called(1);
      });

      test('getEnabledLeagues returns list', () {
        when(
          () => mockPrefs.getStringList(LocalStorageRepository.kUserLeagues),
        ).thenReturn(['PL']);

        final result = repository.getEnabledLeagues();

        expect(result, ['PL']);
      });
    });

    group('Language', () {
      test('saveLanguage formats correctly', () {
        when(
          () => mockPrefs.setString(
            LocalStorageRepository.kUserLanguage,
            any(),
          ),
        ).thenAnswer((_) async => true);

        repository.saveLanguage(language: const Locale('en', 'US'));

        verify(
          () => mockPrefs.setString(
            LocalStorageRepository.kUserLanguage,
            'en_US',
          ),
        ).called(1);
      });

      test('getLanguage parses correctly', () {
        when(
          () => mockPrefs.getString(LocalStorageRepository.kUserLanguage),
        ).thenReturn('es_ES');

        final result = repository.getLanguage();

        expect(result, const Locale('es', 'ES'));
      });

      test('getLanguage returns null if not set', () {
        when(
          () => mockPrefs.getString(LocalStorageRepository.kUserLanguage),
        ).thenReturn(null);

        final result = repository.getLanguage();

        expect(result, isNull);
      });
    });

    group('BaseColor', () {
      test('saveBaseColor uses ColorHelper name', () {
        when(
          () => mockPrefs.setString(
            LocalStorageRepository.kUserBaseColor,
            any(),
          ),
        ).thenAnswer((_) async => true);

        repository.saveBaseColor(baseColor: Colors.red);

        verify(
          () => mockPrefs.setString(
            LocalStorageRepository.kUserBaseColor,
            'RED',
          ),
        ).called(1);
      });

      test('getBaseColor returns color from helper', () {
        when(
          () => mockPrefs.getString(LocalStorageRepository.kUserBaseColor),
        ).thenReturn('RED');

        final result = repository.getBaseColor();

        expect(result, Colors.red);
      });

      test('getBaseColor returns null if not set', () {
        when(
          () => mockPrefs.getString(LocalStorageRepository.kUserBaseColor),
        ).thenReturn(null);

        final result = repository.getBaseColor();

        expect(result, isNull);
      });
    });

    group('FontFamily', () {
      test('saveFontFamily saves string directly', () {
        when(
          () => mockPrefs.setString(
            LocalStorageRepository.kUserFontFamily,
            any(),
          ),
        ).thenAnswer((_) async => true);

        repository.saveFontFamily(fontFamily: 'Roboto');

        verify(
          () => mockPrefs.setString(
            LocalStorageRepository.kUserFontFamily,
            'Roboto',
          ),
        ).called(1);
      });

      test('getFontFamily returns string', () {
        when(
          () => mockPrefs.getString(LocalStorageRepository.kUserFontFamily),
        ).thenReturn('Roboto');

        final result = repository.getFontFamily();

        expect(result, 'Roboto');
      });
    });
  });

  group('MockLocalStorageRepository', () {
    test('methods execute without error', () {
      final mock = MockLocalStorageRepository();

      expect(mock.initialize, returnsNormally);
      expect(
        () => mock.saveEnabledLeague(league: 'test', enabled: true),
        returnsNormally,
      );
      expect(mock.getEnabledLeagues(), isA<List<String>>());
      expect(
        () => mock.saveLanguage(language: const Locale('en', 'US')),
        returnsNormally,
      );
      expect(mock.getLanguage(), isA<Locale>());
      expect(
        () => mock.saveBaseColor(baseColor: Colors.red),
        returnsNormally,
      );
      expect(mock.getBaseColor(), isA<Color>());
      expect(
        () => mock.saveFontFamily(fontFamily: 'OpenSans'),
        returnsNormally,
      );
      expect(mock.getFontFamily(), isA<String>());
    });
  });
}
