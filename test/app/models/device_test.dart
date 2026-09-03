import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';

void main() {
  group('Device', () {
    final now = DateTime(2025).toUtc();
    final timestamp = Timestamp.fromDate(now);

    final device = Device(
      enabledTeams: const ['1', '2'],
      language: const Locale('es', 'ES'),
      lastOpenAt: now.toLocal(),
      platform: Platform.android,
      token: 'token123',
      wearOSInfo: const {'model': 'Generic WearOS'},
    );

    test('supports value equality', () {
      expect(
        device,
        equals(
          Device(
            enabledTeams: const ['1', '2'],
            language: const Locale('es', 'ES'),
            lastOpenAt: now.toLocal(),
            platform: Platform.android,
            token: 'token123',
            wearOSInfo: const {'model': 'Generic WearOS'},
          ),
        ),
      );
    });

    test('props are correct', () {
      expect(device.props, [
        ['1', '2'],
        const Locale('es', 'ES'),
        now.toLocal(),
        Platform.android,
        'token123',
        const {'model': 'Generic WearOS'},
      ]);
    });

    test('fromJson returns correct instance', () {
      final json = {
        'enabledTeams': ['1', '2'],
        'language': 'es_ES',
        'lastOpenAt': timestamp,
        'platform': 'android',
        'token': 'token123',
        'wearOSInfo': {'model': 'Generic WearOS'},
      };

      expect(Device.fromJson(json), device);
    });

    test('fromJson handles different language format', () {
      final json = {'language': 'pt'};
      final parsed = Device.fromJson(json);
      expect(parsed.language, const Locale('pt', ''));
    });

    test('fromJson handles missing fields with defaults', () {
      final parsed = Device.fromJson(const {});
      expect(parsed.enabledTeams, isEmpty);
      expect(parsed.language, const Locale('en', 'US'));
      expect(parsed.platform, Platform.wearOS);
      expect(parsed.token, isEmpty);
      expect(parsed.wearOSInfo, isNull);
    });

    test('Device.empty is correct', () {
      expect(Device.empty.token, isEmpty);
      expect(Device.empty.platform, Platform.wearOS);
    });
  });
}
