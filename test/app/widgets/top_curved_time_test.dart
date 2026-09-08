import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';

void main() {
  group('TopCurvedTime', () {
    testWidgets('renders child and curved time properly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TopCurvedTime(
              child: Text('App Content'),
            ),
          ),
        ),
      );

      expect(find.text('App Content'), findsOneWidget);
      expect(find.byType(TopCurvedTime), findsOneWidget);
    });

    testWidgets('updates time string periodically', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TopCurvedTime(
              child: Text('App Content'),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();
    });

    testWidgets(
      'renders with custom backgroundColor and null backgroundColor',
      (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: TopCurvedTime(
                backgroundColor: Colors.blue,
                child: Text('App Content'),
              ),
            ),
          ),
        );
        expect(find.byType(TopCurvedTime), findsOneWidget);

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: TopCurvedTime(
                backgroundColor: null,
                child: Text('App Content'),
              ),
            ),
          ),
        );
        expect(find.byType(TopCurvedTime), findsOneWidget);
      },
    );

    testWidgets(
      'shouldRepaint triggers on background changes or theme differences',
      (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: TopCurvedTime(
                backgroundColor: Colors.red,
                child: Text('App Content'),
              ),
            ),
          ),
        );

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: TopCurvedTime(
                backgroundColor: Colors.blue,
                child: Text('App Content'),
              ),
            ),
          ),
        );

        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              textTheme: const TextTheme(
                labelLarge: TextStyle(fontSize: 12),
              ),
            ),
            home: const Scaffold(
              body: TopCurvedTime(
                child: Text('App Content'),
              ),
            ),
          ),
        );

        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              textTheme: const TextTheme(
                labelLarge: TextStyle(fontSize: 16),
              ),
            ),
            home: const Scaffold(
              body: TopCurvedTime(
                child: Text('App Content'),
              ),
            ),
          ),
        );
      },
    );
  });
}
