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

void main() {
  group('LanguagesPage and LanguagesView', () {
    late MockAppCubit appCubit;

    setUpAll(() {
      registerFallbackValue(FakeRoute());
      registerFallbackValue(const Locale('en'));
    });

    setUp(() {
      appCubit = MockAppCubit();
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
  });
}
