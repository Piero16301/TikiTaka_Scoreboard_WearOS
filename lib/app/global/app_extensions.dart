import 'package:flutter/material.dart';

extension LocaleParser on Locale {
  String get toShortString {
    if (countryCode == null) return languageCode;
    return '${languageCode}_$countryCode';
  }
}
