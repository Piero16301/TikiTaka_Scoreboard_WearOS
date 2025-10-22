import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tiki_taka_scoreboard_wearos/app/global/extensions.dart';

void main() {
  group('NetworkSvgLoader', () {
    const testUrl = 'https://example.com/test.svg';

    test('constructor initializes correctly with runtime value', () {
      // ignore: prefer_const_declarations // Testing with non-const value
      final url = 'https://example.com/test.svg';
      final loader = NetworkSvgLoader(url);

      expect(loader, isA<NetworkSvgLoader>());
      expect(loader.url, equals(url));
    });

    test('url property is accessible', () {
      const testUrl = 'https://example.com/icon.svg';
      const loader = NetworkSvgLoader(testUrl);

      expect(loader.url, equals(testUrl));
      expect(loader.url, isA<String>());
    });

    test('loadBytes returns Future<ByteData>', () {
      const loader = NetworkSvgLoader(testUrl);

      final result = loader.loadBytes(null);

      expect(result, isA<Future<ByteData>>());
    }, skip: true);

    testWidgets('loadBytes can be called with BuildContext', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              const loader = NetworkSvgLoader(testUrl);
              final result = loader.loadBytes(context);
              expect(result, isA<Future<ByteData>>());
              return Container();
            },
          ),
        ),
      );
    }, skip: true);

    test('loadBytes with real small SVG from GitHub', () async {
      const testSvgUrl =
          'https://raw.githubusercontent.com/simple-icons/simple-icons/develop'
          '/icons/flutter.svg';
      const loader = NetworkSvgLoader(testSvgUrl);

      final byteData = await loader.loadBytes(null);

      expect(byteData, isA<ByteData>());
      expect(byteData.lengthInBytes, greaterThan(0));
    }, skip: true);

    test('hashCode is based on url', () {
      const loader1 = NetworkSvgLoader(testUrl);
      const loader2 = NetworkSvgLoader(testUrl);
      const loader3 = NetworkSvgLoader('https://example.com/other.svg');

      expect(loader1.hashCode, equals(loader2.hashCode));
      expect(loader1.hashCode, isNot(equals(loader3.hashCode)));
    });

    test('different instances with same url have same hash', () {
      const url = 'https://test.com/image.svg';
      const loader1 = NetworkSvgLoader(url);
      const loader2 = NetworkSvgLoader(url);

      final hash1 = loader1.hashCode;
      final hash2 = loader2.hashCode;

      expect(hash1, equals(hash2));
    });

    test('instances with different urls have different hashes', () {
      const loader1 = NetworkSvgLoader('https://test1.com/image.svg');
      const loader2 = NetworkSvgLoader('https://test2.com/image.svg');

      final hash1 = loader1.hashCode;
      final hash2 = loader2.hashCode;

      expect(hash1, isNot(equals(hash2)));
    });

    test('equality operator compares urls correctly', () {
      const loader1 = NetworkSvgLoader(testUrl);
      const loader2 = NetworkSvgLoader(testUrl);
      const loader3 = NetworkSvgLoader('https://example.com/other.svg');

      expect(loader1, equals(loader2));
      expect(loader1, isNot(equals(loader3)));
    });

    test('two loaders with same url are equal', () {
      const loader1 = NetworkSvgLoader(testUrl);
      const loader2 = NetworkSvgLoader(testUrl);

      expect(loader1 == loader2, isTrue);
      expect(loader1.hashCode == loader2.hashCode, isTrue);
    });

    test('two loaders with different urls are not equal', () {
      const loader1 = NetworkSvgLoader(testUrl);
      const loader2 = NetworkSvgLoader('https://different.com/image.svg');

      expect(loader1 == loader2, isFalse);
    });

    test('equality operator returns false for different loader instances', () {
      const loader = NetworkSvgLoader(testUrl);
      const other = NetworkSvgLoader('https://different.com/image.svg');

      expect(loader == other, isFalse);
    });
  });
}
