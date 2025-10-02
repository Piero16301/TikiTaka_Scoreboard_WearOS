import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:tiki_taka/app/global/global.dart';
import 'package:tiki_taka/l10n/l10n.dart';
import 'package:vector_graphics/vector_graphics.dart';
import 'package:vector_graphics_compiler/vector_graphics_compiler.dart'
    hide Color;

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

List<Color> getTeamColors(String colors) {
  final list = colors.split(' / ');
  final colorIcons = <Color>[];
  for (final color in list) {
    colorIcons.add(colorMap[color] ?? defaultColor);
  }

  if (colorIcons.isEmpty) {
    colorIcons
      ..add(defaultColor)
      ..add(defaultColor);
  } else if (colorIcons.length == 1) {
    colorIcons.add(colorIcons.first);
  } else if (colorIcons.length > 2) {
    colorIcons.removeRange(2, colorIcons.length);
  }

  return colorIcons.map((color) {
    return color.withValues(alpha: 0.4);
  }).toList();
}

String getCompetitionType(String type, AppLocalizations l10n) {
  switch (type) {
    case 'LEAGUE':
      return l10n.leagueCompetition;
    case 'CUP':
      return l10n.cupCompetition;
    case 'SUPER_CUP':
      return l10n.superCupCompetition;
    case 'FRIENDLY':
      return l10n.friendlyCompetition;
    default:
      return l10n.otherCompetition;
  }
}

String getStaffPosition(String position, AppLocalizations l10n) {
  switch (position) {
    case 'Goalkeeper':
      return l10n.goalkeeperPosition;
    case 'Defence':
      return l10n.defencePosition;
    case 'Midfield':
      return l10n.midfieldPosition;
    case 'Offence':
      return l10n.offencePosition;
    case 'Left-Back':
      return l10n.leftBackPosition;
    case 'Central Midfield':
      return l10n.centralMidfieldPosition;
    case 'Attacking Midfield':
      return l10n.attackingMidfieldPosition;
    case 'Centre-Forward':
      return l10n.centreForwardPosition;
    case 'Left Winger':
      return l10n.leftWingerPosition;
    case 'Centre-Back':
      return l10n.centreBackPosition;
    case 'Right Winger':
      return l10n.rightWingerPosition;
    case 'Right-Back':
      return l10n.rightBackPosition;
    case 'Defensive Midfield':
      return l10n.defensiveMidfieldPosition;
    case 'Left Midfield':
      return l10n.leftMidfieldPosition;
    case 'Right Midfield':
      return l10n.rightMidfieldPosition;
    case 'Secondary Forward':
      return l10n.secondaryForwardPosition;
    case 'Coach':
      return l10n.coachPosition;
    case 'Assistant Coach':
      return l10n.assistantCoachPosition;
    case 'Goalkeeping Coach':
      return l10n.goalkeepingCoachPosition;
    case 'Forward Coach':
      return l10n.forwardCoachPosition;
    case 'Caretaker Manager':
      return l10n.caretakerManagerPosition;
    default:
      return l10n.unknownPosition;
  }
}

Color getStaffPositionColor(String position) {
  switch (position) {
    // Goalkeeper positions
    case 'Goalkeeper':
      return Colors.orange.shade600;

    // Defensive positions
    case 'Defence':
    case 'Left-Back':
    case 'Centre-Back':
    case 'Right-Back':
      return Colors.blue.shade600;

    // Midfield positions
    case 'Midfield':
    case 'Central Midfield':
    case 'Defensive Midfield':
    case 'Left Midfield':
    case 'Right Midfield':
    case 'Attacking Midfield':
      return Colors.green.shade600;

    // Offensive positions
    case 'Offence':
    case 'Centre-Forward':
    case 'Left Winger':
    case 'Right Winger':
    case 'Secondary Forward':
      return Colors.red.shade600;

    // Technical staff
    case 'Coach':
    case 'Assistant Coach':
    case 'Goalkeeping Coach':
    case 'Forward Coach':
    case 'Caretaker Manager':
      return Colors.purple.shade600;

    default:
      return Colors.grey.shade600;
  }
}

int getStaffPositionOrder(String position) {
  switch (position) {
    case 'Goalkeeper':
      return 1;
    case 'Defence':
    case 'Left-Back':
    case 'Centre-Back':
    case 'Right-Back':
      return 2;
    case 'Midfield':
    case 'Central Midfield':
    case 'Defensive Midfield':
    case 'Left Midfield':
    case 'Right Midfield':
    case 'Attacking Midfield':
      return 3;
    case 'Offence':
    case 'Centre-Forward':
    case 'Left Winger':
    case 'Right Winger':
    case 'Secondary Forward':
      return 4;
    case 'Coach':
    case 'Assistant Coach':
    case 'Goalkeeping Coach':
    case 'Forward Coach':
    case 'Caretaker Manager':
      return 5;
    default:
      return 6;
  }
}

List<List<dynamic>> getStaffPositionIcon(String position) {
  switch (position) {
    case 'Goalkeeper':
      return HugeIcons.strokeRoundedFootball;
    case 'Defence':
    case 'Left-Back':
    case 'Centre-Back':
    case 'Right-Back':
      return HugeIcons.strokeRoundedKnightShield;
    case 'Midfield':
    case 'Central Midfield':
    case 'Defensive Midfield':
    case 'Left Midfield':
    case 'Right Midfield':
    case 'Attacking Midfield':
      return HugeIcons.strokeRoundedAlignVerticalCenter;
    case 'Offence':
    case 'Centre-Forward':
    case 'Left Winger':
    case 'Right Winger':
    case 'Secondary Forward':
      return HugeIcons.strokeRoundedArrowRightDouble;
    case 'Coach':
    case 'Assistant Coach':
    case 'Goalkeeping Coach':
    case 'Forward Coach':
    case 'Caretaker Manager':
      return HugeIcons.strokeRoundedUser;
    default:
      return HugeIcons.strokeRoundedQuestion;
  }
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
