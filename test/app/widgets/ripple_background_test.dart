import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';

void main() {
  group('$RippleBackground', () {
    final testColors = [Colors.blue, Colors.purple];
    const testChild = Text('Test Child');

    test('can be instantiated', () {
      final widget = RippleBackground(
        colors: testColors,
        child: testChild,
      );
      expect(widget, isNotNull);
    });

    testWidgets('renders child widget', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RippleBackground(
              colors: testColors,
              child: testChild,
            ),
          ),
        ),
      );

      expect(find.text('Test Child'), findsOneWidget);
    });

    testWidgets('renders CustomPaint with RipplePainter', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RippleBackground(
              colors: testColors,
              child: testChild,
            ),
          ),
        ),
      );

      final customPaintFinder = find.descendant(
        of: find.byType(RippleBackground),
        matching: find.byType(CustomPaint),
      );
      expect(customPaintFinder, findsOneWidget);

      final customPaint = tester.widget<CustomPaint>(customPaintFinder);
      expect(customPaint.painter, isA<RipplePainter>());
    });

    testWidgets('passes colors to RipplePainter', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RippleBackground(
              colors: testColors,
              child: testChild,
            ),
          ),
        ),
      );

      final customPaint = tester.widget<CustomPaint>(
        find.descendant(
          of: find.byType(RippleBackground),
          matching: find.byType(CustomPaint),
        ),
      );
      final painter = customPaint.painter! as RipplePainter;
      expect(painter.colors, equals(testColors));
    });

    testWidgets('animation updates painter animationValue', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RippleBackground(
              colors: testColors,
              child: testChild,
            ),
          ),
        ),
      );

      double getAnimationValue() {
        final customPaint = tester.widget<CustomPaint>(
          find.descendant(
            of: find.byType(RippleBackground),
            matching: find.byType(CustomPaint),
          ),
        );
        final painter = customPaint.painter! as RipplePainter;
        return painter.animationValue;
      }

      final initialValue = getAnimationValue();
      expect(initialValue, equals(0.0));

      await tester.pump(const Duration(milliseconds: 500));
      final valueAfter500ms = getAnimationValue();
      expect(valueAfter500ms, greaterThan(initialValue));
      expect(valueAfter500ms, lessThan(1.0));

      await tester.pump(const Duration(milliseconds: 2500));
      final valueAfter3s = getAnimationValue();
      expect(valueAfter3s, greaterThan(valueAfter500ms));
    });

    testWidgets('animation repeats indefinitely', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RippleBackground(
              colors: testColors,
              child: testChild,
            ),
          ),
        ),
      );

      await tester.pump(const Duration(seconds: 5));

      double getAnimationValue() {
        final customPaint = tester.widget<CustomPaint>(
          find.descendant(
            of: find.byType(RippleBackground),
            matching: find.byType(CustomPaint),
          ),
        );
        final painter = customPaint.painter! as RipplePainter;
        return painter.animationValue;
      }

      final valueAfterOneCycle = getAnimationValue();

      await tester.pump(const Duration(seconds: 5));
      final valueAfterTwoCycles = getAnimationValue();

      expect(
        (valueAfterOneCycle - valueAfterTwoCycles).abs(),
        lessThan(0.1),
      );
    });

    testWidgets('disposes animation controller properly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RippleBackground(
              colors: testColors,
              child: testChild,
            ),
          ),
        ),
      );

      expect(find.byType(RippleBackground), findsOneWidget);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SizedBox.shrink(),
          ),
        ),
      );

      expect(find.byType(RippleBackground), findsNothing);
    });

    testWidgets('works with multiple colors', (tester) async {
      final multipleColors = [
        Colors.red,
        Colors.green,
        Colors.blue,
        Colors.yellow,
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RippleBackground(
              colors: multipleColors,
              child: testChild,
            ),
          ),
        ),
      );

      final customPaint = tester.widget<CustomPaint>(
        find.descendant(
          of: find.byType(RippleBackground),
          matching: find.byType(CustomPaint),
        ),
      );
      final painter = customPaint.painter! as RipplePainter;
      expect(painter.colors.length, equals(4));
      expect(painter.colors, equals(multipleColors));
    });

    testWidgets('child widget receives parent constraints', (tester) async {
      const containerKey = Key('test_container');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 200,
              height: 200,
              child: RippleBackground(
                colors: testColors,
                child: Container(
                  key: containerKey,
                  color: Colors.transparent,
                ),
              ),
            ),
          ),
        ),
      );

      final containerFinder = find.byKey(containerKey);
      expect(containerFinder, findsOneWidget);

      final containerSize = tester.getSize(containerFinder);
      expect(containerSize.width, equals(200.0));
      expect(containerSize.height, equals(200.0));
    });

    testWidgets('CustomPaint fills available space', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 300,
              height: 300,
              child: RippleBackground(
                colors: testColors,
                child: testChild,
              ),
            ),
          ),
        ),
      );

      final customPaintSize = tester.getSize(
        find.descendant(
          of: find.byType(RippleBackground),
          matching: find.byType(CustomPaint),
        ),
      );
      expect(customPaintSize.width, equals(300.0));
      expect(customPaintSize.height, equals(300.0));
    });

    testWidgets('animation duration is 5 seconds', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RippleBackground(
              colors: testColors,
              child: testChild,
            ),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 2500));

      final customPaint = tester.widget<CustomPaint>(
        find.descendant(
          of: find.byType(RippleBackground),
          matching: find.byType(CustomPaint),
        ),
      );
      final painter = customPaint.painter! as RipplePainter;

      expect(painter.animationValue, greaterThan(0.4));
      expect(painter.animationValue, lessThan(0.6));
    });

    testWidgets('preserves child widget during animation', (tester) async {
      const uniqueKey = Key('unique_child');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RippleBackground(
              colors: testColors,
              child: Container(
                key: uniqueKey,
                child: testChild,
              ),
            ),
          ),
        ),
      );

      expect(find.byKey(uniqueKey), findsOneWidget);
      expect(find.text('Test Child'), findsOneWidget);

      await tester.pump(const Duration(seconds: 1));

      expect(find.byKey(uniqueKey), findsOneWidget);
      expect(find.text('Test Child'), findsOneWidget);

      await tester.pump(const Duration(seconds: 3));

      expect(find.byKey(uniqueKey), findsOneWidget);
      expect(find.text('Test Child'), findsOneWidget);
    });
  });
}
