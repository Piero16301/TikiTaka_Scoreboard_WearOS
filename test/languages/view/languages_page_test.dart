import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';
import 'package:tiki_taka_scoreboard_wearos/l10n/l10n.dart';
import 'package:tiki_taka_scoreboard_wearos/languages/languages.dart';

class MockAppCubit extends MockCubit<AppState> implements AppCubit {}

class FakeRoute extends Fake implements Route<dynamic> {}

class MockAnalyticsService extends Mock implements AnalyticsService {}

void main() {
  group('LanguagesPage and LanguagesView', () {
    late MockAppCubit appCubit;
    late MockAnalyticsService mockAnalytics;

    setUpAll(() {
      registerFallbackValue(FakeRoute());
      registerFallbackValue(const Locale('en'));
    });

    setUp(() async {
      appCubit = MockAppCubit();
      mockAnalytics = MockAnalyticsService();
      when(() => appCubit.state).thenReturn(const AppState());
      when(
        () => mockAnalytics.logEvent(
          name: any(named: 'name'),
          parameters: any(named: 'parameters'),
        ),
      ).thenReturn(null);

      if (getIt.isRegistered<AnalyticsService>()) {
        await getIt.unregister<AnalyticsService>();
      }
      getIt.registerSingleton<AnalyticsService>(mockAnalytics);
    });

    tearDown(() async {
      if (getIt.isRegistered<AnalyticsService>()) {
        await getIt.unregister<AnalyticsService>();
      }
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

    testWidgets('changes language and logs analytics event on tap', (
      tester,
    ) async {
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

      await tester.tap(find.byType(CardLanguages).first);
      await tester.pump();

      verify(
        () => appCubit.changeLanguage(language: any(named: 'language')),
      ).called(1);
      verify(
        () => mockAnalytics.logEvent(
          name: 'language_changed',
          parameters: any(named: 'parameters'),
        ),
      ).called(1);
    });
  });
}
