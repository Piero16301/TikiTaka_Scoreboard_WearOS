import 'dart:developer';

import 'package:device_info_plus/device_info_plus.dart';
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

extension AndroidVersion on AndroidBuildVersion {
  Map<String, dynamic> toJson() {
    return {
      'codename': codename,
      'incremental': incremental,
      'previewSdkInt': previewSdkInt ?? 0,
      'release': release,
      'sdkInt': sdkInt,
      'securityPatch': securityPatch ?? '',
    };
  }
}

extension AndroidInfo on AndroidDeviceInfo {
  Map<String, dynamic> toJson() {
    return {
      'version': version.toJson(),
      'board': board,
      'bootloader': bootloader,
      'brand': brand,
      'device': device,
      'display': display,
      'fingerprint': fingerprint,
      'hardware': hardware,
      'host': host,
      'id': id,
      'manufacturer': manufacturer,
      'model': model,
      'product': product,
      'supported32BitAbis': supported32BitAbis,
      'supported64BitAbis': supported64BitAbis,
      'supportedAbis': supportedAbis,
      'tags': tags,
      'type': type,
      'isPhysicalDevice': isPhysicalDevice,
      'systemFeatures': systemFeatures,
      'isLowRamDevice': isLowRamDevice,
      'physicalRamSize': physicalRamSize,
      'availableRamSize': availableRamSize,
    };
  }
}

extension LocaleParser on Locale {
  String get toShortString {
    if (countryCode == null) return languageCode;
    return '${languageCode}_$countryCode';
  }
}
