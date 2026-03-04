import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';

class MockFirebaseMessaging extends Mock implements FirebaseMessaging {}

class MockDeviceInfoService extends Mock implements DeviceInfoService {}

class MockLocalStorageService extends Mock implements LocalStorageService {}

class MockDatabaseService extends Mock implements DatabaseService {}

class MockAndroidDeviceInfo extends Mock implements AndroidDeviceInfo {}

void main() {
  group('NotificationService', () {
    late MockFirebaseMessaging mockMessaging;
    late NotificationService notificationService;

    setUpAll(() {
      final mockDeviceInfo = MockDeviceInfoService();
      final mockLocalStorage = MockLocalStorageService();
      final mockDatabase = MockDatabaseService();

      final mockAndroidInfo = MockAndroidDeviceInfo();
      when(() => mockAndroidInfo.isPhysicalDevice).thenReturn(true);
      when(() => mockDeviceInfo.androidInfo).thenReturn(mockAndroidInfo);
      when(mockLocalStorage.getLanguage).thenReturn(const Locale('en', 'US'));

      if (!getIt.isRegistered<DeviceInfoService>()) {
        getIt.registerSingleton<DeviceInfoService>(mockDeviceInfo);
      }
      if (!getIt.isRegistered<LocalStorageService>()) {
        getIt.registerSingleton<LocalStorageService>(mockLocalStorage);
      }
      if (!getIt.isRegistered<DatabaseService>()) {
        getIt.registerSingleton<DatabaseService>(mockDatabase);
      }
    });

    setUp(() {
      mockMessaging = MockFirebaseMessaging();
      notificationService = NotificationService(messaging: mockMessaging);
    });

    test('subscribeToTopic delegates to messaging', () async {
      when(() => mockMessaging.subscribeToTopic(any()))
          .thenAnswer((_) async {});
      await notificationService.subscribeToTopic('test_topic');
      verify(() => mockMessaging.subscribeToTopic('test_topic')).called(1);
    });

    test('unsubscribeFromTopic delegates to messaging', () async {
      when(() => mockMessaging.unsubscribeFromTopic(any()))
          .thenAnswer((_) async {});
      await notificationService.unsubscribeFromTopic('test_topic');
      verify(() => mockMessaging.unsubscribeFromTopic('test_topic')).called(1);
    });

    test('token getter initially returns empty string', () {
      expect(notificationService.token, '');
    });
  });
}
