import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const deviceInfoChannel =
      MethodChannel('dev.fluttercommunity.plus/device_info');

  group('DeviceInfoService', () {
    late DeviceInfoService service;

    setUp(() {
      service = DeviceInfoService();

      PackageInfo.setMockInitialValues(
        appName: 'TestApp',
        packageName: 'com.test.app',
        version: '1.0.0',
        buildNumber: '1',
        buildSignature: 'signature',
      );

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(deviceInfoChannel, (methodCall) async {
        if (methodCall.method == 'getDeviceInfo') {
          return <String, dynamic>{
            'board': 'test_board',
            'bootloader': 'test_bootloader',
            'brand': 'test_brand',
            'device': 'test_device',
            'display': 'test_display',
            'fingerprint': 'test_fingerprint',
            'hardware': 'test_hardware',
            'host': 'test_host',
            'id': 'test_id',
            'manufacturer': 'test_manufacturer',
            'model': 'test_model',
            'product': 'test_product',
            'name': 'test_name',
            'supported32BitAbis': <String>['abi1'],
            'supported64BitAbis': <String>['abi2'],
            'supportedAbis': <String>['abi1', 'abi2'],
            'tags': 'test_tags',
            'type': 'test_type',
            'isPhysicalDevice': true,
            'systemFeatures': <String>['feature1'],
            'version': <String, dynamic>{
              'baseOS': 'base_os',
              'codename': 'codename',
              'incremental': 'incremental',
              'previewSdkInt': 1,
              'release': 'release',
              'sdkInt': 30,
              'securityPatch': 'security_patch',
            },
            'isLowRamDevice': false,
            'physicalRamSize': 4096000000,
            'availableRamSize': 2048000000,
            'freeDiskSize': 1024000000,
            'totalDiskSize': 2048000000,
          };
        }
        return null;
      });
    });

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(deviceInfoChannel, null);
    });

    test('initialize loads androidInfo and packageInfo correctly', () async {
      await service.initialize();

      expect(service.androidInfo, isNotNull);
      expect(service.androidInfo.model, 'test_model');
      expect(service.androidInfo.version.sdkInt, 30);

      expect(service.packageInfo, isNotNull);
      expect(service.packageInfo.appName, 'TestApp');
      expect(service.packageInfo.version, '1.0.0');
    });
  });
}
