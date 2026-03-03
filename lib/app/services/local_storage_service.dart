import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';

class LocalStorageService {
  LocalStorageService() : _prefs = null;

  SharedPreferences? _prefs;

  /// Keys to save user preferences
  static const kUserLeagues = '__user_leagues__';
  static const kUserLanguage = '__user_language__';
  static const kUserBaseColor = '__user_base_color__';
  static const kUserFontFamily = '__user_font_family__';

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  void saveEnabledLeague({
    required String league,
    required bool enabled,
  }) {
    final enabledLeagues = _prefs?.getStringList(kUserLeagues) ?? [];
    if (enabled) {
      if (!enabledLeagues.contains(league)) {
        enabledLeagues.add(league);
      }
    } else {
      enabledLeagues.remove(league);
    }
    _prefs?.setStringList(kUserLeagues, enabledLeagues).ignore();
  }

  List<String>? getEnabledLeagues() {
    return _prefs?.getStringList(kUserLeagues);
  }

  void saveLanguage({required Locale language}) {
    final languageString = '${language.languageCode}_${language.countryCode}';
    _prefs?.setString(kUserLanguage, languageString).ignore();
  }

  Locale? getLanguage() {
    final languageString = _prefs?.getString(kUserLanguage);
    if (languageString == null) {
      return null;
    }
    final languageParts = languageString.split('_');
    return Locale(languageParts.first, languageParts.last);
  }

  void saveBaseColor({required Color baseColor}) {
    _prefs
        ?.setString(kUserBaseColor, ColorHelper.getColorName(baseColor))
        .ignore();
  }

  Color? getBaseColor() {
    final baseColorString = _prefs?.getString(kUserBaseColor);
    if (baseColorString == null) {
      return null;
    }
    return ColorHelper.getColorByName(baseColorString);
  }

  void saveFontFamily({required String fontFamily}) {
    _prefs?.setString(kUserFontFamily, fontFamily).ignore();
  }

  String? getFontFamily() {
    return _prefs?.getString(kUserFontFamily);
  }
}
