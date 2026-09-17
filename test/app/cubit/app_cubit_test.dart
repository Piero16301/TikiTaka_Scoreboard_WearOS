import 'dart:async';
import 'dart:ui';

import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';

class MockLocalStorageService extends Mock implements LocalStorageService {}

class MockDatabaseService extends Mock implements DatabaseService {}

class MockNotificationService extends Mock implements NotificationService {}

class MockPerformanceService extends Mock implements PerformanceService {}

class MockTrace extends Mock implements Trace {}

class MockAnalyticsService extends Mock implements AnalyticsService {}

class MockCrashService extends Mock implements CrashService {}

class FakeLocale extends Fake implements Locale {}

class FakeColor extends Fake implements Color {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeLocale());
    registerFallbackValue(FakeColor());
    registerFallbackValue(StackTrace.empty);
  });

  group('AppCubit', () {
    late LocalStorageService localStorageService;
    late DatabaseService databaseService;
    late NotificationService notificationService;
    late CrashService crashService;

    setUp(() {
      localStorageService = MockLocalStorageService();
      databaseService = MockDatabaseService();
      notificationService = MockNotificationService();
      crashService = MockCrashService();

      final mockPerformanceService = MockPerformanceService();
      final mockTrace = MockTrace();
      when(mockTrace.start).thenAnswer((_) async {});
      when(mockTrace.stop).thenAnswer((_) async {});
      when(
        () => mockPerformanceService.startTrace(any()),
      ).thenReturn(mockTrace);

      when(() => notificationService.initialize()).thenAnswer((_) async {});
      when(() => notificationService.token).thenReturn('');
      when(
        () => notificationService.onTokenRefresh,
      ).thenAnswer((_) => const Stream.empty());
      when(
        () => notificationService.subscribeToTopic(any()),
      ).thenAnswer((_) async {});
      when(
        () => notificationService.syncTeamsTopics(
          any(),
          languageCode: any(named: 'languageCode'),
        ),
      ).thenAnswer((_) async {});
      when(
        () => notificationService.switchLanguageTopics(
          oldLanguageCode: any(named: 'oldLanguageCode'),
          newLanguageCode: any(named: 'newLanguageCode'),
          enabledTeams: any(named: 'enabledTeams'),
        ),
      ).thenAnswer((_) async {});
      when(
        () => databaseService.getDeviceStream(token: any(named: 'token')),
      ).thenAnswer((_) => const Stream.empty());
      when(
        () => crashService.recordError(
          any<dynamic>(),
          any(),
          reason: any<dynamic>(named: 'reason'),
        ),
      ).thenReturn(null);

      getIt
        ..registerSingleton<LocalStorageService>(localStorageService)
        ..registerSingleton<DatabaseService>(databaseService)
        ..registerSingleton<NotificationService>(notificationService)
        ..registerSingleton<PerformanceService>(mockPerformanceService)
        ..registerSingleton<AnalyticsService>(MockAnalyticsService())
        ..registerSingleton<CrashService>(crashService);
    });

    tearDown(getIt.reset);

    test('initial state is AppState()', () {
      expect(AppCubit().state, const AppState());
    });

    blocTest<AppCubit, AppState>(
      'initialize sets default values when storage is empty',
      setUp: () {
        when(() => localStorageService.getLanguage()).thenReturn(null);
        when(
          () => localStorageService.saveLanguage(
            language: any(named: 'language'),
          ),
        ).thenReturn(null);

        when(() => localStorageService.getBaseColor()).thenReturn(null);
        when(
          () => localStorageService.saveBaseColor(
            baseColor: any(named: 'baseColor'),
          ),
        ).thenReturn(null);

        when(() => localStorageService.getFontFamily()).thenReturn(null);
        when(
          () => localStorageService.saveFontFamily(
            fontFamily: any(named: 'fontFamily'),
          ),
        ).thenReturn(null);
      },
      build: AppCubit.new,
      act: (cubit) => cubit.initialize(),
      expect: () => [const AppState()],
      verify: (_) {
        verify(
          () => localStorageService.saveLanguage(
            language: AppVariables.supportedLocales.first,
          ),
        ).called(1);
        verify(
          () => localStorageService.saveBaseColor(
            baseColor: AppVariables.defaultBaseColor,
          ),
        ).called(1);
        verify(
          () => localStorageService.saveFontFamily(
            fontFamily: AppVariables.defaultFontFamily,
          ),
        ).called(1);
      },
    );

    blocTest<AppCubit, AppState>(
      'initialize loads stored values when already set and supported',
      setUp: () {
        when(
          () => localStorageService.getLanguage(),
        ).thenReturn(const Locale('es', 'ES'));
        when(
          () => localStorageService.getBaseColor(),
        ).thenReturn(const Color(0xFF123456));
        when(() => localStorageService.getFontFamily()).thenReturn('Roboto');
      },
      build: AppCubit.new,
      act: (cubit) => cubit.initialize(),
      expect: () => [
        const AppState(
          language: Locale('es', 'ES'),
          baseColor: Color(0xFF123456),
          fontFamily: 'Roboto',
        ),
      ],
      verify: (_) {
        verifyNever(
          () => localStorageService.saveLanguage(
            language: any(named: 'language'),
          ),
        );
        verifyNever(
          () => localStorageService.saveBaseColor(
            baseColor: any(named: 'baseColor'),
          ),
        );
        verifyNever(
          () => localStorageService.saveFontFamily(
            fontFamily: any(named: 'fontFamily'),
          ),
        );
      },
    );

    blocTest<AppCubit, AppState>(
      'initialize resets font to default when stored font is unsupported',
      setUp: () {
        var currentFont = 'UnsupportedFont';
        when(
          () => localStorageService.getLanguage(),
        ).thenReturn(const Locale('es', 'ES'));
        when(
          () => localStorageService.getBaseColor(),
        ).thenReturn(const Color(0xFF123456));
        when(
          () => localStorageService.getFontFamily(),
        ).thenAnswer((_) => currentFont);
        when(
          () => localStorageService.saveFontFamily(
            fontFamily: any(named: 'fontFamily'),
          ),
        ).thenAnswer((invocation) {
          currentFont = invocation.namedArguments[#fontFamily] as String;
        });
      },
      build: AppCubit.new,
      act: (cubit) => cubit.initialize(),
      expect: () => [
        const AppState(
          language: Locale('es', 'ES'),
          baseColor: Color(0xFF123456),
        ),
      ],
      verify: (_) {
        verify(
          () =>
              localStorageService.saveFontFamily(fontFamily: 'GoogleSansFlex'),
        ).called(1);
      },
    );

    blocTest<AppCubit, AppState>(
      'does not listen to device if initial token is empty',
      setUp: () {
        when(
          () => localStorageService.getLanguage(),
        ).thenReturn(const Locale('en', 'US'));
        when(
          () => localStorageService.getBaseColor(),
        ).thenReturn(const Color(0xFF000000));
        when(() => localStorageService.getFontFamily()).thenReturn('Roboto');
        when(() => notificationService.token).thenReturn('');
      },
      build: AppCubit.new,
      act: (cubit) => cubit.initialize(),
      expect: () => [
        const AppState(baseColor: Color(0xFF000000), fontFamily: 'Roboto'),
      ],
      verify: (_) {
        verifyNever(
          () => databaseService.getDeviceStream(token: any(named: 'token')),
        );
      },
    );

    blocTest<AppCubit, AppState>(
      'subscribes to device stream on initialize and emits state with device',
      setUp: () {
        when(() => localStorageService.getLanguage()).thenReturn(null);
        when(
          () => localStorageService.saveLanguage(
            language: any(named: 'language'),
          ),
        ).thenReturn(null);
        when(() => localStorageService.getBaseColor()).thenReturn(null);
        when(
          () => localStorageService.saveBaseColor(
            baseColor: any(named: 'baseColor'),
          ),
        ).thenReturn(null);
        when(() => localStorageService.getFontFamily()).thenReturn(null);
        when(
          () => localStorageService.saveFontFamily(
            fontFamily: any(named: 'fontFamily'),
          ),
        ).thenReturn(null);

        when(() => notificationService.initialize()).thenAnswer((_) async {});
        when(() => notificationService.token).thenReturn('mock_token');
        when(
          () => databaseService.getDeviceStream(token: 'mock_token'),
        ).thenAnswer((_) => Stream.value(Device.empty));
      },
      build: AppCubit.new,
      act: (cubit) => cubit.initialize(),
      expect: () => [const AppState(), AppState(device: Device.empty)],
    );

    test('listens to device on token refresh when token is not '
        'empty', () async {
      final tokenController = StreamController<String>.broadcast();
      final deviceController = StreamController<Device>.broadcast();
      addTearDown(tokenController.close);
      addTearDown(deviceController.close);

      when(
        () => localStorageService.getLanguage(),
      ).thenReturn(const Locale('en', 'US'));
      when(
        () => localStorageService.getBaseColor(),
      ).thenReturn(const Color(0xFF000000));
      when(() => localStorageService.getFontFamily()).thenReturn('Roboto');
      when(() => notificationService.token).thenReturn('initial_token');
      when(
        () => notificationService.onTokenRefresh,
      ).thenAnswer((_) => tokenController.stream);
      when(
        () => databaseService.getDeviceStream(token: 'initial_token'),
      ).thenAnswer((_) => Stream.value(Device.empty));
      when(
        () => databaseService.getDeviceStream(token: 'refreshed_token'),
      ).thenAnswer((_) => deviceController.stream);

      final cubit = AppCubit()..initialize();
      await pumpEventQueue();

      // Emit empty token - should not trigger listen
      tokenController.add('');
      await pumpEventQueue();
      verifyNever(() => databaseService.getDeviceStream(token: ''));

      // Emit valid new token - triggers listen and cancels previous
      // subscription
      tokenController.add('refreshed_token');
      await pumpEventQueue();

      verify(
        () => databaseService.getDeviceStream(token: 'refreshed_token'),
      ).called(1);

      // Device with enabled teams syncs topics
      final deviceWithTeams = Device.empty.copyWith(enabledTeams: ['81', '86']);
      deviceController.add(deviceWithTeams);
      await pumpEventQueue();

      expect(cubit.state.device, deviceWithTeams);
      verify(
        () => notificationService.syncTeamsTopics([
          '81',
          '86',
        ], languageCode: 'en'),
      ).called(1);

      await cubit.close();
    });

    test('records error in CrashService when deviceStream fails', () async {
      final deviceController = StreamController<Device>.broadcast();
      addTearDown(deviceController.close);

      when(
        () => localStorageService.getLanguage(),
      ).thenReturn(const Locale('en', 'US'));
      when(
        () => localStorageService.getBaseColor(),
      ).thenReturn(const Color(0xFF000000));
      when(() => localStorageService.getFontFamily()).thenReturn('Roboto');
      when(() => notificationService.token).thenReturn('mock_token');
      when(
        () => databaseService.getDeviceStream(token: 'mock_token'),
      ).thenAnswer((_) => deviceController.stream);

      final cubit = AppCubit()..initialize();
      await pumpEventQueue();

      final exception = Exception('Stream error');
      deviceController.addError(exception, StackTrace.empty);
      await pumpEventQueue();

      verify(
        () => crashService.recordError(
          exception,
          any(),
          reason: 'AppCubit deviceStream error',
        ),
      ).called(1);

      await cubit.close();
    });

    blocTest<AppCubit, AppState>(
      'changeLanguage properly limits and saves',
      setUp: () {
        when(
          () => localStorageService.saveLanguage(
            language: any(named: 'language'),
          ),
        ).thenReturn(null);
        when(() => notificationService.token).thenReturn('mock_token');
        when(
          () => databaseService.updateDeviceSettings(
            token: any(named: 'token'),
            language: any(named: 'language'),
          ),
        ).thenAnswer((_) async {});
      },
      build: AppCubit.new,
      act: (cubit) => cubit.changeLanguage(language: const Locale('es', 'ES')),
      expect: () => [const AppState(language: Locale('es', 'ES'))],
      verify: (_) {
        verify(
          () => localStorageService.saveLanguage(
            language: const Locale('es', 'ES'),
          ),
        ).called(1);
        verify(
          () => databaseService.updateDeviceSettings(
            token: 'mock_token',
            language: const Locale('es', 'ES'),
          ),
        ).called(1);
        verifyNever(
          () => notificationService.switchLanguageTopics(
            oldLanguageCode: any(named: 'oldLanguageCode'),
            newLanguageCode: any(named: 'newLanguageCode'),
            enabledTeams: any(named: 'enabledTeams'),
          ),
        );
      },
    );

    blocTest<AppCubit, AppState>(
      'changeLanguage switches topic subscriptions '
      'when device has enabled teams',
      setUp: () {
        when(
          () => localStorageService.saveLanguage(
            language: any(named: 'language'),
          ),
        ).thenReturn(null);
        when(() => notificationService.token).thenReturn('mock_token');
        when(
          () => databaseService.updateDeviceSettings(
            token: any(named: 'token'),
            language: any(named: 'language'),
          ),
        ).thenAnswer((_) async {});
      },
      seed: () => AppState(
        language: const Locale('es', 'ES'),
        device: Device.empty.copyWith(enabledTeams: ['81', '86']),
      ),
      build: AppCubit.new,
      act: (cubit) => cubit.changeLanguage(language: const Locale('en', 'US')),
      expect: () => [
        AppState(device: Device.empty.copyWith(enabledTeams: ['81', '86'])),
      ],
      verify: (_) {
        verify(
          () => notificationService.switchLanguageTopics(
            oldLanguageCode: 'es',
            newLanguageCode: 'en',
            enabledTeams: ['81', '86'],
          ),
        ).called(1);
      },
    );

    blocTest<AppCubit, AppState>(
      'changeLanguage does not switch topics if language has not changed',
      setUp: () {
        when(
          () => localStorageService.saveLanguage(
            language: any(named: 'language'),
          ),
        ).thenReturn(null);
        when(() => notificationService.token).thenReturn('mock_token');
        when(
          () => databaseService.updateDeviceSettings(
            token: any(named: 'token'),
            language: any(named: 'language'),
          ),
        ).thenAnswer((_) async {});
      },
      seed: () => AppState(
        language: const Locale('es', 'ES'),
        device: Device.empty.copyWith(enabledTeams: ['81', '86']),
      ),
      build: AppCubit.new,
      act: (cubit) => cubit.changeLanguage(language: const Locale('es', 'ES')),
      expect: () => <AppState>[],
      verify: (_) {
        verifyNever(
          () => notificationService.switchLanguageTopics(
            oldLanguageCode: any(named: 'oldLanguageCode'),
            newLanguageCode: any(named: 'newLanguageCode'),
            enabledTeams: any(named: 'enabledTeams'),
          ),
        );
      },
    );

    blocTest<AppCubit, AppState>(
      'changeBaseColor saves base color and emits state',
      setUp: () {
        when(
          () => localStorageService.saveBaseColor(
            baseColor: any(named: 'baseColor'),
          ),
        ).thenReturn(null);
      },
      build: AppCubit.new,
      act: (cubit) => cubit.changeBaseColor(baseColor: const Color(0xff000000)),
      expect: () => [const AppState(baseColor: Color(0xff000000))],
      verify: (_) {
        verify(
          () => localStorageService.saveBaseColor(
            baseColor: const Color(0xff000000),
          ),
        ).called(1);
      },
    );

    blocTest<AppCubit, AppState>(
      'changeFontFamily saves font family and emits state',
      setUp: () {
        when(
          () => localStorageService.saveFontFamily(
            fontFamily: any(named: 'fontFamily'),
          ),
        ).thenReturn(null);
      },
      build: AppCubit.new,
      act: (cubit) => cubit.changeFontFamily(fontFamily: 'Roboto'),
      expect: () => [const AppState(fontFamily: 'Roboto')],
    );

    test('close cancels subscriptions without errors', () async {
      final tokenController = StreamController<String>.broadcast();
      final deviceController = StreamController<Device>.broadcast();
      addTearDown(tokenController.close);
      addTearDown(deviceController.close);

      when(
        () => localStorageService.getLanguage(),
      ).thenReturn(const Locale('en', 'US'));
      when(
        () => localStorageService.getBaseColor(),
      ).thenReturn(const Color(0xFF000000));
      when(() => localStorageService.getFontFamily()).thenReturn('Roboto');
      when(() => notificationService.token).thenReturn('mock_token');
      when(
        () => notificationService.onTokenRefresh,
      ).thenAnswer((_) => tokenController.stream);
      when(
        () => databaseService.getDeviceStream(token: 'mock_token'),
      ).thenAnswer((_) => deviceController.stream);

      final cubit = AppCubit()..initialize();
      await pumpEventQueue();

      await expectLater(cubit.close(), completes);
    });
  });
}
