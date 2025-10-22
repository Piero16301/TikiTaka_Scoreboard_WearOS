import 'dart:async';

import 'package:dash_flags/dash_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';
import 'package:tiki_taka_scoreboard_wearos/l10n/l10n.dart';
import 'package:tiki_taka_scoreboard_wearos/languages/languages.dart';
import 'package:wearable_rotary/wearable_rotary.dart';

import '../../helpers/helpers.dart';
import 'languages_view_test.mocks.dart';

@GenerateMocks([AppCubit])
void main() {
  late MockAppCubit mockAppCubit;
  late StreamController<RotaryEvent> rotaryController;

  setUp(() {
    mockAppCubit = MockAppCubit();
    rotaryController = StreamController<RotaryEvent>();

    when(mockAppCubit.state).thenReturn(const AppState());
    when(mockAppCubit.stream).thenAnswer((_) => const Stream<AppState>.empty());
  });

  tearDown(() {
    unawaited(rotaryController.close());
  });

  group('LanguagesView', () {
    testWidgets('renders correctly with default state', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: BlocProvider<AppCubit>.value(
            value: mockAppCubit,
            child: LanguagesView(
              rotaryEvents: rotaryController.stream,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(LanguagesView), findsOneWidget);
      expect(find.byType(RadioGroup<String>), findsOneWidget);
      expect(find.byType(CardLanguages), findsNWidgets(3));
      expect(find.byType(BackButtonLanguages), findsOneWidget);
    });

    testWidgets('displays all language options', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: BlocProvider<AppCubit>.value(
            value: mockAppCubit,
            child: LanguagesView(
              rotaryEvents: rotaryController.stream,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(CardLanguages), findsNWidgets(3));
      expect(find.byType(Radio<String>), findsNWidgets(3));
      expect(find.byType(CountryFlag), findsNWidgets(3));
    });

    testWidgets('renders correctly with English language selected', (
      tester,
    ) async {
      when(mockAppCubit.state).thenReturn(const AppState());

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: BlocProvider<AppCubit>.value(
            value: mockAppCubit,
            child: LanguagesView(
              rotaryEvents: rotaryController.stream,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(LanguagesView), findsOneWidget);
      expect(find.byType(RadioGroup<String>), findsOneWidget);
      expect(find.byType(CardLanguages), findsNWidgets(3));
    });

    testWidgets('renders correctly with Spanish language selected', (
      tester,
    ) async {
      when(mockAppCubit.state).thenReturn(const AppState(language: 'es_ES'));

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: BlocProvider<AppCubit>.value(
            value: mockAppCubit,
            child: LanguagesView(
              rotaryEvents: rotaryController.stream,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(LanguagesView), findsOneWidget);
      expect(mockAppCubit.state.language, 'es_ES');
    });

    testWidgets('renders correctly with Italian language selected', (
      tester,
    ) async {
      when(mockAppCubit.state).thenReturn(const AppState(language: 'it_IT'));

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: BlocProvider<AppCubit>.value(
            value: mockAppCubit,
            child: LanguagesView(
              rotaryEvents: rotaryController.stream,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(LanguagesView), findsOneWidget);
      expect(mockAppCubit.state.language, 'it_IT');
    });

    testWidgets('reflects selected language in UI state', (tester) async {
      when(mockAppCubit.state).thenReturn(const AppState(language: 'es_ES'));

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: BlocProvider<AppCubit>.value(
            value: mockAppCubit,
            child: LanguagesView(
              rotaryEvents: rotaryController.stream,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(mockAppCubit.state.language, 'es_ES');
    });

    testWidgets('has working scroll controller', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: BlocProvider<AppCubit>.value(
            value: mockAppCubit,
            child: LanguagesView(
              rotaryEvents: rotaryController.stream,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(AppRotaryScrollbar), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsWidgets);
    });
  });

  group('CardLanguages', () {
    testWidgets('renders with correct flag and language text', (tester) async {
      await tester.pumpApp(
        const CardLanguages(
          value: 'en_US',
          flag: 'US',
          language: 'English',
        ),
      );

      expect(find.byType(CardLanguages), findsOneWidget);
      expect(find.byType(CountryFlag), findsOneWidget);
      expect(find.byType(Radio<String>), findsOneWidget);
      expect(find.byType(ScrollText), findsOneWidget);
    });

    testWidgets('displays flag with correct country code', (tester) async {
      await tester.pumpApp(
        const CardLanguages(
          value: 'es_ES',
          flag: 'ES',
          language: 'Español',
        ),
      );

      expect(find.byType(CountryFlag), findsOneWidget);
    });

    testWidgets('has correct height and padding', (tester) async {
      await tester.pumpApp(
        const CardLanguages(
          value: 'it_IT',
          flag: 'IT',
          language: 'Italiano',
        ),
      );

      final sizedBox = tester.widget<SizedBox>(
        find.ancestor(
          of: find.byType(Card),
          matching: find.byType(SizedBox),
        ),
      );

      expect(sizedBox.height, 50);
    });

    testWidgets('radio has correct value', (tester) async {
      await tester.pumpApp(
        RadioGroup<String>(
          groupValue: 'en_US',
          onChanged: (_) {},
          child: const CardLanguages(
            value: 'en_US',
            flag: 'US',
            language: 'English',
          ),
        ),
      );

      final radio = tester.widget<Radio<String>>(find.byType(Radio<String>));
      expect(radio.value, 'en_US');
    });
  });

  group('BackButtonLanguages', () {
    testWidgets('renders correctly', (tester) async {
      await tester.pumpApp(const BackButtonLanguages());

      expect(find.byType(BackButtonLanguages), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('displays back text in uppercase', (tester) async {
      await tester.pumpApp(const BackButtonLanguages());

      expect(find.byType(Text), findsOneWidget);
    });

    testWidgets('calls Navigator.pop when pressed', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            appBar: AppBar(title: const Text('Test')),
            body: Builder(
              builder: (context) => Center(
                child: ElevatedButton(
                  onPressed: () {
                    unawaited(
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const Scaffold(
                            body: BackButtonLanguages(),
                          ),
                        ),
                      ),
                    );
                  },
                  child: const Text('Go'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Go'));
      await tester.pumpAndSettle();

      expect(find.byType(BackButtonLanguages), findsOneWidget);

      await tester.tap(find.byType(ElevatedButton).last);
      await tester.pumpAndSettle();

      expect(find.text('Go'), findsOneWidget);
      expect(find.byType(BackButtonLanguages), findsNothing);
    });

    testWidgets('has correct padding', (tester) async {
      await tester.pumpApp(const BackButtonLanguages());

      final padding = tester.widget<Padding>(
        find.ancestor(
          of: find.byType(ElevatedButton),
          matching: find.byType(Padding),
        ),
      );

      expect(
        padding.padding,
        const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      );
    });
  });
}
