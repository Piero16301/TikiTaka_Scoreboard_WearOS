import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';

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
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              color: background.withValues(alpha: 0.3),
              width: dimension,
              height: dimension,
            ),
            Icon(
              Icons.image,
              size: dimension,
            ),
          ],
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
            alignment: Alignment.center,
            children: [
              Container(
                color: background.withValues(alpha: 0.3),
                width: dimension,
                height: dimension,
              ),
              SizedBox(
                width: dimension - (margin * 2),
                height: dimension - (margin * 2),
                child: RepaintBoundary(
                  child: CachedSvgImage(
                    imageUrl: crest,
                    fit: fit,
                    width: dimension - (margin * 2),
                    height: dimension - (margin * 2),
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.image,
                      size: dimension,
                    ),
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
          alignment: Alignment.center,
          children: [
            Container(
              color: background.withValues(alpha: 0.3),
              width: dimension,
              height: dimension,
            ),
            Padding(
              padding: EdgeInsets.all(margin),
              child: CachedNetworkImage(
                width: dimension - (margin * 2),
                height: dimension - (margin * 2),
                imageUrl: crest,
                fit: fit,
                errorWidget: (context, url, error) => Icon(
                  Icons.image,
                  size: dimension,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}
