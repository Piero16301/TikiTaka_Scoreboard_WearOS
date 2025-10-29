import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';

import '../../helpers/mock_firebase_platform.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('NotificationService', () {
    setUpAll(() async {
      await setupFirebaseCoreMocks();
      await Firebase.initializeApp();
    });

    setUp(() async {
      SharedPreferences.setMockInitialValues({
        '__user_language__': 'en_US',
        '__user_base_color__': 'INDIGO',
      });
    });

    group('singleton pattern', () {
      test('returns same instance when accessed multiple times', () {
        final instance1 = NotificationService.instance;
        final instance2 = NotificationService.instance;

        expect(identical(instance1, instance2), isTrue);
      });
    });

    group('token getter', () {
      test('returns empty string initially', () {
        expect(NotificationService.instance.token, isEmpty);
      });
    });

    group('AndroidVersion extension', () {
      test('toJson returns correct map with all required fields', () {
        final version = AndroidDeviceInfo.fromMap({
          'version': {
            'baseOS': 'test_base_os',
            'codename': 'test_codename',
            'incremental': 'test_incremental',
            'previewSdkInt': 1,
            'release': 'test_release',
            'sdkInt': 30,
            'securityPatch': 'test_security_patch',
          },
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
          'supported32BitAbis': <String>[],
          'supported64BitAbis': <String>[],
          'supportedAbis': <String>[],
          'tags': 'test_tags',
          'type': 'test_type',
          'isPhysicalDevice': true,
          'systemFeatures': <String>[],
          'serialNumber': 'unknown',
          'isLowRamDevice': false,
          'freeDiskSize': 1000000,
          'totalDiskSize': 2000000,
          'physicalRamSize': 4000000,
          'availableRamSize': 2000000,
          'displayMetrics': {
            'widthPx': 1080.0,
            'heightPx': 1920.0,
            'xDpi': 420.0,
            'yDpi': 420.0,
          },
        }).version;

        final json = version.toJson();

        expect(json, isA<Map<String, dynamic>>());
        expect(json['codename'], 'test_codename');
        expect(json['incremental'], 'test_incremental');
        expect(json['previewSdkInt'], 1);
        expect(json['release'], 'test_release');
        expect(json['sdkInt'], 30);
        expect(json['securityPatch'], 'test_security_patch');
      });

      test('toJson handles null previewSdkInt with default value', () {
        final version = AndroidDeviceInfo.fromMap({
          'version': {
            'codename': 'test_codename',
            'incremental': 'test_incremental',
            'release': 'test_release',
            'sdkInt': 30,
            'securityPatch': 'test_security_patch',
          },
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
          'supported32BitAbis': <String>[],
          'supported64BitAbis': <String>[],
          'supportedAbis': <String>[],
          'tags': 'test_tags',
          'type': 'test_type',
          'isPhysicalDevice': true,
          'systemFeatures': <String>[],
          'serialNumber': 'unknown',
          'isLowRamDevice': false,
          'freeDiskSize': 1000000,
          'totalDiskSize': 2000000,
          'physicalRamSize': 4000000,
          'availableRamSize': 2000000,
          'displayMetrics': {
            'widthPx': 1080.0,
            'heightPx': 1920.0,
            'xDpi': 420.0,
            'yDpi': 420.0,
          },
        }).version;

        final json = version.toJson();

        expect(json['previewSdkInt'], 0);
      });

      test('toJson handles null securityPatch with default value', () {
        final version = AndroidDeviceInfo.fromMap({
          'version': {
            'codename': 'test_codename',
            'incremental': 'test_incremental',
            'release': 'test_release',
            'sdkInt': 30,
          },
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
          'supported32BitAbis': <String>[],
          'supported64BitAbis': <String>[],
          'supportedAbis': <String>[],
          'tags': 'test_tags',
          'type': 'test_type',
          'isPhysicalDevice': true,
          'systemFeatures': <String>[],
          'serialNumber': 'unknown',
          'isLowRamDevice': false,
          'freeDiskSize': 1000000,
          'totalDiskSize': 2000000,
          'physicalRamSize': 4000000,
          'availableRamSize': 2000000,
          'displayMetrics': {
            'widthPx': 1080.0,
            'heightPx': 1920.0,
            'xDpi': 420.0,
            'yDpi': 420.0,
          },
        }).version;

        final json = version.toJson();

        expect(json['securityPatch'], '');
      });
    });

    group('AndroidInfo extension', () {
      test('toJson returns correct map with all device fields', () {
        final deviceInfo = AndroidDeviceInfo.fromMap({
          'version': {
            'baseOS': 'test_base_os',
            'codename': 'test_codename',
            'incremental': 'test_incremental',
            'previewSdkInt': 1,
            'release': 'test_release',
            'sdkInt': 30,
            'securityPatch': 'test_security_patch',
          },
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
          'supported32BitAbis': ['armeabi-v7a'],
          'supported64BitAbis': ['arm64-v8a'],
          'supportedAbis': ['arm64-v8a', 'armeabi-v7a'],
          'tags': 'test_tags',
          'type': 'test_type',
          'isPhysicalDevice': true,
          'systemFeatures': ['android.hardware.wifi'],
          'serialNumber': 'unknown',
          'isLowRamDevice': false,
          'freeDiskSize': 1000000,
          'totalDiskSize': 2000000,
          'physicalRamSize': 4000000,
          'availableRamSize': 2000000,
          'displayMetrics': {
            'widthPx': 1080.0,
            'heightPx': 1920.0,
            'xDpi': 420.0,
            'yDpi': 420.0,
          },
        });

        final json = deviceInfo.toJson();

        expect(json, isA<Map<String, dynamic>>());
        expect(json['board'], 'test_board');
        expect(json['brand'], 'test_brand');
        expect(json['model'], 'test_model');
        expect(json['manufacturer'], 'test_manufacturer');
        expect(json['isPhysicalDevice'], true);
        expect(json['version'], isA<Map<String, dynamic>>());
        // ignore: avoid_dynamic_calls // Used to access dynamic map
        expect(json['version']['sdkInt'], 30);
      });

      test('toJson includes all arrays correctly', () {
        final deviceInfo = AndroidDeviceInfo.fromMap({
          'version': {
            'codename': 'test_codename',
            'incremental': 'test_incremental',
            'previewSdkInt': 1,
            'release': 'test_release',
            'sdkInt': 30,
          },
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
          'supported32BitAbis': ['armeabi-v7a', 'x86'],
          'supported64BitAbis': ['arm64-v8a', 'x86_64'],
          'supportedAbis': ['arm64-v8a', 'armeabi-v7a', 'x86', 'x86_64'],
          'tags': 'test_tags',
          'type': 'test_type',
          'isPhysicalDevice': false,
          'systemFeatures': [
            'android.hardware.wifi',
            'android.hardware.bluetooth',
          ],
          'serialNumber': 'unknown',
          'isLowRamDevice': true,
          'freeDiskSize': 1000000,
          'totalDiskSize': 2000000,
          'physicalRamSize': 4000000,
          'availableRamSize': 2000000,
          'displayMetrics': {
            'widthPx': 1080.0,
            'heightPx': 1920.0,
            'xDpi': 420.0,
            'yDpi': 420.0,
          },
        });

        final json = deviceInfo.toJson();

        expect(json['supported32BitAbis'], isA<List<dynamic>>());
        expect(json['supported64BitAbis'], isA<List<dynamic>>());
        expect(json['supportedAbis'], isA<List<dynamic>>());
        expect(json['systemFeatures'], isA<List<dynamic>>());
        // ignore: avoid_dynamic_calls // Used to access dynamic map
        expect(json['supported32BitAbis'].length, 2);
        // ignore: avoid_dynamic_calls // Used to access dynamic map
        expect(json['supported64BitAbis'].length, 2);
        // ignore: avoid_dynamic_calls // Used to access dynamic map
        expect(json['supportedAbis'].length, 4);
        // ignore: avoid_dynamic_calls // Used to access dynamic map
        expect(json['systemFeatures'].length, 2);
      });

      test('toJson includes ram and device flags', () {
        final deviceInfo = AndroidDeviceInfo.fromMap({
          'version': {
            'codename': 'test_codename',
            'incremental': 'test_incremental',
            'previewSdkInt': 1,
            'release': 'test_release',
            'sdkInt': 30,
          },
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
          'supported32BitAbis': <String>[],
          'supported64BitAbis': <String>[],
          'supportedAbis': <String>[],
          'tags': 'test_tags',
          'type': 'test_type',
          'isPhysicalDevice': true,
          'systemFeatures': <String>[],
          'serialNumber': 'unknown',
          'isLowRamDevice': false,
          'freeDiskSize': 1000000,
          'totalDiskSize': 2000000,
          'physicalRamSize': 4000000,
          'availableRamSize': 2000000,
          'displayMetrics': {
            'widthPx': 1080.0,
            'heightPx': 1920.0,
            'xDpi': 420.0,
            'yDpi': 420.0,
          },
        });

        final json = deviceInfo.toJson();

        expect(json['isPhysicalDevice'], isTrue);
        expect(json['isLowRamDevice'], isFalse);
        expect(json.containsKey('physicalRamSize'), isTrue);
        expect(json.containsKey('availableRamSize'), isTrue);
      });
    });
  });
}
