import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rotary_scrollbar/rotary_scrollbar.dart';
import 'package:tiki_taka_scoreboard_wearos/app/widgets/app_rotary_scrollbar.dart';

void main() {
  group('$AppRotaryScrollbar', () {
    late ScrollController scrollController;

    setUp(() {
      scrollController = ScrollController();
    });

    tearDown(() {
      scrollController.dispose();
    });

    test('can be instantiated', () {
      final widget = AppRotaryScrollbar(
        controller: scrollController,
        child: Container(),
      );
      expect(widget, isNotNull);
    });

    testWidgets('renders RotaryScrollbar with correct properties', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppRotaryScrollbar(
              controller: scrollController,
              child: const Text('Test Child'),
            ),
          ),
        ),
      );

      expect(find.byType(RotaryScrollbar), findsOneWidget);
      expect(find.text('Test Child'), findsOneWidget);
    });

    testWidgets('passes controller to RotaryScrollbar', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppRotaryScrollbar(
              controller: scrollController,
              child: const Text('Test'),
            ),
          ),
        ),
      );

      final rotaryScrollbar = tester.widget<RotaryScrollbar>(
        find.byType(RotaryScrollbar),
      );
      expect(rotaryScrollbar.controller, equals(scrollController));
    });

    testWidgets('applies correct scroll animation curve', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppRotaryScrollbar(
              controller: scrollController,
              child: const Text('Test'),
            ),
          ),
        ),
      );

      final rotaryScrollbar = tester.widget<RotaryScrollbar>(
        find.byType(RotaryScrollbar),
      );
      expect(rotaryScrollbar.scrollAnimationCurve, equals(Curves.easeInOut));
    });

    testWidgets('applies correct scroll animation duration', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppRotaryScrollbar(
              controller: scrollController,
              child: const Text('Test'),
            ),
          ),
        ),
      );

      final rotaryScrollbar = tester.widget<RotaryScrollbar>(
        find.byType(RotaryScrollbar),
      );
      expect(
        rotaryScrollbar.scrollAnimationDuration,
        equals(const Duration(milliseconds: 200)),
      );
    });

    testWidgets('applies correct scroll magnitude', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppRotaryScrollbar(
              controller: scrollController,
              child: const Text('Test'),
            ),
          ),
        ),
      );

      final rotaryScrollbar = tester.widget<RotaryScrollbar>(
        find.byType(RotaryScrollbar),
      );
      expect(rotaryScrollbar.scrollMagnitude, equals(5));
    });

    testWidgets('applies correct padding', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppRotaryScrollbar(
              controller: scrollController,
              child: const Text('Test'),
            ),
          ),
        ),
      );

      final rotaryScrollbar = tester.widget<RotaryScrollbar>(
        find.byType(RotaryScrollbar),
      );
      expect(rotaryScrollbar.padding, equals(0));
    });

    testWidgets('uses default autoHide value', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppRotaryScrollbar(
              controller: scrollController,
              child: const Text('Test'),
            ),
          ),
        ),
      );

      final rotaryScrollbar = tester.widget<RotaryScrollbar>(
        find.byType(RotaryScrollbar),
      );
      expect(rotaryScrollbar.autoHide, equals(true));
    });

    testWidgets('renders child widget correctly', (tester) async {
      const testChild = Text('Custom Child Widget');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppRotaryScrollbar(
              controller: scrollController,
              child: testChild,
            ),
          ),
        ),
      );

      expect(find.text('Custom Child Widget'), findsOneWidget);
      expect(find.byWidget(testChild), findsOneWidget);
    });

    testWidgets('works with scrollable content', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppRotaryScrollbar(
              controller: scrollController,
              child: ListView.builder(
                controller: scrollController,
                itemCount: 50,
                itemBuilder: (context, index) => ListTile(
                  title: Text('Item $index'),
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(ListView), findsOneWidget);
      expect(find.text('Item 0'), findsOneWidget);

      expect(scrollController.hasClients, isTrue);

      await tester.pumpAndSettle(const Duration(seconds: 5));
    });
  });
}
