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

class FakeLocale extends Fake implements Locale {}

class FakeColor extends Fake implements Color {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeLocale());
    registerFallbackValue(FakeColor());
  });

  group('AppCubit', () {
    late LocalStorageService localStorageService;
    late DatabaseService databaseService;
    late NotificationService notificationService;

    setUp(() {
      localStorageService = MockLocalStorageService();
      databaseService = MockDatabaseService();
      notificationService = MockNotificationService();

      final mockPerformanceService = MockPerformanceService();
      final mockTrace = MockTrace();
      when(mockTrace.start).thenAnswer((_) async {});
      when(mockTrace.stop).thenAnswer((_) async {});
      when(() => mockPerformanceService.startTrace(any()))
          .thenReturn(mockTrace);

      when(() => notificationService.initialize()).thenAnswer((_) async {});
      when(() => notificationService.token).thenReturn('');
      when(() => databaseService.getDeviceStream(token: any(named: 'token')))
          .thenAnswer((_) => const Stream.empty());

      getIt
        ..registerSingleton<LocalStorageService>(localStorageService)
        ..registerSingleton<DatabaseService>(databaseService)
        ..registerSingleton<NotificationService>(notificationService)
        ..registerSingleton<PerformanceService>(mockPerformanceService)
        ..registerSingleton<AnalyticsService>(MockAnalyticsService());
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
      expect: () => [
        const AppState(),
      ],
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
      expect: () => [
        const AppState(language: Locale('es', 'ES')),
      ],
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
      expect: () => [
        const AppState(baseColor: Color(0xff000000)),
      ],
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
      expect: () => [
        const AppState(fontFamily: 'Roboto'),
      ],
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
        when(() => databaseService.getDeviceStream(token: 'mock_token'))
            .thenAnswer((_) => Stream.value(Device.empty));
      },
      build: AppCubit.new,
      act: (cubit) => cubit.initialize(),
      expect: () => [
        const AppState(),
        AppState(device: Device.empty),
      ],
    );
  });
}
