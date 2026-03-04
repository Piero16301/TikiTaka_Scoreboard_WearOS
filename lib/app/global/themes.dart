import 'package:flutter/material.dart';

class AppThemes {
  static ThemeData globalTheme({
    required Color baseColor,
    required String fontFamily,
  }) {
    return ThemeData(
      fontFamily: fontFamily,
      useMaterial3: true,
      visualDensity: VisualDensity.compact,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.black,
      cardTheme: CardThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      dividerColor: Colors.transparent,
      colorScheme: ColorScheme.fromSeed(
        seedColor: baseColor,
        brightness: Brightness.dark,
        primary: Colors.white,
      ),
    );
  }
}
