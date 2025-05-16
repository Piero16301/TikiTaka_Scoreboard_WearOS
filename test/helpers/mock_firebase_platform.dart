import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFirebasePlatform extends FirebasePlatform
    with Mock, MockPlatformInterfaceMixin {
  @override
  Future<FirebaseAppPlatform> initializeApp({
    String? name,
    FirebaseOptions? options,
  }) async {
    return MockFirebaseAppPlatform();
  }

  @override
  FirebaseAppPlatform app([String name = defaultFirebaseAppName]) {
    return MockFirebaseAppPlatform();
  }
}

class MockFirebaseAppPlatform extends FirebaseAppPlatform with Mock {
  MockFirebaseAppPlatform()
      : super(
          'mock_app',
          const FirebaseOptions(
            projectId: 'mock_project_id',
            apiKey: 'mock_api_key',
            appId: 'mock_app_id',
            messagingSenderId: 'mock_messaging_sender_id',
          ),
        );

  @override
  String get name => 'mock_app';
}

Future<void> setupFirebaseCoreMocks() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('plugins.flutter.io/firebase_core');
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
    channel,
    (MethodCall methodCall) async {
      if (methodCall.method == 'FirebaseCore#initializeCore') {
        return null;
      }
      throw MissingPluginException();
    },
  );

  Firebase.delegatePackingProperty = MockFirebasePlatform();
}
