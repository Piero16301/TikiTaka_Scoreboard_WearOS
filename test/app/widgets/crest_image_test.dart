import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file/file.dart' as pkg_file;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';

class MockCacheManager extends Mock implements BaseCacheManager {}

class MockFile extends Mock implements pkg_file.File {}

class MockHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return _MockHttpClient();
  }
}

class _MockHttpClient extends Fake implements HttpClient {
  @override
  bool autoUncompress = true;

  @override
  Future<HttpClientRequest> getUrl(Uri url) async {
    if (url.toString().contains('error')) {
      return _ErrorMockHttpClientRequest();
    }
    return _MockHttpClientRequest(isSvg: url.toString().contains('.svg'));
  }

  @override
  Future<HttpClientRequest> openUrl(String method, Uri url) async {
    if (url.toString().contains('error')) {
      return _ErrorMockHttpClientRequest();
    }
    return _MockHttpClientRequest(isSvg: url.toString().contains('.svg'));
  }

  @override
  void close({bool force = false}) {}
}

class _MockHttpClientRequest extends Fake implements HttpClientRequest {
  _MockHttpClientRequest({this.isSvg = false});

  final bool isSvg;

  @override
  bool followRedirects = true;

  @override
  int maxRedirects = 5;

  @override
  int contentLength = 0;

  @override
  bool persistentConnection = true;

  @override
  bool bufferOutput = true;

  @override
  HttpHeaders get headers => _MockHttpHeaders(isSvg: isSvg);

  @override
  Future<void> addStream(Stream<List<int>> stream) async {}

  @override
  Future<HttpClientResponse> close() async =>
      _MockHttpClientResponse(isSvg: isSvg);
}

class _ErrorMockHttpClientRequest extends Fake implements HttpClientRequest {
  @override
  bool followRedirects = true;

  @override
  int maxRedirects = 5;

  @override
  int contentLength = 0;

  @override
  bool persistentConnection = true;

  @override
  bool bufferOutput = true;

  @override
  HttpHeaders get headers => _MockHttpHeaders();

  @override
  Future<void> addStream(Stream<List<int>> stream) async {}

  @override
  Future<HttpClientResponse> close() async => _ErrorMockHttpClientResponse();
}

class _MockHttpHeaders extends Fake implements HttpHeaders {
  _MockHttpHeaders({bool isSvg = false}) {
    if (isSvg) {
      _headers['content-type'] = ['image/svg+xml'];
    }
  }
  final Map<String, List<String>> _headers = {
    'content-type': ['image/png'],
  };

  @override
  List<String>? operator [](String name) => _headers[name.toLowerCase()];

  @override
  void forEach(void Function(String name, List<String> values) f) {
    _headers.forEach(f);
  }

  @override
  void add(String name, Object value, {bool preserveHeaderCase = false}) {}
}

class _MockHttpClientResponse extends Fake implements HttpClientResponse {
  _MockHttpClientResponse({this.isSvg = false});

  final bool isSvg;

  @override
  int get statusCode => 200;

  @override
  int get contentLength => -1;

  @override
  HttpClientResponseCompressionState get compressionState =>
      HttpClientResponseCompressionState.notCompressed;

  @override
  HttpHeaders get headers => _MockHttpHeaders(isSvg: isSvg);

  @override
  bool get isRedirect => false;

  @override
  bool get persistentConnection => true;

  @override
  String get reasonPhrase => 'OK';

  @override
  List<RedirectInfo> get redirects => const [];

  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int> event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    final bytes = isSvg
        ? '<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><circle cx="50" cy="50" r="50" fill="red" /></svg>'
              .codeUnits
        : [0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A];
    return Stream<List<int>>.periodic(
          const Duration(milliseconds: 10),
          (_) => bytes,
        )
        .take(1)
        .listen(
          onData,
          onError: onError,
          onDone: onDone,
          cancelOnError: cancelOnError,
        );
  }
}

class _ErrorMockHttpClientResponse extends Fake implements HttpClientResponse {
  @override
  int get statusCode => 404;

  @override
  int get contentLength => 0;

  @override
  HttpClientResponseCompressionState get compressionState =>
      HttpClientResponseCompressionState.notCompressed;

  @override
  HttpHeaders get headers => _MockHttpHeaders();

  @override
  bool get isRedirect => false;

  @override
  bool get persistentConnection => true;

  @override
  String get reasonPhrase => 'Not Found';

  @override
  List<RedirectInfo> get redirects => const [];

  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int> event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return const Stream<List<int>>.empty().listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }
}

void main() {
  setUpAll(() {
    HttpOverrides.global = MockHttpOverrides();
  });

  group('CrestImage', () {
    late MockCacheManager mockCacheManager;

    setUp(() {
      mockCacheManager = MockCacheManager();
      registerFallbackValue(Uri.parse('https://example.com'));
    });
    testWidgets('renders placeholder when crest is empty', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CrestImage(crest: ''),
          ),
        ),
      );

      expect(find.byType(Icon), findsOneWidget);
      expect(find.byIcon(Icons.image), findsOneWidget);
    });

    testWidgets('renders placeholder when hideCrest is true', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CrestImage(
              crest: 'https://example.com/logo.png',
              hideCrest: true,
            ),
          ),
        ),
      );

      expect(find.byType(Icon), findsOneWidget);
      expect(find.byIcon(Icons.image), findsOneWidget);
    });

    testWidgets('renders Image.network for regular images', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CrestImage(crest: 'https://example.com/logo.png'),
          ),
        ),
      );

      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('applies dimension correctly', (tester) async {
      const dimension = 60.0;
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CrestImage(crest: '', height: dimension, width: dimension),
          ),
        ),
      );

      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox).first);
      expect(sizedBox.width, dimension);
      expect(sizedBox.height, dimension);
    });

    testWidgets('renders placeholder on regular image error', (tester) async {
      when(
        () => mockCacheManager.getFileStream(
          any(),
          key: any(named: 'key'),
          headers: any(named: 'headers'),
          withProgress: any(named: 'withProgress'),
        ),
      ).thenAnswer((_) => Stream.error(Exception('Failed to load')));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CrestImage(
              crest: 'https://example.com/error.png',
              cacheManager: mockCacheManager,
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.image), findsOneWidget);
    });

    testWidgets('renders SvgPicture.network for SVG images', (tester) async {
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
          home: Scaffold(
            body: CrestImage(
              crest: 'https://example.com/logo.svg',
              cacheManager: mockCacheManager,
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.byType(SvgPicture), findsOneWidget);
    });

    testWidgets('renders placeholder on SVG image error', (tester) async {
      when(
        () => mockCacheManager.getSingleFile(any()),
      ).thenAnswer((_) async => throw Exception('Failed to load'));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CrestImage(
              crest: 'https://example.com/error.svg',
              cacheManager: mockCacheManager,
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.image), findsOneWidget);
    });

    testWidgets('renders with background and margin', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CrestImage(
              crest: '',
              showBackground: true,
              margin: 4,
            ),
          ),
        ),
      );
      expect(find.byType(Container), findsWidgets);
      expect(find.byType(Icon), findsOneWidget);

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
          home: Scaffold(
            body: CrestImage(
              crest: 'https://example.com/logo.svg',
              cacheManager: mockCacheManager,
              showBackground: true,
              margin: 4,
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pumpAndSettle();
      expect(find.byType(Container), findsWidgets);
      expect(find.byType(SvgPicture), findsOneWidget);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CrestImage(
              crest: 'https://example.com/logo.png',
              cacheManager: mockCacheManager,
              showBackground: true,
              margin: 4,
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pumpAndSettle();
      expect(find.byType(Container), findsWidgets);
      expect(find.byType(CachedNetworkImage), findsOneWidget);
    });
  });
}
