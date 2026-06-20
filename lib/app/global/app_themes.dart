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
      textTheme: ThemeData.dark().textTheme
          .apply(fontFamily: fontFamily)
          .applyFontVariations(
            const <FontVariation>[
              FontVariation('ROND', 100),
              FontVariation('wght', 500),
            ],
          ),
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

extension TextThemeFontVariations on TextTheme {
  TextTheme applyFontVariations(List<FontVariation> fontVariations) {
    return copyWith(
      displayLarge: displayLarge?.copyWith(fontVariations: fontVariations),
      displayMedium: displayMedium?.copyWith(fontVariations: fontVariations),
      displaySmall: displaySmall?.copyWith(fontVariations: fontVariations),
      headlineLarge: headlineLarge?.copyWith(fontVariations: fontVariations),
      headlineMedium: headlineMedium?.copyWith(fontVariations: fontVariations),
      headlineSmall: headlineSmall?.copyWith(fontVariations: fontVariations),
      titleLarge: titleLarge?.copyWith(fontVariations: fontVariations),
      titleMedium: titleMedium?.copyWith(fontVariations: fontVariations),
      titleSmall: titleSmall?.copyWith(fontVariations: fontVariations),
      bodyLarge: bodyLarge?.copyWith(fontVariations: fontVariations),
      bodyMedium: bodyMedium?.copyWith(fontVariations: fontVariations),
      bodySmall: bodySmall?.copyWith(fontVariations: fontVariations),
      labelLarge: labelLarge?.copyWith(fontVariations: fontVariations),
      labelMedium: labelMedium?.copyWith(fontVariations: fontVariations),
      labelSmall: labelSmall?.copyWith(fontVariations: fontVariations),
    );
  }
}
