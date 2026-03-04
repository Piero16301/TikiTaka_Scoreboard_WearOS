// Necessary to ignore these rules for this file
// ignore_for_file: avoid_dynamic_calls

import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';

class MockAndroidBuildVersion extends Mock implements AndroidBuildVersion {}

class MockAndroidDeviceInfo extends Mock implements AndroidDeviceInfo {}

void main() {
  group('Global Extensions', () {
    group('LocaleParser', () {
      test('toShortString formats properly with country code', () {
        const locale = Locale('es', 'ES');
        expect(locale.toShortString, 'es_ES');
      });

      test('toShortString formats properly without country code', () {
        const locale = Locale('es');
        expect(locale.toShortString, 'es');
      });
    });

    group('AndroidVersion', () {
      test('toJson serializes properly with all fields', () {
        final version = MockAndroidBuildVersion();
        when(() => version.codename).thenReturn('Rel');
        when(() => version.incremental).thenReturn('1');
        when(() => version.previewSdkInt).thenReturn(1);
        when(() => version.release).thenReturn('12');
        when(() => version.sdkInt).thenReturn(31);
        when(() => version.securityPatch).thenReturn('2023-01');

        final json = version.toJson();

        expect(json['codename'], 'Rel');
        expect(json['incremental'], '1');
        expect(json['previewSdkInt'], 1);
        expect(json['release'], '12');
        expect(json['sdkInt'], 31);
        expect(json['securityPatch'], '2023-01');
      });

      test('toJson serializes properly with null optional fields', () {
        final version = MockAndroidBuildVersion();
        when(() => version.codename).thenReturn('Rel');
        when(() => version.incremental).thenReturn('1');
        when(() => version.previewSdkInt).thenReturn(null);
        when(() => version.release).thenReturn('12');
        when(() => version.sdkInt).thenReturn(31);
        when(() => version.securityPatch).thenReturn(null);

        final json = version.toJson();

        expect(json['previewSdkInt'], 0);
        expect(json['securityPatch'], '');
      });
    });

    group('AndroidInfo', () {
      test('toJson serializes properly', () {
        final version = MockAndroidBuildVersion();
        when(() => version.codename).thenReturn('Rel');
        when(() => version.incremental).thenReturn('1');
        when(() => version.previewSdkInt).thenReturn(null);
        when(() => version.release).thenReturn('12');
        when(() => version.sdkInt).thenReturn(31);
        when(() => version.securityPatch).thenReturn(null);

        final info = MockAndroidDeviceInfo();
        when(() => info.version).thenReturn(version);
        when(() => info.board).thenReturn('board');
        when(() => info.bootloader).thenReturn('bootloader');
        when(() => info.brand).thenReturn('brand');
        when(() => info.device).thenReturn('device');
        when(() => info.display).thenReturn('display');
        when(() => info.fingerprint).thenReturn('fingerprint');
        when(() => info.hardware).thenReturn('hardware');
        when(() => info.host).thenReturn('host');
        when(() => info.id).thenReturn('id');
        when(() => info.manufacturer).thenReturn('manufacturer');
        when(() => info.model).thenReturn('model');
        when(() => info.product).thenReturn('product');
        when(() => info.supported32BitAbis).thenReturn(['armeabi-v7a']);
        when(() => info.supported64BitAbis).thenReturn(['arm64-v8a']);
        when(() => info.supportedAbis).thenReturn(['arm64-v8a', 'armeabi-v7a']);
        when(() => info.tags).thenReturn('tags');
        when(() => info.type).thenReturn('type');
        when(() => info.isPhysicalDevice).thenReturn(true);
        when(() => info.systemFeatures).thenReturn(['feature1']);
        when(() => info.isLowRamDevice).thenReturn(false);
        when(() => info.physicalRamSize).thenReturn(4096000000);
        when(() => info.availableRamSize).thenReturn(2048000000);

        final json = info.toJson();

        expect(json['version']['codename'], 'Rel');
        expect(json['board'], 'board');
        expect(json['bootloader'], 'bootloader');
        expect(json['brand'], 'brand');
        expect(json['device'], 'device');
        expect(json['display'], 'display');
        expect(json['fingerprint'], 'fingerprint');
        expect(json['hardware'], 'hardware');
        expect(json['host'], 'host');
        expect(json['id'], 'id');
        expect(json['manufacturer'], 'manufacturer');
        expect(json['model'], 'model');
        expect(json['product'], 'product');
        expect(json['supported32BitAbis'], ['armeabi-v7a']);
        expect(json['supported64BitAbis'], ['arm64-v8a']);
        expect(json['supportedAbis'], ['arm64-v8a', 'armeabi-v7a']);
        expect(json['tags'], 'tags');
        expect(json['type'], 'type');
        expect(json['isPhysicalDevice'], true);
        expect(json['systemFeatures'], ['feature1']);
        expect(json['isLowRamDevice'], false);
        expect(json['physicalRamSize'], 4096000000);
        expect(json['availableRamSize'], 2048000000);
      });
    });

    group('NetworkSvgLoader', () {
      test('hashCode matches url hashCode', () {
        const loader = NetworkSvgLoader('http://example.com/test.svg');
        expect(loader.hashCode, 'http://example.com/test.svg'.hashCode);
      });

      test('equality operator matches identical url', () {
        const loader1 = NetworkSvgLoader('http://example.com/test.svg');
        const loader2 = NetworkSvgLoader('http://example.com/test.svg');
        const loader3 = NetworkSvgLoader('http://example.com/other.svg');

        expect(loader1 == loader2, isTrue);
        expect(loader1 == loader3, isFalse);
        expect(loader1 == Object(), isFalse);
      });

      test('loadBytes fetches and returns compiled svg from url', () async {
        final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);

        const svgString =
            '<svg width="10" height="10"><rect width="10" height="10"/></svg>';

        server.listen((request) {
          request.response
            ..statusCode = HttpStatus.ok
            ..write(svgString)
            ..close().ignore();
        });

        final url = 'http://${server.address.host}:${server.port}/test.svg';
        final loader = NetworkSvgLoader(url);

        final byteData = await loader.loadBytes(null);

        expect(byteData, isNotNull);
        expect(byteData.lengthInBytes, greaterThan(0));

        await server.close(force: true);
      });
    });
  });
}
