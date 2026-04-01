import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vector_graphics/vector_graphics.dart';
import 'package:vector_graphics_compiler/vector_graphics_compiler.dart';

class NetworkSvgLoader extends BytesLoader {
  const NetworkSvgLoader(this.url);

  final String url;

  @override
  Future<ByteData> loadBytes(BuildContext? context) async {
    return compute(
      (svgUrl) async {
        final request = await http.get(Uri.parse(svgUrl));
        final task = TimelineTask()..start('encodeSvg');
        final compiledBytes = encodeSvg(
          xml: request.body,
          debugName: svgUrl,
          enableClippingOptimizer: false,
          enableMaskingOptimizer: false,
          enableOverdrawOptimizer: false,
        );
        task.finish();
        return compiledBytes.buffer.asByteData();
      },
      url,
      debugLabel: 'Load Bytes',
    );
  }

  @override
  int get hashCode => url.hashCode;

  @override
  bool operator ==(Object other) {
    return other is NetworkSvgLoader && other.url == url;
  }
}

extension LocaleParser on Locale {
  String get toShortString {
    if (countryCode == null) return languageCode;
    return '${languageCode}_$countryCode';
  }
}
