import 'package:flutter/material.dart';

class AppThemes {
  static ThemeData globalTheme({
    required Color baseColor,
    required String fontFamily,
  }) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: baseColor,
      brightness: Brightness.dark,
    );

    return ThemeData(
      fontFamily: fontFamily,
      useMaterial3: true,
      visualDensity: VisualDensity.compact,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.black,
      dividerColor: Colors.transparent,
      colorScheme: ColorScheme.fromSeed(
        seedColor: baseColor,
        brightness: Brightness.dark,
      ),
      cardTheme: CardThemeData(
        color: colorScheme.surfaceContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        margin: EdgeInsets.zero,
      ),
    );
  }
}
