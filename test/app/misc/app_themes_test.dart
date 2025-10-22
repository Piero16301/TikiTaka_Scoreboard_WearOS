import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tiki_taka_scoreboard_wearos/app/misc/app_themes.dart';

void main() {
  group('AppThemes', () {
    testWidgets('creates theme with ambient mode active', (
      WidgetTester tester,
    ) async {
      final theme = AppThemes.globalTheme(
        isAmbientModeActive: true,
        baseColor: 'red',
      );

      expect(theme, isNotNull);
      expect(theme.brightness, equals(Brightness.dark));
      expect(theme.scaffoldBackgroundColor, equals(Colors.black));
      expect(theme.pageTransitionsTheme, isNotNull);
      expect(
        theme.pageTransitionsTheme.builders[TargetPlatform.android],
        isA<ZoomPageTransitionsBuilder>(),
      );

      expect(theme.textTheme, isNotNull);
      expect(theme.textTheme.bodyLarge?.color, equals(Colors.white70));
      expect(theme.textTheme.bodyMedium?.color, equals(Colors.white60));
      expect(theme.textTheme.bodySmall?.color, equals(Colors.white54));

      expect(theme.colorScheme.primary, equals(Colors.white70));
      expect(theme.colorScheme.onSurface, equals(Colors.white54));
      expect(theme.colorScheme.surface, equals(Colors.black));
      expect(theme.colorScheme.onPrimary, equals(Colors.white70));

      final buttonStyle = theme.elevatedButtonTheme.style;
      expect(buttonStyle, isNotNull);
      final backgroundColor = buttonStyle?.backgroundColor?.resolve({});
      expect(backgroundColor, equals(Colors.grey.shade900));

      await tester.pumpAndSettle();
    });

    testWidgets('creates theme without ambient mode', (
      WidgetTester tester,
    ) async {
      final theme = AppThemes.globalTheme(
        isAmbientModeActive: false,
        baseColor: 'blue',
      );

      expect(theme, isNotNull);
      expect(theme.brightness, equals(Brightness.dark));
      expect(theme.scaffoldBackgroundColor, equals(Colors.black));

      expect(theme.textTheme.bodyLarge?.color, isNot(equals(Colors.white70)));

      expect(theme.colorScheme.primary, equals(Colors.white));

      final buttonStyle = theme.elevatedButtonTheme.style;
      expect(buttonStyle, isNotNull);
      final backgroundColor = buttonStyle?.backgroundColor?.resolve({});
      expect(backgroundColor, isNotNull);
      expect(backgroundColor, isNot(equals(Colors.grey.shade900)));

      await tester.pumpAndSettle();
    });

    testWidgets('applies correct card theme', (WidgetTester tester) async {
      final theme = AppThemes.globalTheme(
        isAmbientModeActive: false,
        baseColor: 'green',
      );

      expect(theme.cardTheme, isNotNull);
      expect(theme.cardTheme.shape, isA<RoundedRectangleBorder>());
      final shape = theme.cardTheme.shape! as RoundedRectangleBorder;
      expect(
        shape.borderRadius,
        equals(BorderRadius.circular(20)),
      );

      await tester.pumpAndSettle();
    });

    testWidgets('applies correct elevated button theme', (
      WidgetTester tester,
    ) async {
      final theme = AppThemes.globalTheme(
        isAmbientModeActive: false,
        baseColor: 'purple',
      );

      final buttonStyle = theme.elevatedButtonTheme.style;
      expect(buttonStyle, isNotNull);

      final shape = buttonStyle?.shape?.resolve({});
      expect(shape, isA<RoundedRectangleBorder>());
      final roundedShape = shape! as RoundedRectangleBorder;
      expect(
        roundedShape.borderRadius,
        equals(BorderRadius.circular(20)),
      );

      await tester.pumpAndSettle();
    });

    testWidgets('uses Material 3 and compact visual density', (
      WidgetTester tester,
    ) async {
      final theme = AppThemes.globalTheme(
        isAmbientModeActive: false,
        baseColor: 'orange',
      );

      expect(theme.useMaterial3, isTrue);
      expect(theme.visualDensity, equals(VisualDensity.compact));

      await tester.pumpAndSettle();
    });

    testWidgets('sets transparent divider color', (WidgetTester tester) async {
      final theme = AppThemes.globalTheme(
        isAmbientModeActive: false,
        baseColor: 'yellow',
      );

      expect(theme.dividerColor, equals(Colors.transparent));

      await tester.pumpAndSettle();
    });

    testWidgets('works with different base colors', (
      WidgetTester tester,
    ) async {
      final colors = ['red', 'blue', 'green', 'purple', 'orange', 'yellow'];

      for (final color in colors) {
        final theme = AppThemes.globalTheme(
          isAmbientModeActive: false,
          baseColor: color,
        );

        expect(theme, isNotNull);
        expect(theme.colorScheme, isNotNull);
      }

      await tester.pumpAndSettle();
    });
  });
}
