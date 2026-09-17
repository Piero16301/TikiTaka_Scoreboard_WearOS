import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';
import 'package:tiki_taka_scoreboard_wearos/match/match.dart';

class MockFirebaseMessaging extends Mock implements FirebaseMessaging {}

class MockCrashService extends Mock implements CrashService {}

class MockDeviceInfoService extends Mock implements DeviceInfoService {}

class MockLocalStorageService extends Mock implements LocalStorageService {}

class MockDatabaseService extends Mock implements DatabaseService {}

class MockNotificationSettings extends Mock implements NotificationSettings {}

class FakeRemoteMessage extends Fake implements RemoteMessage {}

class FakeNotificationSettings extends Fake implements NotificationSettings {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('FirebaseNotificationRepository', () {
    late MockFirebaseMessaging mockMessaging;
    late MockCrashService mockCrashService;
    late MockDeviceInfoService mockDeviceInfoService;
    late MockLocalStorageService mockLocalStorageService;
    late MockDatabaseService mockDatabaseService;
    late FirebaseNotificationRepository repository;

    setUpAll(() async {
      registerFallbackValue(FakeRemoteMessage());
      registerFallbackValue(FakeNotificationSettings());
    });

    setUp(() async {
      mockMessaging = MockFirebaseMessaging();
      mockCrashService = MockCrashService();
      mockDeviceInfoService = MockDeviceInfoService();
      mockLocalStorageService = MockLocalStorageService();
      mockDatabaseService = MockDatabaseService();

      if (getIt.isRegistered<CrashService>()) {
        await getIt.unregister<CrashService>();
      }
      getIt.registerSingleton<CrashService>(mockCrashService);

      if (getIt.isRegistered<DeviceInfoService>()) {
        await getIt.unregister<DeviceInfoService>();
      }
      getIt.registerSingleton<DeviceInfoService>(mockDeviceInfoService);

      if (getIt.isRegistered<LocalStorageService>()) {
        await getIt.unregister<LocalStorageService>();
      }
      getIt.registerSingleton<LocalStorageService>(mockLocalStorageService);

      if (getIt.isRegistered<DatabaseService>()) {
        await getIt.unregister<DatabaseService>();
      }
      getIt.registerSingleton<DatabaseService>(mockDatabaseService);

      repository = FirebaseNotificationRepository(
        messaging: mockMessaging,
        crashService: mockCrashService,
      );
    });

    test(
      'initialize runs requestPermission and getToken successfully',
      () async {
        final settings = MockNotificationSettings();
        when(
          () => settings.authorizationStatus,
        ).thenReturn(AuthorizationStatus.authorized);
        when(
          () => mockMessaging.requestPermission(),
        ).thenAnswer((_) async => settings);
        when(
          () => mockMessaging.getToken(),
        ).thenAnswer((_) async => 'fake-token');

        await repository.initialize();
        expect(repository.token, 'fake-token');
      },
    );

    test('initialize records error when Future.wait throws', () async {
      when(
        () => mockMessaging.requestPermission(),
      ).thenThrow(Exception('Perm failure'));
      await repository.initialize();
      verify(
        () => mockCrashService.recordError(
          any<Object>(),
          any<StackTrace?>(),
          reason: 'NotificationRepository initialize/getToken error',
        ),
      ).called(1);
    });

    test("handleBackgroundMessage doesn't crash on simple messages", () {
      expect(
        () => repository.handleBackgroundMessage('random message'),
        returnsNormally,
      );
    });

    test('requestPermission coverage for all status values', () async {
      final settings = MockNotificationSettings();

      when(
        () => settings.authorizationStatus,
      ).thenReturn(AuthorizationStatus.denied);
      when(
        () => mockMessaging.requestPermission(),
      ).thenAnswer((_) async => settings);
      await repository.requestPermission();

      when(
        () => settings.authorizationStatus,
      ).thenReturn(AuthorizationStatus.provisional);
      await repository.requestPermission();

      when(
        () => settings.authorizationStatus,
      ).thenReturn(AuthorizationStatus.notDetermined);
      await repository.requestPermission();

      when(
        () => settings.authorizationStatus,
      ).thenReturn(AuthorizationStatus.deniedPermanently);
      await repository.requestPermission();
    });

    test('getToken records error when token is null', () async {
      when(() => mockMessaging.getToken()).thenAnswer((_) async => null);

      final token = await repository.getToken();
      expect(token, isNull);

      verify(
        () => mockCrashService.recordError(
          any<Object>(),
          any<StackTrace?>(),
          reason: 'NotificationRepository getToken error',
        ),
      ).called(1);
    });

    test('getToken records error when getToken throws', () async {
      final exception = Exception('Token fetch failed');
      when(() => mockMessaging.getToken()).thenThrow(exception);

      final token = await repository.getToken();
      expect(token, isNull);

      verify(
        () => mockCrashService.recordError(
          exception,
          any<StackTrace?>(),
          reason: 'NotificationRepository getToken error',
        ),
      ).called(1);
    });

    test('streams and getters delegate properly', () async {
      when(
        () => mockMessaging.onTokenRefresh,
      ).thenAnswer((_) => const Stream.empty());
      when(
        () => mockMessaging.getInitialMessage(),
      ).thenAnswer((_) async => null);

      expect(repository.onTokenRefresh, isNotNull);
      expect(repository.onMessage, isNotNull);
      expect(repository.onMessageOpenedApp, isNotNull);
      expect(await repository.getInitialMessage(), isNull);
    });

    test(
      'subscribeToTopic delegates to messaging and logs error on catch',
      () async {
        when(
          () => mockMessaging.subscribeToTopic(any()),
        ).thenAnswer((_) async {});
        await repository.subscribeToTopic('test-topic');
        verify(() => mockMessaging.subscribeToTopic('test-topic')).called(1);

        when(
          () => mockMessaging.subscribeToTopic(any()),
        ).thenThrow(Exception('subscribe failed'));
        await repository.subscribeToTopic('fail-topic');
        verify(
          () => mockCrashService.recordError(
            any<Object>(),
            any<StackTrace?>(),
            reason: 'NotificationRepository subscribeToTopic error',
          ),
        ).called(1);
      },
    );

    test(
      'unsubscribeFromTopic delegates to messaging and logs error on catch',
      () async {
        when(
          () => mockMessaging.unsubscribeFromTopic(any()),
        ).thenAnswer((_) async {});
        await repository.unsubscribeFromTopic('test-topic');
        verify(
          () => mockMessaging.unsubscribeFromTopic('test-topic'),
        ).called(1);

        when(
          () => mockMessaging.unsubscribeFromTopic(any()),
        ).thenThrow(Exception('unsubscribe failed'));
        await repository.unsubscribeFromTopic('fail-topic');
        verify(
          () => mockCrashService.recordError(
            any<Object>(),
            any<StackTrace?>(),
            reason: 'NotificationRepository unsubscribeFromTopic error',
          ),
        ).called(1);
      },
    );

    test(
      'handleBackgroundMessage parses matchId variants and fallback digits',
      () {
        expect(
          () => repository.handleBackgroundMessage('matchId:123'),
          returnsNormally,
        );
        expect(
          () => repository.handleBackgroundMessage('matchId:invalid'),
          returnsNormally,
        );
        expect(
          () => repository.handleBackgroundMessage('match_789'),
          returnsNormally,
        );
        expect(
          () => repository.handleBackgroundMessage('no_digits_here'),
          returnsNormally,
        );
      },
    );

    testWidgets(
      'handleBackgroundMessage navigates when navigator has mounted state',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            navigatorKey: AppVariables.navigatorKey,
            routes: {
              MatchPage.routeName: (_) =>
                  const Scaffold(body: Text('MatchTarget')),
            },
            home: const Scaffold(body: Text('HomeTarget')),
          ),
        );

        repository.handleBackgroundMessage('matchId:888');
        await tester.pumpAndSettle();
        expect(find.text('MatchTarget'), findsOneWidget);

        repository.handleBackgroundMessage('digits_999');
        await tester.pumpAndSettle();
      },
    );
  });

  group('MockNotificationRepository', () {
    test('methods execute without error and provide dummy data', () async {
      final mockRepo = MockNotificationRepository();

      expect(mockRepo.initialize(), completes);
      expect(mockRepo.token, 'dummy-token');
      expect(await mockRepo.getToken(), 'dummy-token');
      expect(await mockRepo.getInitialMessage(), isNull);
      expect(mockRepo.onTokenRefresh, emitsDone);
      expect(mockRepo.onMessage, emitsDone);
      expect(mockRepo.onMessageOpenedApp, emitsDone);

      await mockRepo.subscribeToTopic('topic');
      await mockRepo.unsubscribeFromTopic('topic');
      await mockRepo.requestPermission();
      mockRepo.handleBackgroundMessage('random message');
    });
  });
}
