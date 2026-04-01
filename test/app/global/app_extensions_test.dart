import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';

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
