import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';
import 'package:tiki_taka_scoreboard_wearos/bootstrap.dart';
import 'package:tiki_taka_scoreboard_wearos/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with default options
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Setup service locator
  setupServiceLocator();

  await Future.wait([
    getIt<DeviceInfoService>().initialize(),
    getIt<LocalStorageService>().initialize(),
    getIt<NotificationService>().initialize(),
  ]);

  await bootstrap(AppPage.new);
}
