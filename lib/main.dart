import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';
import 'package:tiki_taka_scoreboard_wearos/bootstrap.dart';
import 'package:tiki_taka_scoreboard_wearos/firebase_options.dart';
import 'package:user_api_remote/user_api_remote.dart';
import 'package:user_repository/user_repository.dart';

Future<void> main() async {
  // Ensure Firebase is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase and SharedPreferences in parallel
  final [_, preferences] = await Future.wait([
    Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    ),
    SharedPreferences.getInstance(),
  ]);

  // Cast preferences to SharedPreferences since Future.wait returns
  // List<dynamic> or List<Object?>
  final sharedPreferences = preferences as SharedPreferences;

  // Initialize Local Settings Service synchronously
  LocalSettingsService.instance.init(sharedPreferences);

  // Initialize User API
  final userApi = UserApiRemote(preferences: sharedPreferences);

  // Initialize User Repository
  final userRepository = UserRepository(userApi: userApi);

  // Notification Service initialization moved to background in AppCubit

  await bootstrap(
    () => AppPage(
      userRepository: userRepository,
    ),
  );
}
