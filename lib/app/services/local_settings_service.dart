import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';

class LocalSettingsService {
  LocalSettingsService._();

  static final LocalSettingsService instance = LocalSettingsService._();

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late SharedPreferences _preferences;
  late AndroidDeviceInfo _androidInfo;
  PackageInfo _packageInfo = PackageInfo(
    appName: '',
    packageName: '',
    version: '',
    buildNumber: '',
  );

  void init(SharedPreferences preferences) {
    _preferences = preferences;
    unawaited(loadPlatformInfo());
  }

  Future<void> loadPlatformInfo() async {
    _androidInfo = await DeviceInfoPlugin().androidInfo;
    _packageInfo = await PackageInfo.fromPlatform();
  }

  Future<String> getLocalLanguage() async {
    final localeString = _preferences.getString('__user_language__') ?? 'en_US';

    return localeString;
  }

  Future<String> getBaseColor() async {
    final baseColor = _preferences.getString('__user_base_color__') ?? 'INDIGO';

    return baseColor;
  }

  void saveLanguageOnFirestore({String language = 'en_US'}) {
    unawaited(
      firestore
          .collection(AppVariables.devicesCollection)
          .doc(NotificationService.instance.token)
          .set(
        {
          'language': language,
        },
        SetOptions(merge: true),
      ),
    );
  }

  void saveBaseColorOnFirestore({String baseColor = 'INDIGO'}) {
    unawaited(
      firestore
          .collection(AppVariables.devicesCollection)
          .doc(NotificationService.instance.token)
          .set(
        {
          'baseColor': baseColor,
        },
        SetOptions(merge: true),
      ),
    );
  }

  AndroidDeviceInfo get androidInfo {
    return _androidInfo;
  }

  PackageInfo get packageInfo {
    return _packageInfo;
  }
}
