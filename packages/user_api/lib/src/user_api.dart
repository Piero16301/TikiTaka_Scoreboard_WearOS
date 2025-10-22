/// {@template user_api}
/// User API Package
/// {@endtemplate}
abstract class IUserApi {
  /// {@macro user_api}
  const IUserApi();

  /// Save enabled league in local storage
  Future<void> saveEnabledLeague({
    required String league,
    required bool enabled,
  });

  /// Get enabled leagues from local storage
  List<String> getEnabledLeagues();

  /// Save language in local storage
  Future<void> saveLanguage({String language = 'es_ES'});

  /// Get language from local storage
  String? getLanguage();

  /// Save base color in local storage
  Future<void> saveBaseColor({String baseColor = 'INDIGO'});

  /// Get base color from local storage
  String? getBaseColor();
}
