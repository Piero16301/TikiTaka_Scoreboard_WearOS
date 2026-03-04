import 'package:flutter/material.dart';

class AppThemes {
  static ThemeData globalTheme({
    required bool isAmbientModeActive,
    required Color baseColor,
    required String fontFamily,
  }) {
    return ThemeData(
      fontFamily: fontFamily,
      useMaterial3: true,
      visualDensity: VisualDensity.compact,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.black,
      pageTransitionsTheme: isAmbientModeActive
          ? const PageTransitionsTheme(
              builders: {
                TargetPlatform.android: ZoomPageTransitionsBuilder(),
              },
            )
          : null,
      cardTheme: CardThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      textTheme: isAmbientModeActive
          ? const TextTheme(
              bodyLarge: TextStyle(color: Colors.white70),
              bodyMedium: TextStyle(color: Colors.white60),
              bodySmall: TextStyle(color: Colors.white54),
            )
          : null,
      dividerColor: Colors.transparent,
      colorScheme: isAmbientModeActive
          ? ColorScheme.fromSeed(
              seedColor: Colors.white,
              brightness: Brightness.dark,
              primary: Colors.white70,
              onSurface: Colors.white54,
              surface: Colors.black,
              onPrimary: Colors.white70,
            )
          : ColorScheme.fromSeed(
              seedColor: baseColor,
              brightness: Brightness.dark,
              primary: Colors.white,
            ),
    );
  }
}
