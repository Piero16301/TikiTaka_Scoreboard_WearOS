import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';
import 'package:tiki_taka_scoreboard_wearos/bootstrap.dart';
import 'package:tiki_taka_scoreboard_wearos/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with default options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  const currentEnv = Environment.prod;

  // Setup service locator
  setupServiceLocator(currentEnv);

  getIt<CrashService>()
    ..log('Application initialization started')
    ..setCustomKey('environment', currentEnv.toString())
    ..setCustomKey('debug_mode', kDebugMode.toString());

  // Initialize services and plugins in parallel
  final performance = getIt<PerformanceService>();
  final trace = performance.startTrace('app_initialization');
  await Future.wait([
    getIt<DeviceInfoService>().initialize(),
    getIt<LocalStorageService>().initialize(),
  ]);

  // Inicio notificaciones al final por dependencia de DeviceInfo y LocalStorage
  await getIt<NotificationService>().initialize();

  performance.stopTrace(trace);

  await bootstrap(AppPage.new);
}
