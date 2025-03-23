import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiki_taka/ambient_mode/ambient_mode.dart';
import 'package:tiki_taka/app/app.dart';
import 'package:user_api_remote/user_api_remote.dart';
import 'package:user_repository/user_repository.dart';

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
  });
}
