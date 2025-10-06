import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiki_taka_scoreboard_wearos/ambient_mode/ambient_mode.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';
import 'package:user_api_remote/user_api_remote.dart';
import 'package:user_repository/user_repository.dart';

import '../../helpers/mock_firebase_platform.dart';
import 'app_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  group('App with SharedPreferences', () {
    late MockSharedPreferences mockPreferences;

    setUpAll(() async {
      AmbientModeListener.instance.value = false;
      WidgetsFlutterBinding.ensureInitialized();

      await setupFirebaseCoreMocks();
      await Firebase.initializeApp();
    });

    setUp(() {
      mockPreferences = MockSharedPreferences();
    });

    testWidgets('renders AppPage with mocked SharedPreferences', (
      tester,
    ) async {
      when(mockPreferences.getString(any)).thenReturn('mock_value');
      when(mockPreferences.getBool(any)).thenReturn(true);
      when(mockPreferences.getStringList(any)).thenReturn(['mock_league']);
      final userApi = UserApiRemote(preferences: mockPreferences);
      final userRepository = UserRepository(userApi: userApi);

      await tester.pumpWidget(
        MaterialApp(
          home: AppPage(userRepository: userRepository),
        ),
      );

      expect(find.byType(AppPage), findsOneWidget);
    });

    testWidgets(
      'renders AppPage with mocked SharedPreferences and no leagues',
      (tester) async {
        when(mockPreferences.getString(any)).thenReturn('mock_value');
        when(mockPreferences.getBool(any)).thenReturn(true);
        when(mockPreferences.getStringList(any)).thenReturn(null);
        final userApi = UserApiRemote(preferences: mockPreferences);
        final userRepository = UserRepository(userApi: userApi);

        await tester.pumpWidget(
          MaterialApp(
            home: AppPage(userRepository: userRepository),
          ),
        );

        expect(find.byType(AppPage), findsOneWidget);
      },
    );

    testWidgets(
      'renders AppPage with mocked SharedPreferences and empty leagues',
      (tester) async {
        when(mockPreferences.getString(any)).thenReturn('mock_value');
        when(mockPreferences.getBool(any)).thenReturn(true);
        when(mockPreferences.getStringList(any)).thenReturn([]);
        final userApi = UserApiRemote(preferences: mockPreferences);
        final userRepository = UserRepository(userApi: userApi);

        await tester.pumpWidget(
          MaterialApp(
            home: AppPage(userRepository: userRepository),
          ),
        );

        expect(find.byType(AppPage), findsOneWidget);
      },
    );
  });
}
