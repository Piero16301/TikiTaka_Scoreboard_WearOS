import 'package:flutter_test/flutter_test.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';

void main() {
  group('AppDeviceInfo', () {
    const deviceInfo = AppDeviceInfo(
      id: '123',
      versionRelease: '12',
      sdkInt: 31,
      securityPatch: '2022-01-01',
      model: 'Pixel 6',
      brand: 'Google',
      isLowRamDevice: false,
      isPhysicalDevice: true,
      processor: 'Tensor',
      physicalRamSize: 8192,
      availableRamSize: 4096,
    );

    test('supports value equality', () {
      expect(
        deviceInfo,
        equals(
          const AppDeviceInfo(
            id: '123',
            versionRelease: '12',
            sdkInt: 31,
            securityPatch: '2022-01-01',
            model: 'Pixel 6',
            brand: 'Google',
            isLowRamDevice: false,
            isPhysicalDevice: true,
            processor: 'Tensor',
            physicalRamSize: 8192,
            availableRamSize: 4096,
          ),
        ),
      );
    });

    test('props are correct', () {
      expect(deviceInfo.props, [
        '123',
        '12',
        31,
        '2022-01-01',
        'Pixel 6',
        'Google',
        false,
        true,
        'Tensor',
        8192,
        4096,
      ]);
    });

    test('toJson returns correct map', () {
      expect(deviceInfo.toJson(), {
        'id': '123',
        'versionRelease': '12',
        'sdkInt': 31,
        'securityPatch': '2022-01-01',
        'model': 'Pixel 6',
        'brand': 'Google',
        'isLowRamDevice': false,
        'isPhysicalDevice': true,
        'processor': 'Tensor',
        'physicalRamSize': 8192,
        'availableRamSize': 4096,
      });
    });
  });
}
