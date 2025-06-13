import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class AppSchimmer extends StatelessWidget {
  const AppSchimmer({
    this.height = 10,
    this.width,
    this.borderRadius,
    super.key,
  });

  final double? height;
  final double? width;
  final BorderRadiusGeometry? borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(10),
      child: Shimmer(
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSurface.withValues(
                  alpha: 0.1,
                ),
            borderRadius: borderRadius ?? BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
