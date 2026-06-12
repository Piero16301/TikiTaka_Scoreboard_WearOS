import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CachedSvgImage extends StatefulWidget {
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
  State<CachedSvgImage> createState() => _CachedSvgImageState();
}

class _CachedSvgImageState extends State<CachedSvgImage> {
  late Future<File> _fileFuture;

  @override
  void initState() {
    super.initState();
    _fileFuture = (widget.cacheManager ?? DefaultCacheManager())
        .getSingleFile(widget.imageUrl);
  }

  @override
  void didUpdateWidget(CachedSvgImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageUrl != widget.imageUrl ||
        oldWidget.cacheManager != widget.cacheManager) {
      _fileFuture = (widget.cacheManager ?? DefaultCacheManager())
          .getSingleFile(widget.imageUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<File>(
      future: _fileFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            width: widget.width,
            height: widget.height,
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
          if (widget.errorBuilder != null) {
            return widget.errorBuilder!(
              context,
              snapshot.error ?? Exception('Failed to load SVG'),
              snapshot.stackTrace ?? StackTrace.empty,
            );
          }
          return SizedBox(
            width: widget.width,
            height: widget.height,
          );
        }

        return SvgPicture.file(
          snapshot.data!,
          width: widget.width,
          height: widget.height,
          fit: widget.fit,
        );
      },
    );
  }
}
