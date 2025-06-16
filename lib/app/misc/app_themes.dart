import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData appDarkTheme({required bool isAmbientModeActive}) {
  return ThemeData(
    fontFamily: GoogleFonts.montserrat().fontFamily,
    useMaterial3: true,
    visualDensity: VisualDensity.compact,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.black,
    cardTheme: CardThemeData(
      color: const Color.fromRGBO(50, 49, 47, 1),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(
          isAmbientModeActive ? Colors.white24 : Colors.white,
        ),
        foregroundColor: WidgetStateProperty.all(
          isAmbientModeActive ? Colors.white : Colors.black,
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    ),
    dividerColor: Colors.transparent,
    colorScheme: isAmbientModeActive
        ? const ColorScheme.dark(
            primary: Colors.white24,
            onSurface: Colors.white10,
          )
        : const ColorScheme.dark(
            primary: Colors.white,
          ),
  );
}

ThemeData appLightTheme({required bool isAmbientModeActive}) {
  return ThemeData(
    fontFamily: GoogleFonts.montserrat().fontFamily,
    useMaterial3: true,
    visualDensity: VisualDensity.compact,
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    cardTheme: CardThemeData(
      color: const Color.fromARGB(255, 207, 207, 207),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(
          isAmbientModeActive ? Colors.black12 : Colors.black,
        ),
        foregroundColor: WidgetStateProperty.all(
          isAmbientModeActive ? Colors.black : Colors.white,
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    ),
    dividerColor: Colors.transparent,
    colorScheme: isAmbientModeActive
        ? const ColorScheme.light(
            primary: Colors.black12,
            onSurface: Colors.black26,
          )
        : const ColorScheme.light(
            primary: Colors.black,
          ),
  );
}
