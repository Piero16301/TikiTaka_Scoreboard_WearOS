import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';
import 'package:wear_os_scrollbar/wear_os_scrollbar.dart';
import 'package:wear_os_scrollbar/wear_os_scrollbar_platform_interface.dart';

class FakeWearOsScrollbarPlatform extends WearOsScrollbarPlatform {
  final _controller = StreamController<double>.broadcast();

  void emit(double delta) => _controller.add(delta);

  @override
  Stream<double> get rotaryScrollEvents => _controller.stream;

  @override
  Future<void> performRotaryHaptic({
    WearOsRotaryHapticType type = WearOsRotaryHapticType.tick,
  }) async {}
}

void main() {
  group('AppScaffold', () {
    testWidgets('basic renders child with padding and background', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AppScaffold.basic(
            background: Text('Background'),
            child: Text('Content'),
          ),
        ),
      );

      expect(find.text('Content'), findsOneWidget);
      expect(find.text('Background'), findsOneWidget);
    });

    testWidgets('basic respects disablePadding', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AppScaffold.basic(
            disablePadding: true,
            child: Text('No Padding'),
          ),
        ),
      );

      final padding = tester.widget<Padding>(
        find.ancestor(
          of: find.text('No Padding'),
          matching: find.byType(Padding),
        ),
      );
      expect(padding.padding, EdgeInsets.zero);
    });

    testWidgets('scrollable renders child and WearOsScrollbar when active', (
      tester,
    ) async {
      final controller = ScrollController();

      await tester.pumpWidget(
        MaterialApp(
          navigatorObservers: [AppVariables.routeObserver],
          home: AppScaffold.scrollable(
            controller: controller,
            background: const Text('Background'),
            child: const Text('Scrollable Content'),
          ),
        ),
      );

      expect(find.text('Scrollable Content'), findsOneWidget);
      expect(find.text('Background'), findsOneWidget);
      expect(find.byType(WearOsScrollbar), findsOneWidget);
    });

    testWidgets(
      'scroll position resets on navigation push, pushNext and popNext',
      (tester) async {
        tester.view.physicalSize = const Size(390, 390);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        final fakePlatform = FakeWearOsScrollbarPlatform();
        WearOsScrollbarPlatform.instance = fakePlatform;

        final controller1 = ScrollController();
        final controller2 = ScrollController();

        await tester.pumpWidget(
          MaterialApp(
            navigatorObservers: [AppVariables.routeObserver],
            routes: {
              '/': (context) => AppScaffold.scrollable(
                controller: controller1,
                child: Column(
                  children: [
                    const Text('Page 1'),
                    ElevatedButton(
                      key: const Key('button'),
                      onPressed: () =>
                          Navigator.of(context).pushNamed('/page2'),
                      child: const Text('Go to page 2'),
                    ),
                    const SizedBox(height: 1000),
                  ],
                ),
              ),
              '/page2': (context) => AppScaffold.scrollable(
                controller: controller2,
                child: Column(
                  children: [
                    const Text('Page 2'),
                    ElevatedButton(
                      key: const Key('back_button'),
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Back'),
                    ),
                    const SizedBox(height: 1000),
                  ],
                ),
              ),
            },
          ),
        );
        await tester.pumpAndSettle();

        // Scroll down on page 1
        controller1.jumpTo(200);
        await tester.pumpAndSettle();
        expect(controller1.offset, 200);

        // Navigate to page 2
        Navigator.of(tester.element(find.text('Page 1'))).pushNamed('/page2');
        await tester.pumpAndSettle();

        expect(find.text('Page 2'), findsOneWidget);
        expect(controller2.offset, 0);

        // Verify that page 1 has WearOsScrollbar
        expect(
          find.descendant(
            of: find.byWidgetPredicate(
              (w) => w is AppScaffold && w.controller == controller1,
              skipOffstage: false,
            ),
            matching: find.byType(WearOsScrollbar, skipOffstage: false),
            skipOffstage: false,
          ),
          findsOneWidget,
        );

        // Emit rotary scroll events while on page 2
        for (var i = 0; i < 10; i++) {
          fakePlatform.emit(50);
          await tester.pump(const Duration(milliseconds: 50));
        }
        await tester.pumpAndSettle();
        expect(controller2.offset, greaterThan(0));

        // Pop back to page 1
        Navigator.of(tester.element(find.text('Page 2'))).pop();
        await tester.pumpAndSettle();

        expect(find.text('Page 1'), findsOneWidget);
        expect(controller1.offset, 0);

        // Page 1 now has active WearOsScrollbar again
        expect(find.byType(WearOsScrollbar), findsOneWidget);
      },
    );

    testWidgets('didPop and route changes properly update subscription', (
      tester,
    ) async {
      final controller = ScrollController();

      await tester.pumpWidget(
        MaterialApp(
          navigatorObservers: [AppVariables.routeObserver],
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => AppScaffold.scrollable(
                        controller: controller,
                        child: const Text('Temporary Route'),
                      ),
                    ),
                  );
                },
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.text('Temporary Route'), findsOneWidget);

      Navigator.of(tester.element(find.text('Temporary Route'))).pop();
      await tester.pumpAndSettle();

      expect(find.text('Temporary Route'), findsNothing);
    });
  });
}
