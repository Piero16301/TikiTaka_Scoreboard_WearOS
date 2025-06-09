import 'package:shared_preferences/shared_preferences.dart';

class LocalizationService {
  static Future<String> getLocalLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final localeString = prefs.getString('__user_language__') ?? 'en_US';

    return localeString;
  }
}
