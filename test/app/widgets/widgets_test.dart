import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';

void main() {
  group('App Widgets Tests', () {
    testWidgets('AppCardData renders its child properly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppCardAction(
              content: Text('Test Card'),
            ),
          ),
        ),
      );
      expect(find.text('Test Card'), findsOneWidget);
    });

    testWidgets('AppFilledButton renders properly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppFilledButton(
              label: 'Click Me',
              icon: const Icon(Icons.add),
              onPressed: () {},
            ),
          ),
        ),
      );
      expect(find.text('Click Me'), findsOneWidget);
      expect(find.byType(Icon), findsOneWidget);
    });

    testWidgets('AppScaffold renders child properly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AppScaffold.basic(
            child: Text('Test Scaffold'),
          ),
        ),
      );
      expect(find.text('Test Scaffold'), findsOneWidget);
    });

    testWidgets('CrestImage renders with empty string', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CrestImage(crest: ''),
          ),
        ),
      );
      expect(find.byType(CrestImage), findsOneWidget);

      await tester.pumpAndSettle();
    });

    testWidgets('WavingFlagBackground and Painter render without error', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WavingFlagBackground(
              colors: [Colors.red, Colors.blue],
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(WavingFlagBackground), findsOneWidget);
    });

    testWidgets('WavingFlagPainter paints directly', (tester) async {
      const painterKey = Key('flag_painter');
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomPaint(
              key: painterKey,
              size: const Size(100, 100),
              painter: WavingFlagPainter(
                colors: [Colors.red],
                animationValue: 0.5,
              ),
            ),
          ),
        ),
      );
      expect(find.byKey(painterKey), findsOneWidget);
    });
  });
}
