import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:tiki_taka/app/global/global.dart';
import 'package:tiki_taka/l10n/l10n.dart';
import 'package:vector_graphics/vector_graphics.dart';
import 'package:vector_graphics_compiler/vector_graphics_compiler.dart';

String getMatchState(String status, DateTime date, AppLocalizations l10n) {
  switch (status) {
    case 'SCHEDULED':
      return DateFormat('HH:mm').format(date);
    case 'TIMED':
      return DateFormat('HH:mm').format(date);
    case 'IN_PLAY':
      return l10n.inPlayMatch.toUpperCase();
    case 'PAUSED':
      return l10n.pausedMatch.toUpperCase();
    case 'FINISHED':
      return l10n.finishedMatch.toUpperCase();
    case 'POSTPONED':
      return l10n.postponedMatch.toUpperCase();
    case 'SUSPENDED':
      return l10n.suspendMatch.toUpperCase();
    case 'CANCELED':
      return l10n.cancelledMatch.toUpperCase();
    case 'AWARDED':
      return l10n.awardedMatch.toUpperCase();
    default:
      return l10n.unknownMatch.toUpperCase();
  }
}

String notMatchState(String status, AppLocalizations l10n) {
  switch (status) {
    case 'IN_PLAY':
      return l10n.inPlayMatch.toUpperCase();
    case 'PAUSED':
      return l10n.pausedMatch.toUpperCase();
    case 'FINISHED':
      return l10n.finishedMatch.toUpperCase();
    case 'POSTPONED':
      return l10n.postponedMatch.toUpperCase();
    case 'SUSPENDED':
      return l10n.suspendMatch.toUpperCase();
    case 'CANCELED':
      return l10n.cancelledMatch.toUpperCase();
    case 'AWARDED':
      return l10n.awardedMatch.toUpperCase();
    default:
      return l10n.unknownMatch.toUpperCase();
  }
}

String getTeamColors(String colors) {
  final list = colors.split(' / ');
  final colorIcons = <String>[];
  for (final color in list) {
    colorIcons.add(colorMap[color] ?? defaultColorIcon);
  }

  if (colorIcons.isEmpty) {
    colorIcons
      ..add(defaultColorIcon)
      ..add(defaultColorIcon);
  } else if (colorIcons.length == 1) {
    colorIcons.add(colorIcons.first);
  } else if (colorIcons.length > 2) {
    colorIcons.removeRange(2, colorIcons.length);
  }

  return colorIcons.join();
}

String getTeamScore(int score) {
  return scoreMap[score] ?? defaultScoreIcon;
}

class NetworkSvgLoader extends BytesLoader {
  const NetworkSvgLoader(this.url);

  final String url;

  @override
  Future<ByteData> loadBytes(BuildContext? context) async {
    return compute(
      (String svgUrl) async {
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
