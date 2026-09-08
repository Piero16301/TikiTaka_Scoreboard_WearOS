import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';

void main() {
  group('AppIconTextButton', () {
    testWidgets('renders label and icon properly', (tester) async {
      var pressed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppIconTextButton(
              label: 'Test Label',
              icon: const Icon(Icons.star),
              onPressed: () {
                pressed = true;
              },
            ),
          ),
        ),
      );

      expect(find.text('Test Label'), findsOneWidget);
      expect(find.byIcon(Icons.star), findsOneWidget);

      await tester.tap(find.byType(InkWell));
      expect(pressed, isTrue);
    });

    testWidgets('renders properly when onPressed is null', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppIconTextButton(
              label: 'Test Label',
              icon: Icon(Icons.star),
            ),
          ),
        ),
      );

      expect(find.text('Test Label'), findsOneWidget);
      expect(find.byIcon(Icons.star), findsOneWidget);
    });
  });
}
