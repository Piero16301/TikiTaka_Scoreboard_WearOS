import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';
import 'package:tiki_taka_scoreboard_wearos/l10n/l10n.dart';
import 'package:tiki_taka_scoreboard_wearos/languages/languages.dart';

import 'languages_page_test.mocks.dart';

@GenerateMocks([AppCubit])
void main() {
  late MockAppCubit mockAppCubit;

  setUp(() {
    mockAppCubit = MockAppCubit();
    when(mockAppCubit.state).thenReturn(const AppState());
    when(mockAppCubit.stream).thenAnswer((_) => const Stream<AppState>.empty());
  });

  group('LanguagesPage', () {
    testWidgets('renders LanguagesView', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: BlocProvider<AppCubit>.value(
            value: mockAppCubit,
            child: const LanguagesPage(),
          ),
        ),
      );

      expect(find.byType(LanguagesView), findsOneWidget);
    });

    testWidgets('has correct route name', (tester) async {
      expect(LanguagesPage.routeName, '/languages');
    });
  });
}
