import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';

class CrestImage extends StatelessWidget {
  const CrestImage({
    required this.crest,
    this.height = 40,
    this.width = 40,
    this.fit = BoxFit.fill,
    this.hideCrest = false,
    this.margin = 0,
    this.borderRadius,
    this.cacheManager,
    this.showBackground = false,
    super.key,
  });

  final String crest;
  final double height;
  final double width;
  final BoxFit fit;
  final bool hideCrest;
  final double margin;
  final BorderRadiusGeometry? borderRadius;
  final BaseCacheManager? cacheManager;
  final bool showBackground;

  @override
  Widget build(BuildContext context) {
    final background = Theme.of(context).colorScheme.inverseSurface;
    final borderRadius = this.borderRadius ?? BorderRadius.circular(10);
    final applyMargin = showBackground || margin != 0;

    if (crest.isEmpty || hideCrest) {
      return SizedBox(
        width: width,
        height: height,
        child: ClipRRect(
          borderRadius: borderRadius,
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (showBackground)
                Container(
                  color: background.withValues(alpha: 0.3),
                  width: width,
                  height: height,
                ),
              Icon(
                Icons.image,
                size: applyMargin ? width - (margin * 2) : width,
              ),
            ],
          ),
        ),
      );
    }

    if (crest.contains('.svg')) {
      return SizedBox(
        height: height,
        width: width,
        child: ClipRRect(
          borderRadius: borderRadius,
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (showBackground)
                Container(
                  color: background.withValues(alpha: 0.3),
                  width: width,
                  height: height,
                ),
              SizedBox(
                width: applyMargin ? width - (margin * 2) : width,
                height: applyMargin ? height - (margin * 2) : height,
                child: RepaintBoundary(
                  child: CachedSvgImage(
                    imageUrl: crest,
                    cacheManager: cacheManager,
                    fit: fit,
                    width: applyMargin ? width - (margin * 2) : width,
                    height: applyMargin ? height - (margin * 2) : height,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.image,
                      size: applyMargin ? width - (margin * 2) : width,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return SizedBox(
        width: width,
        height: height,
        child: ClipRRect(
          borderRadius: borderRadius,
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (showBackground)
                Container(
                  color: background.withValues(alpha: 0.3),
                  width: width,
                  height: height,
                ),
              Padding(
                padding: applyMargin ? EdgeInsets.all(margin) : EdgeInsets.zero,
                child: CachedNetworkImage(
                  width: applyMargin ? width - (margin * 2) : width,
                  height: applyMargin ? height - (margin * 2) : height,
                  imageUrl: crest,
                  cacheManager: cacheManager,
                  fit: fit,
                  errorWidget: (context, url, error) => Icon(
                    Icons.image,
                    size: applyMargin ? width - (margin * 2) : width,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
