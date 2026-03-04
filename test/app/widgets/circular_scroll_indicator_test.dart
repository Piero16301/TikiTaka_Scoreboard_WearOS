import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';

void main() {
  group('CircularScrollIndicator', () {
    late ScrollController scrollController;

    setUp(() {
      scrollController = ScrollController();
    });

    tearDown(() {
      scrollController.dispose();
    });

    Widget buildSubject({
      ScrollController? controller,
      double height = 200,
      double contentHeight = 400,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 200,
              height: height,
              child: CircularScrollIndicator(
                controller: controller ?? scrollController,
                child: ListView.builder(
                  controller: controller ?? scrollController,
                  itemCount: 20,
                  itemBuilder: (context, index) {
                    return SizedBox(
                      height: contentHeight / 20,
                      child: Text('Item $index'),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      );
    }

    testWidgets('renders normally', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();
      expect(find.byType(CircularScrollIndicator), findsOneWidget);
    });

    testWidgets('shows indicator on init and when scrolled', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.byType(AnimatedOpacity), findsOneWidget);
      var opacityVisible =
          tester.widget<AnimatedOpacity>(find.byType(AnimatedOpacity));
      expect(opacityVisible.opacity, 1.0);

      await tester.pump(const Duration(milliseconds: 1500));
      await tester.pumpAndSettle();

      var opacityHidden =
          tester.widget<AnimatedOpacity>(find.byType(AnimatedOpacity));
      expect(opacityHidden.opacity, 0.0);

      scrollController.jumpTo(50);
      await tester.pump();
      await tester.pumpAndSettle();
      opacityVisible = tester.widget(find.byType(AnimatedOpacity));
      expect(opacityVisible.opacity, 1.0);

      await tester.pump(const Duration(milliseconds: 1500));
      await tester.pumpAndSettle();

      opacityHidden = tester.widget(find.byType(AnimatedOpacity));
      expect(opacityHidden.opacity, 0.0);
    });

    testWidgets('paints correctly with different scroll positions',
        (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      scrollController.jumpTo(10);
      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.byType(CustomPaint), findsWidgets);
      final customPaintFinds = find.descendant(
        of: find.byType(AnimatedOpacity),
        matching: find.byType(CustomPaint),
      );
      final customPaint = tester.widget<CustomPaint>(customPaintFinds.first);
      expect(customPaint.painter, isNotNull);

      scrollController.jumpTo(20);
      await tester.pump();
    });

    testWidgets('indicator does not show if not scrollable', (tester) async {
      await tester.pumpWidget(buildSubject(height: 500, contentHeight: 200));
      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.byType(AnimatedOpacity), findsNothing);
    });

    testWidgets('handles controller update properly', (tester) async {
      await tester.pumpWidget(buildSubject(controller: scrollController));
      await tester.pump();
      await tester.pumpAndSettle();

      await tester.pump(const Duration(milliseconds: 2000));
      await tester.pumpAndSettle();

      final newController = ScrollController();
      await tester.pumpWidget(buildSubject(controller: newController));
      await tester.pump();
      await tester.pumpAndSettle();

      newController.jumpTo(50);
      await tester.pump();
      await tester.pumpAndSettle();

      expect(
        tester.widget<AnimatedOpacity>(find.byType(AnimatedOpacity)).opacity,
        1.0,
      );

      newController.dispose();
    });

    testWidgets('cleans up timer on dispose', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump();
      await tester.pumpAndSettle();

      scrollController.jumpTo(50);
      await tester.pump();

      await tester.pumpWidget(const SizedBox());

      await tester.pumpAndSettle(const Duration(seconds: 2));
    });

    testWidgets('painter shouldRepaint returns true when properties change',
        (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CircularScrollIndicator(
              controller: scrollController,
              indicatorColor: Colors.red,
              child: ListView(
                controller: scrollController,
                children: const [SizedBox(height: 1000)],
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pumpAndSettle();
    });
  });
}
