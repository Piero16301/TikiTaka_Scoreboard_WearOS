import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';
import 'package:tiki_taka_scoreboard_wearos/l10n/l10n.dart';
import 'package:tiki_taka_scoreboard_wearos/typography/typography.dart';

class MockAppCubit extends MockCubit<AppState> implements AppCubit {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class FakeRoute extends Fake implements Route<dynamic> {}

void main() {
  group('TypographyPage and TypographyView', () {
    late MockAppCubit appCubit;
    late MockNavigatorObserver mockObserver;

    setUpAll(() {
      registerFallbackValue(FakeRoute());
    });

    setUp(() {
      appCubit = MockAppCubit();
      mockObserver = MockNavigatorObserver();
      when(() => appCubit.state).thenReturn(const AppState());
    });

    testWidgets('renders TypographyPage properly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: BlocProvider<AppCubit>.value(
            value: appCubit,
            child: const TypographyPage(),
          ),
        ),
      );

      expect(find.byType(TypographyPage), findsOneWidget);
      expect(find.byType(TypographyView), findsOneWidget);
      expect(find.byType(RadioGroup<String>), findsOneWidget);
    });

    testWidgets('changes font family on tap', (tester) async {
      when(
        () => appCubit.changeFontFamily(fontFamily: any(named: 'fontFamily')),
      ).thenAnswer((_) async {});

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: BlocProvider<AppCubit>.value(
            value: appCubit,
            child: const TypographyView(),
          ),
        ),
      );

      final radioGroupFinder = find.byType(RadioGroup<String>);
      final radioGroup = tester.widget<RadioGroup<String>>(radioGroupFinder);
      radioGroup.onChanged.call('Roboto');
      await tester.pumpAndSettle();

      verify(
        () => appCubit.changeFontFamily(fontFamily: any(named: 'fontFamily')),
      ).called(1);
    });

    testWidgets('navigates back when back button tapped', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          navigatorObservers: [mockObserver],
          home: BlocProvider<AppCubit>.value(
            value: appCubit,
            child: const TypographyView(),
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
