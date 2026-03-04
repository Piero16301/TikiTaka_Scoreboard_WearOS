import 'package:flutter/material.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';
import 'package:vector_graphics/vector_graphics.dart';

class CrestImage extends StatelessWidget {
  const CrestImage({
    required this.crest,
    this.dimension = 40,
    this.fit = BoxFit.fill,
    this.hideCrest = false,
    super.key,
  });

  final String crest;
  final double dimension;
  final BoxFit fit;
  final bool hideCrest;

  @override
  Widget build(BuildContext context) {
    if (crest.isEmpty || hideCrest) {
      return SizedBox(
        height: dimension,
        width: dimension,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(7),
          child: SizedBox(
            width: dimension,
            height: dimension,
            child: Icon(
              Icons.image,
              size: dimension,
            ),
          ),
        ),
      );
    }

    if (crest.contains('.svg')) {
      return SizedBox(
        height: dimension,
        width: dimension,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(7),
          child: SizedBox(
            width: dimension,
            height: dimension,
            child: VectorGraphic(
              loader: NetworkSvgLoader(crest),
              fit: fit,
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.image,
                size: dimension,
              ),
            ),
          ),
        ),
      );
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(7),
        child: Image.network(
          crest,
          width: dimension,
          height: dimension,
          fit: fit,
          errorBuilder: (context, error, stackTrace) => Icon(
            Icons.image,
            size: dimension,
          ),
        ),
      );
    }
  }
}
