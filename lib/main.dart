import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiki_taka/app/app.dart';
import 'package:tiki_taka/bootstrap.dart';
import 'package:tiki_taka/firebase_options.dart';
import 'package:user_api_remote/user_api_remote.dart';
import 'package:user_repository/user_repository.dart';

Future<void> main() async {
  // Ensure Firebase is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Get SharedPreferences instance
  final preferences = await SharedPreferences.getInstance();

  // Initialize User API
  final userApi = UserApiRemote(preferences: preferences);

  // Initialize User Repository
  final userRepository = UserRepository(userApi: userApi);

  // Initialize Local Settings Service
  await LocalSettingsService.instance.initialize();

  // Initialize Notification Service
  await NotificationService.instance.initialize();

  await bootstrap(
    () => AppPage(
      userRepository: userRepository,
    ),
  );
}
