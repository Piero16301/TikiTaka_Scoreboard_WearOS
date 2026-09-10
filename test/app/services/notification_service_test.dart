import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';
import 'package:tiki_taka_scoreboard_wearos/match/match.dart';

class MockNotificationRepository extends Mock
    implements NotificationRepository {}

class MockPerformanceService extends Mock implements PerformanceService {}

class MockCrashService extends Mock implements CrashService {}

class MockDatabaseService extends Mock implements DatabaseService {}

class MockDeviceInfoService extends Mock implements DeviceInfoService {}

class MockLocalStorageService extends Mock implements LocalStorageService {}

class MockTrace extends Mock implements Trace {}

class MockNavigatorState extends Mock implements NavigatorState {
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) =>
      'MockNavigatorState';
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('NotificationService', () {
    late MockNotificationRepository mockRepository;
    late MockPerformanceService mockPerformance;
    late MockCrashService mockCrash;
    late MockDatabaseService mockDatabase;
    late MockDeviceInfoService mockDeviceInfo;
    late MockLocalStorageService mockLocalStorage;
    late StreamController<RemoteMessage> onMessageController;
    late StreamController<RemoteMessage> onMessageOpenedAppController;
    late StreamController<String> onTokenRefreshController;
    late NotificationService notificationService;

    setUpAll(() async {
      registerFallbackValue(MockTrace());
      registerFallbackValue(
        const AppDeviceInfo(id: 'test', isPhysicalDevice: true),
      );
      registerFallbackValue(const Locale('es'));
      registerFallbackValue(
        const RemoteMessage(notification: RemoteNotification()),
      );
    });

    setUp(() {
      mockRepository = MockNotificationRepository();
      mockPerformance = MockPerformanceService();
      mockCrash = MockCrashService();
      mockDatabase = MockDatabaseService();
      mockDeviceInfo = MockDeviceInfoService();
      mockLocalStorage = MockLocalStorageService();

      onMessageController = StreamController<RemoteMessage>.broadcast();
      onMessageOpenedAppController =
          StreamController<RemoteMessage>.broadcast();
      onTokenRefreshController = StreamController<String>.broadcast();

      when(() => mockPerformance.startTrace(any())).thenReturn(MockTrace());
      when(() => mockPerformance.stopTrace(any())).thenReturn(null);

      when(
        () => mockRepository.onMessage,
      ).thenAnswer((_) => onMessageController.stream);
      when(
        () => mockRepository.onMessageOpenedApp,
      ).thenAnswer((_) => onMessageOpenedAppController.stream);
      when(
        () => mockRepository.onTokenRefresh,
      ).thenAnswer((_) => onTokenRefreshController.stream);
      when(
        () => mockRepository.getInitialMessage(),
      ).thenAnswer((_) async => null);
      when(() => mockRepository.token).thenReturn('mock_token_123');
      when(() => mockRepository.initialize()).thenAnswer((_) async {});
      when(
        () => mockRepository.subscribeToTopic(any()),
      ).thenAnswer((_) async {});
      when(
        () => mockRepository.unsubscribeFromTopic(any()),
      ).thenAnswer((_) async {});

      when(
        () => mockDeviceInfo.deviceInfo,
      ).thenReturn(const AppDeviceInfo(id: 'device-1', isPhysicalDevice: true));
      when(() => mockLocalStorage.getLanguage()).thenReturn(const Locale('es'));
      when(
        () => mockDatabase.updateDeviceSettings(
          token: any(named: 'token'),
          deviceInfo: any(named: 'deviceInfo'),
          language: any(named: 'language'),
        ),
      ).thenReturn(null);

      notificationService = NotificationService(
        notificationRepository: mockRepository,
        databaseService: mockDatabase,
        deviceInfoService: mockDeviceInfo,
        localStorageService: mockLocalStorage,
        performanceService: mockPerformance,
        crashService: mockCrash,
      );
    });

    tearDown(() async {
      await notificationService.dispose();
      await onMessageController.close();
      await onMessageOpenedAppController.close();
      await onTokenRefreshController.close();
    });

    test(
      'initialize calls repository, syncs device, and performs tracing',
      () async {
        await notificationService.initialize();

        verify(
          () =>
              mockPerformance.startTrace('notification_service_initialization'),
        ).called(1);
        verify(() => mockRepository.initialize()).called(1);
        verify(() => mockPerformance.stopTrace(any())).called(1);

        verify(
          () => mockDatabase.updateDeviceSettings(
            token: 'mock_token_123',
            deviceInfo: any(named: 'deviceInfo'),
            language: const Locale('es'),
          ),
        ).called(1);
        verify(
          () => mockRepository.subscribeToTopic(AppVariables.allDevicesTopic),
        ).called(1);
        verify(
          () => mockRepository.subscribeToTopic(AppVariables.wearOSTopic),
        ).called(1);
      },
    );

    test('calling initialize multiple times returns same future', () async {
      final f1 = notificationService.initialize();
      final f2 = notificationService.initialize();
      expect(f1, equals(f2));
      await f1;
    });

    test(
      'initialize handles emulator by not subscribing to wearOS topic',
      () async {
        when(() => mockDeviceInfo.deviceInfo).thenReturn(
          const AppDeviceInfo(id: 'device-1', isPhysicalDevice: false),
        );

        await notificationService.initialize();

        verify(
          () => mockRepository.subscribeToTopic(AppVariables.allDevicesTopic),
        ).called(1);
        verifyNever(
          () => mockRepository.subscribeToTopic(AppVariables.wearOSTopic),
        );
      },
    );

    test('onMessage stream receives foreground message', () async {
      await notificationService.initialize();

      const message = RemoteMessage(
        notification: RemoteNotification(title: 'T', body: 'B'),
      );
      onMessageController.add(message);
      await pumpEventQueue();
    });

    test(
      'onMessageOpenedApp stream event triggers onMatchNotificationOpened',
      () async {
        int? openedMatchId;
        await notificationService.initialize(
          onMatchNotificationOpened: (id) => openedMatchId = id,
        );

        const message = RemoteMessage(data: {'match': 'matchId:101'});
        onMessageOpenedAppController.add(message);
        await pumpEventQueue();

        expect(openedMatchId, 101);
      },
    );

    test('onTokenRefresh stream event triggers syncDeviceAndTopics', () async {
      await notificationService.initialize();

      onTokenRefreshController.add('new_refreshed_token');
      await pumpEventQueue();

      verify(
        () => mockDatabase.updateDeviceSettings(
          token: 'new_refreshed_token',
          deviceInfo: any(named: 'deviceInfo'),
          language: const Locale('es'),
        ),
      ).called(1);
    });

    test('subscribeToTopic delegates to repository', () async {
      await notificationService.subscribeToTopic('test_topic');
      verify(() => mockRepository.subscribeToTopic('test_topic')).called(1);
    });

    test('unsubscribeFromTopic delegates to repository', () async {
      await notificationService.unsubscribeFromTopic('test_topic');
      verify(() => mockRepository.unsubscribeFromTopic('test_topic')).called(1);
    });

    test('token getter returns token from repository', () {
      expect(notificationService.token, 'mock_token_123');
    });

    test('initialize handles initial message with direct integer id', () async {
      int? navigatedMatchId;
      const initialMessage = RemoteMessage(data: {'matchId': 456});
      when(
        () => mockRepository.getInitialMessage(),
      ).thenAnswer((_) async => initialMessage);

      await notificationService.initialize(
        onMatchNotificationOpened: (id) => navigatedMatchId = id,
      );

      expect(navigatedMatchId, 456);
    });

    test('initialize handles message without valid matchId', () async {
      int? navigatedMatchId;
      const initialMessage = RemoteMessage(data: {'otherKey': 'value'});
      when(
        () => mockRepository.getInitialMessage(),
      ).thenAnswer((_) async => initialMessage);

      await notificationService.initialize(
        onMatchNotificationOpened: (id) => navigatedMatchId = id,
      );

      expect(navigatedMatchId, isNull);
    });

    test('initialize schedules navigation when callback is null', () async {
      const initialMessage = RemoteMessage(data: {'matchId': '999'});
      when(
        () => mockRepository.getInitialMessage(),
      ).thenAnswer((_) async => initialMessage);

      await notificationService.initialize();
    });

    test('initialize logs error on repository failure', () async {
      final error = Exception('Repo init failure');
      when(() => mockRepository.initialize()).thenThrow(error);

      await notificationService.initialize();

      verify(
        () => mockCrash.recordError(
          error,
          any<StackTrace?>(),
          reason: 'NotificationService initialization error',
        ),
      ).called(1);
    });

    test('syncDeviceAndTopics does nothing when token is empty', () async {
      await notificationService.syncDeviceAndTopics('');
      verifyNever(
        () => mockDatabase.updateDeviceSettings(
          token: any(named: 'token'),
          deviceInfo: any(named: 'deviceInfo'),
          language: any(named: 'language'),
        ),
      );
    });

    test('syncDeviceAndTopics catches and logs exception on failure', () async {
      final exception = Exception('DB update error');
      when(
        () => mockDatabase.updateDeviceSettings(
          token: any(named: 'token'),
          deviceInfo: any(named: 'deviceInfo'),
          language: any(named: 'language'),
        ),
      ).thenThrow(exception);

      await notificationService.syncDeviceAndTopics('valid_token');

      verify(
        () => mockCrash.recordError(
          exception,
          any<StackTrace?>(),
          reason: 'NotificationService syncDeviceAndTopics error',
        ),
      ).called(1);
    });

    test('falls back to GetIt when dependencies are not passed', () async {
      if (getIt.isRegistered<DatabaseService>()) {
        await getIt.unregister<DatabaseService>();
      }
      if (getIt.isRegistered<DeviceInfoService>()) {
        await getIt.unregister<DeviceInfoService>();
      }
      if (getIt.isRegistered<LocalStorageService>()) {
        await getIt.unregister<LocalStorageService>();
      }
      if (getIt.isRegistered<PerformanceService>()) {
        await getIt.unregister<PerformanceService>();
      }
      if (getIt.isRegistered<CrashService>()) {
        await getIt.unregister<CrashService>();
      }

      getIt
        ..registerSingleton<DatabaseService>(mockDatabase)
        ..registerSingleton<DeviceInfoService>(mockDeviceInfo)
        ..registerSingleton<LocalStorageService>(mockLocalStorage)
        ..registerSingleton<PerformanceService>(mockPerformance)
        ..registerSingleton<CrashService>(mockCrash);

      final fallbackService = NotificationService(
        notificationRepository: mockRepository,
      );

      await fallbackService.syncDeviceAndTopics('token_fallback');
      verify(
        () => mockDatabase.updateDeviceSettings(
          token: 'token_fallback',
          deviceInfo: any(named: 'deviceInfo'),
          language: any(named: 'language'),
        ),
      ).called(1);

      // Also initialize fallbackService to cover _perf and _crash getters
      await fallbackService.initialize();

      await fallbackService.dispose();
      await getIt.reset();
    });

    testWidgets('navigates immediately to match when navigatorKey is mounted', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: AppVariables.navigatorKey,
          routes: {
            MatchPage.routeName: (_) =>
                const Scaffold(body: Text('MatchScreen')),
          },
          home: const Scaffold(body: Text('HomeScreen')),
        ),
      );

      const message = RemoteMessage(data: {'match': 'match_321'});
      when(
        () => mockRepository.getInitialMessage(),
      ).thenAnswer((_) async => message);

      await notificationService.initialize();
      await tester.pumpAndSettle();

      expect(find.text('MatchScreen'), findsOneWidget);
    });
  });
}
