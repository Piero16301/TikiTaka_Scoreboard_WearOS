import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';
import 'package:tiki_taka_scoreboard_wearos/l10n/l10n.dart';
import 'package:tiki_taka_scoreboard_wearos/typography/typography.dart';

class MockAppCubit extends MockCubit<AppState> implements AppCubit {}

class FakeRoute extends Fake implements Route<dynamic> {}

class MockAnalyticsService extends Mock implements AnalyticsService {}

void main() {
  group('TypographyPage and TypographyView', () {
    late MockAppCubit appCubit;
    late MockAnalyticsService mockAnalytics;

    setUpAll(() {
      registerFallbackValue(FakeRoute());
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

    testWidgets('changes font family and logs analytics event on tap', (
      tester,
    ) async {
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

      await tester.tap(find.byType(CardFonts).first);
      await tester.pump();

      verify(
        () => appCubit.changeFontFamily(fontFamily: any(named: 'fontFamily')),
      ).called(1);
      verify(
        () => mockAnalytics.logEvent(
          name: 'font_family_changed',
          parameters: any(named: 'parameters'),
        ),
      ).called(1);
    });
  });
}
