import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';

abstract class LocalStorageRepository {
  static const kUserLeagues = '__user_leagues__';
  static const kUserLanguage = '__user_language__';
  static const kUserBaseColor = '__user_base_color__';
  static const kUserFontFamily = '__user_font_family__';

  Future<void> initialize();
  void saveEnabledLeague({required String league, required bool enabled});
  List<String>? getEnabledLeagues();
  void saveLanguage({required Locale language});
  Locale? getLanguage();
  void saveBaseColor({required Color baseColor});
  Color? getBaseColor();
  void saveFontFamily({required String fontFamily});
  String? getFontFamily();
}

class MockLocalStorageRepository implements LocalStorageRepository {
  @override
  Future<void> initialize() async {}

  @override
  void saveEnabledLeague({required String league, required bool enabled}) {}

  @override
  List<String>? getEnabledLeagues() {
    return ['CL', 'PL'];
  }

  @override
  void saveLanguage({required Locale language}) {}

  @override
  Locale? getLanguage() {
    return const Locale('en', 'US');
  }

  @override
  void saveBaseColor({required Color baseColor}) {}

  @override
  Color? getBaseColor() {
    return Colors.blue;
  }

  @override
  void saveFontFamily({required String fontFamily}) {}

  @override
  String? getFontFamily() {
    return 'default';
  }
}

class SharedPrefsLocalStorageRepository implements LocalStorageRepository {
  SharedPrefsLocalStorageRepository({SharedPreferences? prefs})
      : _prefs = prefs;

  SharedPreferences? _prefs;

  @override
  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  @override
  void saveEnabledLeague({required String league, required bool enabled}) {
    final enabledLeagues =
        _prefs?.getStringList(LocalStorageRepository.kUserLeagues) ?? [];
    if (enabled) {
      if (!enabledLeagues.contains(league)) {
        enabledLeagues.add(league);
      }
    } else {
      enabledLeagues.remove(league);
    }
    _prefs
        ?.setStringList(LocalStorageRepository.kUserLeagues, enabledLeagues)
        .ignore();
  }

  @override
  List<String>? getEnabledLeagues() {
    return _prefs?.getStringList(LocalStorageRepository.kUserLeagues);
  }

  @override
  void saveLanguage({required Locale language}) {
    final languageString = '${language.languageCode}_${language.countryCode}';
    _prefs
        ?.setString(LocalStorageRepository.kUserLanguage, languageString)
        .ignore();
  }

  @override
  Locale? getLanguage() {
    final languageString =
        _prefs?.getString(LocalStorageRepository.kUserLanguage);
    if (languageString == null) {
      return null;
    }
    final languageParts = languageString.split('_');
    return Locale(languageParts.first, languageParts.last);
  }

  @override
  void saveBaseColor({required Color baseColor}) {
    _prefs
        ?.setString(
          LocalStorageRepository.kUserBaseColor,
          ColorHelper.getColorName(baseColor),
        )
        .ignore();
  }

  @override
  Color? getBaseColor() {
    final baseColorString =
        _prefs?.getString(LocalStorageRepository.kUserBaseColor);
    if (baseColorString == null) {
      return null;
    }
    return ColorHelper.getColorByName(baseColorString);
  }

  @override
  void saveFontFamily({required String fontFamily}) {
    _prefs
        ?.setString(
          LocalStorageRepository.kUserFontFamily,
          fontFamily,
        )
        .ignore();
  }

  @override
  String? getFontFamily() {
    return _prefs?.getString(LocalStorageRepository.kUserFontFamily);
  }
}
