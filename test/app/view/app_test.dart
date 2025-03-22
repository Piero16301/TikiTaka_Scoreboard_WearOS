import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiki_taka/ambient_mode/ambient_mode.dart';
import 'package:tiki_taka/app/app.dart';
import 'package:user_api_remote/user_api_remote.dart';
import 'package:user_repository/user_repository.dart';

import '../../helpers/helpers.dart';

void main() {
  group('App', () {
    setUpAll(() {
      AmbientModeListener.instance.value = false;
    });

    testWidgets('renders AppPage', (tester) async {
      final preferences = await SharedPreferences.getInstance();
      final userApi = UserApiRemote(preferences: preferences);
      final userRepository = UserRepository(userApi: userApi);
      await tester.pumpWidget(AppPage(userRepository: userRepository));
      expect(find.byType(AppPage), findsOneWidget);
    });

    group('renders the correct color scheme', () {
      testWidgets('on ambient mode updates', (tester) async {
        final preferences = await SharedPreferences.getInstance();
        final userApi = UserApiRemote(preferences: preferences);
        final userRepository = UserRepository(userApi: userApi);
        await tester.pumpWidget(AppPage(userRepository: userRepository));

        MaterialApp getMaterialApp() {
          return find.byType(MaterialApp).evaluate().first.widget
              as MaterialApp;
        }

        expect(
          getMaterialApp().theme?.colorScheme,
          const ColorScheme.dark(
            primary: Color(0xFF00B5FF),
          ),
        );

        await simulatePlatformCall('ambient_mode', 'onUpdateAmbient');
        await tester.pumpAndSettle();

        expect(
          getMaterialApp().theme?.colorScheme,
          const ColorScheme.dark(
            primary: Colors.white24,
            onSurface: Colors.white10,
          ),
        );

        await simulatePlatformCall('ambient_mode', 'onExitAmbient');
        await tester.pumpAndSettle();

        expect(
          getMaterialApp().theme?.colorScheme,
          const ColorScheme.dark(
            primary: Color(0xFF00B5FF),
          ),
        );
      });
    });
  });
}
