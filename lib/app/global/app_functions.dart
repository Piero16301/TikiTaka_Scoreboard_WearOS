import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';
import 'package:tiki_taka_scoreboard_wearos/l10n/l10n.dart';

class AppFunctions {
  static String getMatchState(
    String status,
    DateTime date,
    AppLocalizations l10n,
  ) {
    switch (status) {
      case 'SCHEDULED':
        return DateFormat('HH:mm').format(date);
      case 'TIMED':
        return DateFormat('HH:mm').format(date);
      case 'LIVE':
      case 'IN_PLAY':
        return l10n.inPlayMatch;
      case 'PAUSED':
        return l10n.pausedMatch;
      case 'FINISHED':
        return l10n.finishedMatch;
      case 'POSTPONED':
        return l10n.postponedMatch;
      case 'SUSPENDED':
        return l10n.suspendMatch;
      case 'CANCELED':
        return l10n.cancelledMatch;
      case 'AWARDED':
        return l10n.awardedMatch;
      default:
        return l10n.unknownMatch;
    }
  }

  static String getLanguageLabel(AppLocalizations l10n, Locale language) {
    switch (language.languageCode) {
      case 'en':
        return l10n.englishLanguage;
      case 'es':
        return l10n.spanishLanguage;
      case 'it':
        return l10n.italianLanguage;
      case 'fr':
        return l10n.frenchLanguage;
      case 'de':
        return l10n.germanLanguage;
      case 'pt':
        return l10n.portugueseLanguage;
      default:
        return language.languageCode;
    }
  }

  static String notMatchState(String status, AppLocalizations l10n) {
    switch (status) {
      case 'LIVE':
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

  static List<Color> getTeamColors(String colors) {
    final list = colors.split(' / ');
    final colorIcons = <Color>[];
    for (final color in list) {
      if (color.trim().isNotEmpty) {
        colorIcons.add(
          AppVariables.teamColorsMap[color] ?? AppVariables.defaultColor,
        );
      }
    }

    if (colorIcons.isEmpty) {
      colorIcons
        ..add(Colors.black)
        ..add(Colors.white);
    } else if (colorIcons.length == 1) {
      colorIcons.add(colorIcons.first);
    }

    return colorIcons.map((color) {
      return color.withValues(alpha: 0.5);
    }).toList();
  }

  static String getCompetitionType(String type, AppLocalizations l10n) {
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

  static String getStaffPosition(String position, AppLocalizations l10n) {
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

  static String getColorName(String colorName, AppLocalizations l10n) {
    switch (colorName) {
      case 'RED':
        return l10n.colorRed;
      case 'PINK':
        return l10n.colorPink;
      case 'PURPLE':
        return l10n.colorPurple;
      case 'DEEP_PURPLE':
        return l10n.colorDeepPurple;
      case 'INDIGO':
        return l10n.colorIndigo;
      case 'BLUE':
        return l10n.colorBlue;
      case 'LIGHT_BLUE':
        return l10n.colorLightBlue;
      case 'CYAN':
        return l10n.colorCyan;
      case 'TEAL':
        return l10n.colorTeal;
      case 'GREEN':
        return l10n.colorGreen;
      case 'LIGHT_GREEN':
        return l10n.colorLightGreen;
      case 'LIME':
        return l10n.colorLime;
      case 'YELLOW':
        return l10n.colorYellow;
      case 'AMBER':
        return l10n.colorAmber;
      case 'ORANGE':
        return l10n.colorOrange;
      case 'DEEP_ORANGE':
        return l10n.colorDeepOrange;
      case 'BROWN':
        return l10n.colorBrown;
      case 'GREY':
        return l10n.colorGrey;
      case 'BLUE_GREY':
        return l10n.colorBlueGrey;
      default:
        return colorName;
    }
  }

  static Color getStaffPositionColor(String position) {
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

  static int getStaffPositionOrder(String position) {
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

  static List<List<dynamic>> getStaffPositionIcon(String position) {
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

  static String getTeamTranslatedName(String name, AppLocalizations l10n) {
    switch (name) {
      case 'Bosnia-Herzegovina':
        return l10n.teamBosniaHerzegovina;
      case 'Panama':
        return l10n.teamPanama;
      case 'Cape Verde Islands':
        return l10n.teamCapeVerdeIslands;
      case 'Congo DR':
        return l10n.teamCongoDR;
      case 'Ivory Coast':
        return l10n.teamIvoryCoast;
      case 'Uruguay':
        return l10n.teamUruguay;
      case 'Germany':
        return l10n.teamGermany;
      case 'Spain':
        return l10n.teamSpain;
      case 'Paraguay':
        return l10n.teamParaguay;
      case 'Argentina':
        return l10n.teamArgentina;
      case 'Ghana':
        return l10n.teamGhana;
      case 'Brazil':
        return l10n.teamBrazil;
      case 'Portugal':
        return l10n.teamPortugal;
      case 'Japan':
        return l10n.teamJapan;
      case 'Mexico':
        return l10n.teamMexico;
      case 'England':
        return l10n.teamEngland;
      case 'United States':
        return l10n.teamUnitedStates;
      case 'South Korea':
        return l10n.teamSouthKorea;
      case 'France':
        return l10n.teamFrance;
      case 'South Africa':
        return l10n.teamSouthAfrica;
      case 'Algeria':
        return l10n.teamAlgeria;
      case 'Australia':
        return l10n.teamAustralia;
      case 'New Zealand':
        return l10n.teamNewZealand;
      case 'Switzerland':
        return l10n.teamSwitzerland;
      case 'Ecuador':
        return l10n.teamEcuador;
      case 'Sweden':
        return l10n.teamSweden;
      case 'Czechia':
        return l10n.teamCzechia;
      case 'Croatia':
        return l10n.teamCroatia;
      case 'Saudi Arabia':
        return l10n.teamSaudiArabia;
      case 'Tunisia':
        return l10n.teamTunisia;
      case 'Turkey':
        return l10n.teamTurkey;
      case 'Qatar':
        return l10n.teamQatar;
      case 'Senegal':
        return l10n.teamSenegal;
      case 'Jordan':
        return l10n.teamJordan;
      case 'Belgium':
        return l10n.teamBelgium;
      case 'Iraq':
        return l10n.teamIraq;
      case 'Uzbekistan':
        return l10n.teamUzbekistan;
      case 'Morocco':
        return l10n.teamMorocco;
      case 'Austria':
        return l10n.teamAustria;
      case 'Colombia':
        return l10n.teamColombia;
      case 'Egypt':
        return l10n.teamEgypt;
      case 'Canada':
        return l10n.teamCanada;
      case 'Haiti':
        return l10n.teamHaiti;
      case 'Iran':
        return l10n.teamIran;
      case 'Netherlands':
        return l10n.teamNetherlands;
      case 'Norway':
        return l10n.teamNorway;
      case 'Scotland':
        return l10n.teamScotland;
      case 'Curaçao':
        return l10n.teamCuracao;
      default:
        return name;
    }
  }
}
