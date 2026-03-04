import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';

class MockAndroidBuildVersion extends Mock implements AndroidBuildVersion {}

void main() {
  group('Global Extensions', () {
    test('LocaleParser toShortString formats properly with country code', () {
      const locale = Locale('es', 'ES');
      expect(locale.toShortString, 'es_ES');
    });

    test('LocaleParser toShortString formats properly without country code',
        () {
      const locale = Locale('es');
      expect(locale.toShortString, 'es');
    });

    test('AndroidVersion toJson serializes properly', () {
      final version = MockAndroidBuildVersion();
      when(() => version.codename).thenReturn('Rel');
      when(() => version.incremental).thenReturn('1');
      when(() => version.previewSdkInt).thenReturn(0);
      when(() => version.release).thenReturn('12');
      when(() => version.sdkInt).thenReturn(31);
      when(() => version.securityPatch).thenReturn('2023-01');

      final json = version.toJson();

      expect(json['codename'], 'Rel');
      expect(json['sdkInt'], 31);
      expect(json['release'], '12');
    });
  });
}
