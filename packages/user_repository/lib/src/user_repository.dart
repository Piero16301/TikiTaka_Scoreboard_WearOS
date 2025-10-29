import 'package:user_api/user_api.dart';

/// {@template user_repository}
/// User Repository Package
/// {@endtemplate}
class UserRepository {
  /// {@macro user_repository}
  const UserRepository({required IUserApi userApi}) : _userApi = userApi;

  final IUserApi _userApi;

  /// Save enabled league in local storage
  Future<void> saveEnabledLeague({
    required String league,
    required bool enabled,
  }) => _userApi.saveEnabledLeague(league: league, enabled: enabled);

  /// Get enabled leagues from local storage
  List<String> getEnabledLeagues() => _userApi.getEnabledLeagues();

  /// Save language in local storage
  Future<void> saveLanguage({String language = 'es_ES'}) =>
      _userApi.saveLanguage(language: language);

  /// Get language from local storage
  String? getLanguage() => _userApi.getLanguage();

  /// Save base color in local storage
  Future<void> saveBaseColor({String baseColor = 'INDIGO'}) =>
      _userApi.saveBaseColor(baseColor: baseColor);

  /// Get save color from local storage
  String? getBaseColor() => _userApi.getBaseColor();
}
