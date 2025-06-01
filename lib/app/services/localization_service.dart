import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiki_taka/l10n/l10n.dart';

class LocalizationService {
  static Future<AppLocalizations> getLocalizations() async {
    final prefs = await SharedPreferences.getInstance();
    final localeString = prefs.getString('__user_language__') ?? 'en';
    final localeParts = localeString.split('_');

    final locale = localeParts.length > 1
        ? Locale(localeParts[0], localeParts[1])
        : Locale(localeParts[0]);

    return AppLocalizations.delegate.load(locale);
  }
}
