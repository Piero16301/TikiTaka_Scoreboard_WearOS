import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';

class MockDeviceInfoPlugin extends Mock implements DeviceInfoPlugin {}

class MockAndroidDeviceInfo extends Mock implements AndroidDeviceInfo {}

class MockAndroidBuildVersion extends Mock implements AndroidBuildVersion {}

void main() {
  group('MockDeviceInfoRepository', () {
    late MockDeviceInfoRepository repository;

    setUp(() async {
      repository = MockDeviceInfoRepository();
      await repository.initialize();
    });

    test('deviceInfo returns mock device details', () {
      final deviceInfo = repository.deviceInfo;
      expect(deviceInfo, isA<AppDeviceInfo>());
      expect(deviceInfo.id, 'mock-device-id');
    });

    test('packageInfo returns mock package details', () {
      final packageInfo = repository.packageInfo;
      expect(packageInfo, isA<AppPackageInfo>());
      expect(packageInfo.appName, 'Tiki Taka');
      expect(packageInfo.version, '1.0.0');
      expect(packageInfo.buildNumber, '1');
      expect(packageInfo.updateTime, DateTime(2026, 3, 30));
    });
  });

  group('PlusDeviceInfoRepository', () {
    late MockDeviceInfoPlugin mockDeviceInfoPlugin;
    late MockAndroidDeviceInfo mockAndroidDeviceInfo;
    late MockAndroidBuildVersion mockAndroidBuildVersion;
    late PlusDeviceInfoRepository repository;

    setUp(() {
      mockDeviceInfoPlugin = MockDeviceInfoPlugin();
      mockAndroidDeviceInfo = MockAndroidDeviceInfo();
      mockAndroidBuildVersion = MockAndroidBuildVersion();
      repository = PlusDeviceInfoRepository(
        deviceInfoPlugin: mockDeviceInfoPlugin,
      );

      PackageInfo.setMockInitialValues(
        appName: 'Test App',
        packageName: 'com.test.app',
        version: '1.0.0',
        buildNumber: '1',
        buildSignature: 'signature',
      );

      when(() => mockAndroidDeviceInfo.version)
          .thenReturn(mockAndroidBuildVersion);
      when(() => mockAndroidBuildVersion.release).thenReturn('12');
      when(() => mockAndroidBuildVersion.sdkInt).thenReturn(31);
      when(() => mockAndroidBuildVersion.securityPatch)
          .thenReturn('2022-01-01');

      when(() => mockAndroidDeviceInfo.id).thenReturn('device-id');
      when(() => mockAndroidDeviceInfo.model).thenReturn('Pixel 6');
      when(() => mockAndroidDeviceInfo.brand).thenReturn('Google');
      when(() => mockAndroidDeviceInfo.isLowRamDevice).thenReturn(false);
      when(() => mockAndroidDeviceInfo.isPhysicalDevice).thenReturn(true);
      when(() => mockAndroidDeviceInfo.hardware).thenReturn('tensor');
      when(() => mockAndroidDeviceInfo.physicalRamSize).thenReturn(8589934592);
      when(() => mockAndroidDeviceInfo.availableRamSize).thenReturn(4294967296);

      when(() => mockDeviceInfoPlugin.androidInfo)
          .thenAnswer((_) async => mockAndroidDeviceInfo);
    });

    test('initialize populates deviceInfo and packageInfo', () async {
      await repository.initialize();

      final deviceInfo = repository.deviceInfo;
      expect(deviceInfo.id, 'device-id');
      expect(deviceInfo.model, 'Pixel 6');
      expect(deviceInfo.brand, 'Google');

      final packageInfo = repository.packageInfo;
      expect(packageInfo.appName, 'Test App');
      expect(packageInfo.version, '1.0.0');
    });
  });
}
