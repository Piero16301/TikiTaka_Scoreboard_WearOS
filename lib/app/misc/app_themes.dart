import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';

class AppThemes {
  static ThemeData globalTheme({
    required bool isAmbientModeActive,
    required String baseColor,
  }) {
    final color = AppHelpers.getColorByName(baseColor);
    final baseTheme = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: color,
        brightness: Brightness.dark,
      ),
    );

    return ThemeData(
      fontFamily: GoogleFonts.montserrat().fontFamily,
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
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(
            isAmbientModeActive
                ? Colors.grey.shade900
                : baseTheme.colorScheme.primaryContainer,
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
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
              seedColor: color,
              brightness: Brightness.dark,
              primary: Colors.white,
            ),
    );
  }
}
