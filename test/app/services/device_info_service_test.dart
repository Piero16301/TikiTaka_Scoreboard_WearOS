import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';

class MockDeviceInfoRepository extends Mock implements DeviceInfoRepository {}

class MockPerformanceService extends Mock implements PerformanceService {}

class MockTrace extends Mock implements Trace {}

class MockAppDeviceInfo extends Mock implements AppDeviceInfo {}

class MockAppPackageInfo extends Mock implements AppPackageInfo {}

void main() {
  group('DeviceInfoService', () {
    late MockDeviceInfoRepository mockRepository;
    late MockPerformanceService mockPerformance;
    late DeviceInfoService service;

    setUpAll(() {
      registerFallbackValue(MockTrace());
    });

    setUp(() async {
      mockRepository = MockDeviceInfoRepository();
      mockPerformance = MockPerformanceService();

      if (getIt.isRegistered<PerformanceService>()) {
        await getIt.unregister<PerformanceService>();
      }
      getIt.registerSingleton<PerformanceService>(mockPerformance);

      when(() => mockPerformance.startTrace(any())).thenReturn(MockTrace());
      when(() => mockPerformance.stopTrace(any())).thenReturn(null);

      service = DeviceInfoService(deviceInfoRepository: mockRepository);
    });

    test('initialize calls repository and performance trace', () async {
      when(() => mockRepository.initialize()).thenAnswer((_) async {});

      await service.initialize();

      verify(
        () => mockPerformance.startTrace('device_info_service_initialization'),
      ).called(1);
      verify(() => mockRepository.initialize()).called(1);
      verify(() => mockPerformance.stopTrace(any())).called(1);
    });

    test('deviceInfo returns value from repository', () {
      final mockInfo = MockAppDeviceInfo();
      when(() => mockRepository.deviceInfo).thenReturn(mockInfo);

      expect(service.deviceInfo, equals(mockInfo));
      verify(() => mockRepository.deviceInfo).called(1);
    });

    test('packageInfo returns value from repository', () {
      final mockInfo = MockAppPackageInfo();
      when(() => mockRepository.packageInfo).thenReturn(mockInfo);

      expect(service.packageInfo, equals(mockInfo));
      verify(() => mockRepository.packageInfo).called(1);
    });
  });
}
