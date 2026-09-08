import 'dart:async';
import 'dart:typed_data';

import 'package:file/file.dart' as pkg_file;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';

class MockCacheManager extends Mock implements BaseCacheManager {}

class MockFile extends Mock implements pkg_file.File {}

void main() {
  group('CachedSvgImage', () {
    late MockCacheManager mockCacheManager;

    setUp(() {
      mockCacheManager = MockCacheManager();
    });

    testWidgets('renders SizedBox while waiting', (tester) async {
      final completer = Completer<pkg_file.File>();
      when(
        () => mockCacheManager.getSingleFile(any()),
      ).thenAnswer((_) => completer.future);

      await tester.pumpWidget(
        MaterialApp(
          home: CachedSvgImage(
            imageUrl: 'https://example.com/logo.svg',
            cacheManager: mockCacheManager,
            width: 50,
            height: 50,
          ),
        ),
      );

      expect(find.byType(SizedBox), findsOneWidget);
      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
      expect(sizedBox.width, 50);
      expect(sizedBox.height, 50);
    });

    testWidgets('renders SvgPicture.file on success', (tester) async {
      final mockFile = MockFile();
      when(() => mockFile.path).thenReturn('test.svg');
      when(mockFile.readAsBytesSync).thenReturn(
        Uint8List.fromList(
          '<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><circle cx="50" cy="50" r="50" fill="red" /></svg>'
              .codeUnits,
        ),
      );

      when(
        () => mockCacheManager.getSingleFile(any()),
      ).thenAnswer((_) async => mockFile);

      await tester.pumpWidget(
        MaterialApp(
          home: CachedSvgImage(
            imageUrl: 'https://example.com/logo.svg',
            cacheManager: mockCacheManager,
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(SvgPicture), findsOneWidget);
    });

    testWidgets('renders errorBuilder on error', (tester) async {
      when(
        () => mockCacheManager.getSingleFile(any()),
      ).thenAnswer((_) async => throw Exception('Failed to load'));

      await tester.pumpWidget(
        MaterialApp(
          home: CachedSvgImage(
            imageUrl: 'https://example.com/logo.svg',
            cacheManager: mockCacheManager,
            errorBuilder: (context, error, stackTrace) => const Text('Error'),
          ),
        ),
      );

      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.text('Error'), findsOneWidget);
    });

    testWidgets('renders SizedBox on error when errorBuilder is null', (
      tester,
    ) async {
      when(
        () => mockCacheManager.getSingleFile(any()),
      ).thenAnswer((_) async => throw Exception('Failed to load'));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CachedSvgImage(
              imageUrl: 'https://example.com/logo.svg',
              cacheManager: mockCacheManager,
              width: 50,
              height: 50,
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pumpAndSettle();

      final sizedBoxFinder = find.descendant(
        of: find.byType(CachedSvgImage),
        matching: find.byType(SizedBox),
      );
      expect(sizedBoxFinder, findsOneWidget);
      final sizedBox = tester.widget<SizedBox>(sizedBoxFinder);
      expect(sizedBox.width, 50);
      expect(sizedBox.height, 50);
    });
  });
}
