import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiki_taka/app/app.dart';

class LocalSettingsService {
  LocalSettingsService._();

  static final LocalSettingsService instance = LocalSettingsService._();

  final firestore = FirebaseFirestore.instance;
  late SharedPreferences _preferences;

  Future<void> initialize() async {
    _preferences = await SharedPreferences.getInstance();
  }

  Future<String> getLocalLanguage() async {
    final localeString = _preferences.getString('__user_language__') ?? 'en_US';

    return localeString;
  }

  Future<bool> getDarkMode() async {
    final darkMode = _preferences.getBool('__user_dark_mode__') ?? false;

    return darkMode;
  }

  void saveLanguageOnFirestore({String language = 'en_US'}) {
    firestore
        .collection(notDevicesCollection)
        .doc(NotificationService.instance.token)
        .set(
      {
        'language': language,
      },
      SetOptions(merge: true),
    );
  }

  void saveDarkModeOnFirestore({bool darkMode = true}) {
    firestore
        .collection(notDevicesCollection)
        .doc(NotificationService.instance.token)
        .set(
      {
        'darkMode': darkMode,
      },
      SetOptions(merge: true),
    );
  }
}
