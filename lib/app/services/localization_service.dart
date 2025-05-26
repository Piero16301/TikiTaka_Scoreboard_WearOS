import 'dart:ui';

import 'package:tiki_taka/l10n/l10n.dart';

class LocalizationService {
  static Future<AppLocalizations> getLocalizations() async {
    final locale = PlatformDispatcher.instance.locale;
    return AppLocalizations.delegate.load(locale);
  }
}
