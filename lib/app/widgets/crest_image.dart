import 'package:flutter/material.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';
import 'package:vector_graphics/vector_graphics.dart';

class CrestImage extends StatelessWidget {
  const CrestImage({
    required this.crest,
    this.dimension = 40,
    this.fit = BoxFit.fill,
    this.hideCrest = false,
    this.margin = 0,
    this.borderRadius = 10,
    super.key,
  });

  final String crest;
  final double dimension;
  final BoxFit fit;
  final bool hideCrest;
  final double margin;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final background = Theme.of(context).colorScheme.inverseSurface;

    if (crest.isEmpty || hideCrest) {
      return SizedBox(
        height: dimension,
        width: dimension,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Stack(
            children: [
              Container(
                color: background.withValues(alpha: 0.3),
                width: dimension,
                height: dimension,
              ),
              SizedBox(
                width: dimension - (margin * 2),
                height: dimension - (margin * 2),
                child: Icon(
                  Icons.image,
                  size: dimension - (margin * 2),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (crest.contains('.svg')) {
      return SizedBox(
        height: dimension,
        width: dimension,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Stack(
            children: [
              Container(
                color: background.withValues(alpha: 0.3),
                width: dimension,
                height: dimension,
              ),
              SizedBox(
                width: dimension - (margin * 2),
                height: dimension - (margin * 2),
                child: VectorGraphic(
                  loader: NetworkSvgLoader(crest),
                  fit: fit,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.image,
                    size: dimension - (margin * 2),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Stack(
          children: [
            Container(
              color: background.withValues(alpha: 0.3),
              width: dimension,
              height: dimension,
            ),
            Padding(
              padding: EdgeInsets.all(margin),
              child: Image.network(
                width: dimension - (margin * 2),
                height: dimension - (margin * 2),
                crest,
                fit: fit,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.image,
                  size: dimension - (margin * 2),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}
