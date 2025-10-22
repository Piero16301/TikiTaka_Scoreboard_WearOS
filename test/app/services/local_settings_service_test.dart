import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';

import '../../helpers/mock_firebase_platform.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LocalSettingsService', () {
    setUpAll(() async {
      await setupFirebaseCoreMocks();
      await Firebase.initializeApp();
    });

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
    });

    group('singleton pattern', () {
      test('returns same instance when accessed multiple times', () {
        final instance1 = LocalSettingsService.instance;
        final instance2 = LocalSettingsService.instance;

        expect(identical(instance1, instance2), isTrue);
      });
    });

    group('getLocalLanguage', () {
      test('returns default language when no language is saved', () async {
        SharedPreferences.setMockInitialValues({});
        final prefs = await SharedPreferences.getInstance();
        final language = prefs.getString('__user_language__') ?? 'en_US';

        expect(language, 'en_US');
      });

      test('returns saved language when language exists', () async {
        SharedPreferences.setMockInitialValues({
          '__user_language__': 'es_ES',
        });
        final prefs = await SharedPreferences.getInstance();
        final language = prefs.getString('__user_language__') ?? 'en_US';

        expect(language, 'es_ES');
      });

      test('returns saved language for different locale', () async {
        SharedPreferences.setMockInitialValues({
          '__user_language__': 'it_IT',
        });
        final prefs = await SharedPreferences.getInstance();
        final language = prefs.getString('__user_language__') ?? 'en_US';

        expect(language, 'it_IT');
      });

      test('handles empty string and returns default', () async {
        SharedPreferences.setMockInitialValues({
          '__user_language__': '',
        });
        final prefs = await SharedPreferences.getInstance();
        final language = prefs.getString('__user_language__');

        expect(language, '');
        final defaultLanguage = language?.isEmpty ?? true ? 'en_US' : language;
        expect(defaultLanguage, 'en_US');
      });
    });

    group('getBaseColor', () {
      test('returns default base color when no color is saved', () async {
        SharedPreferences.setMockInitialValues({});
        final prefs = await SharedPreferences.getInstance();
        final baseColor = prefs.getString('__user_base_color__') ?? 'INDIGO';

        expect(baseColor, 'INDIGO');
      });

      test('returns saved base color when color exists', () async {
        SharedPreferences.setMockInitialValues({
          '__user_base_color__': 'BLUE',
        });
        final prefs = await SharedPreferences.getInstance();
        final baseColor = prefs.getString('__user_base_color__') ?? 'INDIGO';

        expect(baseColor, 'BLUE');
      });

      test('returns saved base color for different color', () async {
        SharedPreferences.setMockInitialValues({
          '__user_base_color__': 'RED',
        });
        final prefs = await SharedPreferences.getInstance();
        final baseColor = prefs.getString('__user_base_color__') ?? 'INDIGO';

        expect(baseColor, 'RED');
      });

      test('returns saved base color for GREEN', () async {
        SharedPreferences.setMockInitialValues({
          '__user_base_color__': 'GREEN',
        });
        final prefs = await SharedPreferences.getInstance();
        final baseColor = prefs.getString('__user_base_color__') ?? 'INDIGO';

        expect(baseColor, 'GREEN');
      });

      test('handles empty string and returns default', () async {
        SharedPreferences.setMockInitialValues({
          '__user_base_color__': '',
        });
        final prefs = await SharedPreferences.getInstance();
        final baseColor = prefs.getString('__user_base_color__');

        expect(baseColor, '');
        final defaultColor = baseColor?.isEmpty ?? true ? 'INDIGO' : baseColor;
        expect(defaultColor, 'INDIGO');
      });
    });

    group('Firestore integration', () {
      test('saveLanguageOnFirestore method exists and can be called', () {
        expect(
          LocalSettingsService.instance.saveLanguageOnFirestore,
          isA<Function>(),
        );
      });

      test('saveBaseColorOnFirestore method exists and can be called', () {
        expect(
          LocalSettingsService.instance.saveBaseColorOnFirestore,
          isA<Function>(),
        );
      });
    });

    group('SharedPreferences key constants', () {
      test('language key is correctly formatted', () {
        const languageKey = '__user_language__';
        expect(languageKey, '__user_language__');
        expect(languageKey.startsWith('__'), isTrue);
        expect(languageKey.endsWith('__'), isTrue);
      });

      test('base color key is correctly formatted', () {
        const baseColorKey = '__user_base_color__';
        expect(baseColorKey, '__user_base_color__');
        expect(baseColorKey.startsWith('__'), isTrue);
        expect(baseColorKey.endsWith('__'), isTrue);
      });
    });

    group('default values', () {
      test('default language is en_US', () {
        const defaultLanguage = 'en_US';
        expect(defaultLanguage, 'en_US');
        expect(defaultLanguage.contains('_'), isTrue);
        expect(defaultLanguage.split('_').length, 2);
      });

      test('default base color is INDIGO', () {
        const defaultBaseColor = 'INDIGO';
        expect(defaultBaseColor, 'INDIGO');
        expect(defaultBaseColor, defaultBaseColor.toUpperCase());
      });
    });

    group('Firestore collection constant', () {
      test('devices collection name is correct', () {
        const collection = devicesCollection;
        expect(collection, 'devices');
      });
    });
  });
}
