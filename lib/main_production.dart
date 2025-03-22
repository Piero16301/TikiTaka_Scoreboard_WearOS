import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tiki_taka/app/app.dart';
import 'package:tiki_taka/bootstrap.dart';
import 'package:tiki_taka/firebase_options.dart';

Future<void> main() async {
  // Ensure Firebase is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await bootstrap(() => const App());
}
