import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CachedSvgImage extends StatelessWidget {
  const CachedSvgImage({
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.errorBuilder,
    this.cacheManager,
    super.key,
  });

  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget Function(BuildContext, Object, StackTrace)? errorBuilder;
  final BaseCacheManager? cacheManager;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<File>(
      future: (cacheManager ?? DefaultCacheManager()).getSingleFile(imageUrl),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            width: width,
            height: height,
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
          if (errorBuilder != null) {
            return errorBuilder!(
              context,
              snapshot.error ?? Exception('Failed to load SVG'),
              snapshot.stackTrace ?? StackTrace.empty,
            );
          }
          return SizedBox(
            width: width,
            height: height,
          );
        }

        return SvgPicture.file(
          snapshot.data!,
          width: width,
          height: height,
          fit: fit,
        );
      },
    );
  }
}
