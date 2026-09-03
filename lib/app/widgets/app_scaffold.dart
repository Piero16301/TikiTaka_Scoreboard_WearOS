import 'package:material_ui/material_ui.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';
import 'package:wear_os_scrollbar/wear_os_scrollbar.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold.basic({
    required this.child,
    this.disablePadding = false,
    this.background,
    super.key,
  }) : controller = null,
       isScrollable = false;

  const AppScaffold.scrollable({
    required this.child,
    required this.controller,
    this.disablePadding = false,
    this.background,
    super.key,
  }) : isScrollable = true;

  final Widget child;
  final bool disablePadding;
  final ScrollController? controller;
  final bool isScrollable;
  final Widget? background;

  @override
  Widget build(BuildContext context) {
    if (isScrollable && controller != null) {
      return _RouteAwareScrollReset(
        controller: controller!,
        child: WearOsScrollbar(
          controller: controller!,
          child: Scaffold(
            body: SizedBox.expand(
              child: Stack(
                children: [
                  ?background,
                  Padding(
                    padding: disablePadding
                        ? EdgeInsetsGeometry.zero
                        : AppVariables.scaffoldPadding,
                    child: SingleChildScrollView(
                      controller: controller,
                      child: child,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: SizedBox.expand(
        child: Stack(
          children: [
            ?background,
            Padding(
              padding: disablePadding
                  ? EdgeInsetsGeometry.zero
                  : AppVariables.scaffoldPadding,
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}

class _RouteAwareScrollReset extends StatefulWidget {
  const _RouteAwareScrollReset({
    required this.controller,
    required this.child,
  });

  final ScrollController controller;
  final Widget child;

  @override
  State<_RouteAwareScrollReset> createState() => _RouteAwareScrollResetState();
}

class _RouteAwareScrollResetState extends State<_RouteAwareScrollReset>
    with RouteAware {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      AppVariables.routeObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    AppVariables.routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    if (widget.controller.hasClients) {
      widget.controller.jumpTo(0);
    }
  }

  @override
  void didPush() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.controller.hasClients) {
        widget.controller.jumpTo(0);
      }
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
