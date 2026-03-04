import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';
import 'package:tiki_taka_scoreboard_wearos/l10n/l10n.dart';
import 'package:tiki_taka_scoreboard_wearos/themes/themes.dart';

class MockAppCubit extends MockCubit<AppState> implements AppCubit {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class FakeRoute extends Fake implements Route<dynamic> {}

void main() {
  group('ThemesPage and ThemesView', () {
    late MockAppCubit appCubit;
    late MockNavigatorObserver mockObserver;

    setUpAll(() {
      registerFallbackValue(FakeRoute());
      registerFallbackValue(const Color(0xFF000000));
    });

    setUp(() {
      appCubit = MockAppCubit();
      mockObserver = MockNavigatorObserver();
      when(() => appCubit.state).thenReturn(const AppState());
    });

    testWidgets('renders ThemesPage properly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: BlocProvider<AppCubit>.value(
            value: appCubit,
            child: const ThemesPage(),
          ),
        ),
      );

      expect(find.byType(ThemesPage), findsOneWidget);
      expect(find.byType(ThemesView), findsOneWidget);
      expect(find.byType(RadioGroup<Color>), findsOneWidget);
    });

    testWidgets('changes base color on tap', (tester) async {
      when(() => appCubit.changeBaseColor(baseColor: any(named: 'baseColor')))
          .thenAnswer((_) async {});

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: BlocProvider<AppCubit>.value(
            value: appCubit,
            child: const ThemesView(),
          ),
        ),
      );

      final radioGroupFinder = find.byType(RadioGroup<Color>);
      final radioGroup = tester.widget<RadioGroup<Color>>(radioGroupFinder);
      radioGroup.onChanged.call(const Color(0xFF000000));
      await tester.pumpAndSettle();

      verify(() => appCubit.changeBaseColor(baseColor: any(named: 'baseColor')))
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
            child: const ThemesView(),
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
