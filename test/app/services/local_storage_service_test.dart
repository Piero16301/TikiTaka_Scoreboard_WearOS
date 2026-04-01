import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';

class MockLocalStorageRepository extends Mock
    implements LocalStorageRepository {}

class MockPerformanceService extends Mock implements PerformanceService {}

class MockTrace extends Mock implements Trace {}

void main() {
  group('LocalStorageService', () {
    late MockLocalStorageRepository mockRepository;
    late MockPerformanceService mockPerformance;
    late LocalStorageService service;

    setUpAll(() {
      registerFallbackValue(MockTrace());
    });

    setUp(() async {
      mockRepository = MockLocalStorageRepository();
      mockPerformance = MockPerformanceService();

      if (getIt.isRegistered<PerformanceService>()) {
        await getIt.unregister<PerformanceService>();
      }
      getIt.registerSingleton<PerformanceService>(mockPerformance);

      when(() => mockPerformance.startTrace(any())).thenReturn(MockTrace());
      when(() => mockPerformance.stopTrace(any())).thenReturn(null);

      service = LocalStorageService(localStorageRepository: mockRepository);
    });

    test('initialize calls repository and performance trace', () async {
      when(() => mockRepository.initialize()).thenAnswer((_) async {});

      await service.initialize();

      verify(
        () =>
            mockPerformance.startTrace('local_storage_service_initialization'),
      ).called(1);
      verify(() => mockRepository.initialize()).called(1);
      verify(() => mockPerformance.stopTrace(any())).called(1);
    });

    group('Enabled Leagues', () {
      test('saveEnabledLeague calls repository', () {
        when(
          () => mockRepository.saveEnabledLeague(league: 'PL', enabled: true),
        ).thenReturn(null);
        service.saveEnabledLeague(league: 'PL', enabled: true);
        verify(
          () => mockRepository.saveEnabledLeague(league: 'PL', enabled: true),
        ).called(1);
      });

      test('getEnabledLeagues calls repository', () {
        when(() => mockRepository.getEnabledLeagues()).thenReturn(['PL']);
        expect(service.getEnabledLeagues(), ['PL']);
        verify(() => mockRepository.getEnabledLeagues()).called(1);
      });
    });

    group('Language', () {
      test('saveLanguage calls repository', () {
        when(
          () => mockRepository.saveLanguage(language: const Locale('es', 'ES')),
        ).thenReturn(null);
        service.saveLanguage(language: const Locale('es', 'ES'));
        verify(
          () => mockRepository.saveLanguage(language: const Locale('es', 'ES')),
        ).called(1);
      });

      test('getLanguage calls repository', () {
        const locale = Locale('es', 'ES');
        when(() => mockRepository.getLanguage()).thenReturn(locale);
        expect(service.getLanguage(), locale);
        verify(() => mockRepository.getLanguage()).called(1);
      });
    });

    group('Base Color', () {
      test('saveBaseColor calls repository', () {
        const color = Colors.red;
        when(() => mockRepository.saveBaseColor(baseColor: color))
            .thenReturn(null);
        service.saveBaseColor(baseColor: color);
        verify(() => mockRepository.saveBaseColor(baseColor: color)).called(1);
      });

      test('getBaseColor calls repository', () {
        const color = Colors.red;
        when(() => mockRepository.getBaseColor()).thenReturn(color);
        expect(service.getBaseColor(), color);
        verify(() => mockRepository.getBaseColor()).called(1);
      });
    });

    group('Font Family', () {
      test('saveFontFamily calls repository', () {
        const font = 'Roboto';
        when(() => mockRepository.saveFontFamily(fontFamily: font))
            .thenReturn(null);
        service.saveFontFamily(fontFamily: font);
        verify(() => mockRepository.saveFontFamily(fontFamily: font)).called(1);
      });

      test('getFontFamily calls repository', () {
        const font = 'Roboto';
        when(() => mockRepository.getFontFamily()).thenReturn(font);
        expect(service.getFontFamily(), font);
        verify(() => mockRepository.getFontFamily()).called(1);
      });
    });
  });
}
