import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';
import 'package:vector_graphics/vector_graphics.dart';

void main() {
  group('$CrestImage', () {
    const svgCrest = 'https://example.com/crest.svg';
    const pngCrest = 'https://example.com/crest.png';
    const defaultDimension = 40.0;
    const customDimension = 60.0;

    test('can be instantiated', () {
      // ignore: prefer_const_declarations // For testing instantiation
      final crestImage = 'https://example.com/crest.svg';
      final widget = CrestImage(crest: crestImage);
      expect(widget, isNotNull);
    });

    testWidgets('renders VectorGraphic for SVG crests', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CrestImage(crest: svgCrest),
          ),
        ),
      );

      expect(find.byType(VectorGraphic), findsOneWidget);
      expect(find.byType(Image), findsNothing);
    });

    testWidgets('renders Image.network for non-SVG crests', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CrestImage(crest: pngCrest),
          ),
        ),
      );

      expect(find.byType(Image), findsOneWidget);
      expect(find.byType(VectorGraphic), findsNothing);
    });

    testWidgets('uses default dimension when not specified', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CrestImage(crest: pngCrest),
          ),
        ),
      );

      final image = tester.widget<Image>(find.byType(Image));
      expect(image.width, equals(defaultDimension));
      expect(image.height, equals(defaultDimension));
    });

    testWidgets('uses custom dimension when specified', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CrestImage(
              crest: pngCrest,
              dimension: customDimension,
            ),
          ),
        ),
      );

      final image = tester.widget<Image>(find.byType(Image));
      expect(image.width, equals(customDimension));
      expect(image.height, equals(customDimension));
    });

    testWidgets('uses default BoxFit.contain when not specified', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CrestImage(crest: pngCrest),
          ),
        ),
      );

      final image = tester.widget<Image>(find.byType(Image));
      expect(image.fit, equals(BoxFit.fill));
    });

    testWidgets('uses custom BoxFit when specified', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CrestImage(
              crest: pngCrest,
              fit: BoxFit.cover,
            ),
          ),
        ),
      );

      final image = tester.widget<Image>(find.byType(Image));
      expect(image.fit, equals(BoxFit.cover));
    });

    testWidgets('applies ClipRRect with correct border radius for SVG', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CrestImage(crest: svgCrest),
          ),
        ),
      );

      final clipRRect = tester.widget<ClipRRect>(
        find.ancestor(
          of: find.byType(VectorGraphic),
          matching: find.byType(ClipRRect),
        ),
      );
      expect(
        clipRRect.borderRadius,
        equals(BorderRadius.circular(7)),
      );
    });

    testWidgets('applies ClipRRect with correct border radius for non-SVG', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CrestImage(crest: pngCrest),
          ),
        ),
      );

      final clipRRect = tester.widget<ClipRRect>(
        find.ancestor(
          of: find.byType(Image),
          matching: find.byType(ClipRRect),
        ),
      );
      expect(
        clipRRect.borderRadius,
        equals(BorderRadius.circular(7)),
      );
    });

    testWidgets('uses SizedBox with correct dimensions for SVG', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CrestImage(
              crest: svgCrest,
              dimension: customDimension,
            ),
          ),
        ),
      );

      final sizedBox = tester.widget<SizedBox>(
        find.ancestor(
          of: find.byType(ClipRRect),
          matching: find.byType(SizedBox),
        ),
      );
      expect(sizedBox.width, equals(customDimension));
      expect(sizedBox.height, equals(customDimension));
    });

    testWidgets('passes NetworkSvgLoader for SVG crests', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CrestImage(crest: svgCrest),
          ),
        ),
      );

      final vectorGraphic = tester.widget<VectorGraphic>(
        find.byType(VectorGraphic),
      );
      expect(vectorGraphic.loader, isA<NetworkSvgLoader>());
    });

    testWidgets('passes correct URL to Image.network', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CrestImage(crest: pngCrest),
          ),
        ),
      );

      final image = tester.widget<Image>(find.byType(Image));
      final networkImage = image.image as NetworkImage;
      expect(networkImage.url, equals(pngCrest));
    });

    testWidgets('VectorGraphic has error builder', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CrestImage(crest: svgCrest),
          ),
        ),
      );

      final vectorGraphic = tester.widget<VectorGraphic>(
        find.byType(VectorGraphic),
      );
      expect(vectorGraphic.errorBuilder, isNotNull);
    });

    testWidgets('Image.network has error builder', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CrestImage(crest: pngCrest),
          ),
        ),
      );

      final image = tester.widget<Image>(find.byType(Image));
      expect(image.errorBuilder, isNotNull);
    });

    testWidgets(
      'VectorGraphic error builder shows icon with correct dimension',
      (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: CrestImage(
                crest: svgCrest,
                dimension: customDimension,
              ),
            ),
          ),
        );

        final vectorGraphic = tester.widget<VectorGraphic>(
          find.byType(VectorGraphic),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return vectorGraphic.errorBuilder!(
                    context,
                    Exception('Test error'),
                    StackTrace.current,
                  );
                },
              ),
            ),
          ),
        );

        final icon = tester.widget<Icon>(find.byType(Icon));
        expect(icon.size, equals(customDimension));
        expect(icon.icon, equals(Icons.image));
      },
    );

    testWidgets('Image error builder shows icon with correct dimension', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CrestImage(
              crest: pngCrest,
              dimension: customDimension,
            ),
          ),
        ),
      );

      final image = tester.widget<Image>(find.byType(Image));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return image.errorBuilder!(
                  context,
                  Exception('Test error'),
                  StackTrace.current,
                );
              },
            ),
          ),
        ),
      );

      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.size, equals(customDimension));
      expect(icon.icon, equals(Icons.image));
    });

    testWidgets('renders placeholder icon when crest is empty', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CrestImage(crest: ''),
          ),
        ),
      );

      expect(find.byType(Icon), findsOneWidget);
      expect(find.byType(Image), findsNothing);
      expect(find.byType(VectorGraphic), findsNothing);

      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.icon, equals(Icons.image));
      expect(icon.size, equals(defaultDimension));
    });

    testWidgets('renders placeholder icon when hideCrest is true', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CrestImage(
              crest: pngCrest,
              hideCrest: true,
            ),
          ),
        ),
      );

      expect(find.byType(Icon), findsOneWidget);
      expect(find.byType(Image), findsNothing);
      expect(find.byType(VectorGraphic), findsNothing);

      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.icon, equals(Icons.image));
    });

    testWidgets(
      'placeholder uses custom dimension when crest is empty',
      (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: CrestImage(
                crest: '',
                dimension: customDimension,
              ),
            ),
          ),
        );

        final sizedBoxes = tester.widgetList<SizedBox>(find.byType(SizedBox));
        expect(sizedBoxes.any((sb) => sb.width == customDimension), isTrue);
        expect(sizedBoxes.any((sb) => sb.height == customDimension), isTrue);

        final icon = tester.widget<Icon>(find.byType(Icon));
        expect(icon.size, equals(customDimension));
      },
    );

    testWidgets('placeholder has background container with correct color', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CrestImage(crest: ''),
          ),
        ),
      );

      final containers = tester.widgetList<Container>(find.byType(Container));
      expect(containers.length, greaterThan(0));

      final containersWithColor = containers.where((c) => c.color != null);
      expect(containersWithColor.length, greaterThan(0));
    });

    testWidgets('placeholder has ClipRRect with correct border radius', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CrestImage(crest: ''),
          ),
        ),
      );

      final clipRRect = tester.widget<ClipRRect>(
        find.ancestor(
          of: find.byType(Stack),
          matching: find.byType(ClipRRect),
        ),
      );
      expect(
        clipRRect.borderRadius,
        equals(BorderRadius.circular(7)),
      );
    });

    testWidgets('placeholder has Stack with Container and Icon', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CrestImage(crest: ''),
          ),
        ),
      );

      final stacks = tester.widgetList<Stack>(find.byType(Stack));
      expect(stacks.length, greaterThan(0));

      final stackWithTwoChildren = stacks.firstWhere(
        (stack) => stack.children.length == 2,
      );
      expect(stackWithTwoChildren, isNotNull);
    });
  });
}
