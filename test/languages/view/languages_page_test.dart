import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';
import 'package:tiki_taka_scoreboard_wearos/l10n/l10n.dart';
import 'package:tiki_taka_scoreboard_wearos/languages/languages.dart';

class MockAppCubit extends MockCubit<AppState> implements AppCubit {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class FakeRoute extends Fake implements Route<dynamic> {}

void main() {
  group('LanguagesPage and LanguagesView', () {
    late MockAppCubit appCubit;
    late MockNavigatorObserver mockObserver;

    setUpAll(() {
      registerFallbackValue(FakeRoute());
      registerFallbackValue(const Locale('en'));
    });

    setUp(() {
      appCubit = MockAppCubit();
      mockObserver = MockNavigatorObserver();
      when(() => appCubit.state).thenReturn(const AppState());
    });

    testWidgets('renders LanguagesPage properly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: BlocProvider<AppCubit>.value(
            value: appCubit,
            child: const LanguagesPage(),
          ),
        ),
      );

      expect(find.byType(LanguagesPage), findsOneWidget);
      expect(find.byType(LanguagesView), findsOneWidget);
      expect(find.byType(RadioGroup<Locale>), findsOneWidget);
    });

    testWidgets('changes language on tap', (tester) async {
      when(() => appCubit.changeLanguage(language: any(named: 'language')))
          .thenAnswer((_) async {});

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: BlocProvider<AppCubit>.value(
            value: appCubit,
            child: const LanguagesView(),
          ),
        ),
      );

      final radioGroupFinder = find.byType(RadioGroup<Locale>);
      final radioGroup = tester.widget<RadioGroup<Locale>>(radioGroupFinder);
      radioGroup.onChanged.call(const Locale('es'));
      await tester.pumpAndSettle();

      verify(() => appCubit.changeLanguage(language: any(named: 'language')))
          .called(1);
    });

    testWidgets('navigates back when back button tapped', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          navigatorObservers: [mockObserver],
          home: BlocProvider<AppCubit>.value(
            value: appCubit,
            child: const LanguagesView(),
          ),
        ),
      );

      final backBtn = find.byType(AppFilledButton);
      await tester.ensureVisible(backBtn);
      await tester.tap(backBtn);
      await tester.pumpAndSettle();

      verify(() => mockObserver.didPop(any(), any())).called(1);
    });
  });
}
