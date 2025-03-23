import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiki_taka/ambient_mode/ambient_mode.dart';
import 'package:tiki_taka/app/app.dart';
import 'package:user_api_remote/user_api_remote.dart';
import 'package:user_repository/user_repository.dart';

import 'app_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  group('App with SharedPreferences', () {
    late MockSharedPreferences mockPreferences;

    setUpAll(() {
      AmbientModeListener.instance.value = false;
    });

    setUp(() {
      mockPreferences = MockSharedPreferences();
    });

    testWidgets('renders AppPage with mocked SharedPreferences',
        (tester) async {
      when(mockPreferences.getString(any)).thenReturn('mock_value');
      when(mockPreferences.getBool(any)).thenReturn(true);
      final userApi = UserApiRemote(preferences: mockPreferences);
      final userRepository = UserRepository(userApi: userApi);

      await tester.pumpWidget(AppPage(userRepository: userRepository));

      expect(find.byType(AppPage), findsOneWidget);
    });

    testWidgets('handles missing SharedPreferences gracefully', (tester) async {
      when(mockPreferences.getString(any)).thenReturn('mock_value');
      when(mockPreferences.getBool(any)).thenReturn(true);
      final userApi = UserApiRemote(preferences: mockPreferences);
      final userRepository = UserRepository(userApi: userApi);

      await tester.pumpWidget(AppPage(userRepository: userRepository));

      expect(find.byType(AppPage), findsOneWidget);
    });
  });
}
