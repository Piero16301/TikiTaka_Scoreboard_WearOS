import 'package:flutter_test/flutter_test.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';

void main() {
  group('AppPackageInfo', () {
    final now = DateTime(2025).toUtc();
    final packageInfo = AppPackageInfo(
      appName: 'TikiTaka',
      version: '1.0.0',
      buildNumber: '1',
      updateTime: now,
    );

    test('supports value equality', () {
      expect(
        packageInfo,
        equals(
          AppPackageInfo(
            appName: 'TikiTaka',
            version: '1.0.0',
            buildNumber: '1',
            updateTime: now,
          ),
        ),
      );
    });

    test('props are correct', () {
      expect(packageInfo.props, [
        'TikiTaka',
        '1.0.0',
        '1',
        now,
      ]);
    });

    test('toJson returns correct map', () {
      expect(packageInfo.toJson(), {
        'appName': 'TikiTaka',
        'version': '1.0.0',
        'buildNumber': '1',
        'updateTime': now,
      });
    });
  });
}
