import 'package:material_ui/material_ui.dart';
import 'package:tiki_taka_scoreboard_wearos/app/widgets/waving_flag_painter.dart';

class WavingFlagBackground extends StatefulWidget {
  const WavingFlagBackground({required this.colors, super.key});

  final List<Color> colors;

  @override
  State<WavingFlagBackground> createState() => _WavingFlagBackgroundState();
}

class _WavingFlagBackgroundState extends State<WavingFlagBackground>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late final AnimationController _animationController;
  late WavingFlagPainter _painter;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );
    _painter = WavingFlagPainter(
      colors: widget.colors,
      animation: _animationController,
    );
    _animationController.repeat();
  }

  @override
  void didUpdateWidget(WavingFlagBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.colors != widget.colors) {
      _painter = WavingFlagPainter(
        colors: widget.colors,
        animation: _animationController,
      );
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (!_animationController.isAnimating) {
        _animationController.repeat();
      }
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.hidden) {
      _animationController.stop();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: SizedBox.expand(child: CustomPaint(painter: _painter)),
    );
  }
}
