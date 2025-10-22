import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_api/user_api.dart';

/// {@template user_api_remote}
/// User API Remote Package
/// {@endtemplate}
class UserApiRemote implements IUserApi {
  /// {@macro user_api_remote}
  UserApiRemote({required SharedPreferences preferences})
    : _preferences = preferences;

  /// The key used to store enabled leagues
  static const kUserLeagues = '__user_leagues__';

  /// The key used to store the user's language
  static const kUserLanguage = '__user_language__';

  /// The key used to store the user's base color preference
  static const kUserBaseColor = '__user_base_color__';

  final SharedPreferences _preferences;

  @override
  Future<void> saveEnabledLeague({
    required String league,
    required bool enabled,
  }) async {
    final enabledLeagues = _preferences.getStringList(kUserLeagues) ?? [];
    if (enabled) {
      if (!enabledLeagues.contains(league)) {
        enabledLeagues.add(league);
      }
    } else {
      enabledLeagues.remove(league);
    }
    await _preferences.setStringList(kUserLeagues, enabledLeagues);
  }

  @override
  List<String> getEnabledLeagues() {
    return _preferences.getStringList(kUserLeagues) ?? [];
  }

  @override
  Future<void> saveLanguage({String language = 'es_ES'}) async {
    await _preferences.setString(kUserLanguage, language);
  }

  @override
  String? getLanguage() {
    return _preferences.getString(kUserLanguage);
  }

  @override
  Future<void> saveBaseColor({String baseColor = 'INDIGO'}) async {
    await _preferences.setString(kUserBaseColor, baseColor);
  }

  @override
  String? getBaseColor() {
    return _preferences.getString(kUserBaseColor);
  }
}
