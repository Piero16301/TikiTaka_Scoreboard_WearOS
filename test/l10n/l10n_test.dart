import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tiki_taka_scoreboard_wearos/l10n/l10n.dart';

void main() {
  const localizationsDelegates = [
    AppLocalizations.delegate,
    ...GlobalMaterialLocalizations.delegates,
  ];

  group('AppLocalizationsX', () {
    testWidgets('l10n returns AppLocalizations instance', (tester) async {
      late BuildContext capturedContext;

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) {
              capturedContext = context;
              return Container();
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      final localizations = capturedContext.l10n;

      expect(localizations, isA<AppLocalizations>());
    });

    testWidgets('l10n returns correct locale instance', (tester) async {
      late BuildContext capturedContext;

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('es'),
          localizationsDelegates: localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) {
              capturedContext = context;
              return Container();
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      final localizations = capturedContext.l10n;

      expect(localizations, isA<AppLocalizations>());
      expect(localizations.localeName, equals('es'));
    });

    testWidgets('l10n works with English locale', (tester) async {
      late BuildContext capturedContext;

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) {
              capturedContext = context;
              return Container();
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      final localizations = capturedContext.l10n;

      expect(localizations, isA<AppLocalizations>());
      expect(localizations.localeName, equals('en'));
    });

    testWidgets('l10n works with Italian locale', (tester) async {
      late BuildContext capturedContext;

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('it'),
          localizationsDelegates: localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) {
              capturedContext = context;
              return Container();
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      final localizations = capturedContext.l10n;

      expect(localizations, isA<AppLocalizations>());
      expect(localizations.localeName, equals('it'));
    });

    testWidgets('l10n can be called multiple times from same context', (
      tester,
    ) async {
      late BuildContext capturedContext;

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) {
              capturedContext = context;
              return Container();
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      final localizations1 = capturedContext.l10n;
      final localizations2 = capturedContext.l10n;

      expect(localizations1, isA<AppLocalizations>());
      expect(localizations2, isA<AppLocalizations>());
      expect(localizations1, equals(localizations2));
    });

    testWidgets('l10n is accessible in widget build method', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) {
              final localizations = context.l10n;
              expect(localizations, isA<AppLocalizations>());
              return Text(localizations.localeName);
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(Text), findsOneWidget);
    });

    testWidgets('l10n extension can access localized strings', (tester) async {
      late BuildContext capturedContext;

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) {
              capturedContext = context;
              return Container();
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      final localizations = capturedContext.l10n;

      expect(localizations.localeName, isNotEmpty);
    });

    testWidgets('l10n fallbacks to default locale when unsupported', (
      tester,
    ) async {
      late BuildContext capturedContext;

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('fr'),
          localizationsDelegates: localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) {
              capturedContext = context;
              return Container();
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      final localizations = capturedContext.l10n;

      expect(localizations, isA<AppLocalizations>());
      expect(
        AppLocalizations.supportedLocales
            .map((l) => l.languageCode)
            .contains(localizations.localeName),
        isTrue,
      );
    });
  });
}
