import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';
import 'package:tiki_taka_scoreboard_wearos/l10n/l10n.dart';

class AppFunctions {
  static String getMatchState(
    String status,
    DateTime date,
    AppLocalizations l10n,
  ) => switch (status) {
    'SCHEDULED' || 'TIMED' => DateFormat('HH:mm').format(date),
    'LIVE' || 'IN_PLAY' => l10n.inPlayMatch,
    'PAUSED' => l10n.pausedMatch,
    'FINISHED' => l10n.finishedMatch,
    'POSTPONED' => l10n.postponedMatch,
    'SUSPENDED' => l10n.suspendMatch,
    'CANCELED' => l10n.cancelledMatch,
    'AWARDED' => l10n.awardedMatch,
    _ => l10n.unknownMatch,
  };

  static String getLanguageLabel(AppLocalizations l10n, Locale language) =>
      switch (language.languageCode) {
        'en' => l10n.englishLanguage,
        'es' => l10n.spanishLanguage,
        'it' => l10n.italianLanguage,
        'fr' => l10n.frenchLanguage,
        'de' => l10n.germanLanguage,
        'pt' => l10n.portugueseLanguage,
        _ => language.languageCode,
      };

  static String notMatchState(String status, AppLocalizations l10n) =>
      switch (status) {
        'LIVE' || 'IN_PLAY' => l10n.inPlayMatch.toUpperCase(),
        'PAUSED' => l10n.pausedMatch.toUpperCase(),
        'FINISHED' => l10n.finishedMatch.toUpperCase(),
        'POSTPONED' => l10n.postponedMatch.toUpperCase(),
        'SUSPENDED' => l10n.suspendMatch.toUpperCase(),
        'CANCELED' => l10n.cancelledMatch.toUpperCase(),
        'AWARDED' => l10n.awardedMatch.toUpperCase(),
        _ => l10n.unknownMatch.toUpperCase(),
      };

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

  static String getCompetitionType(String type, AppLocalizations l10n) =>
      switch (type) {
        'LEAGUE' => l10n.leagueCompetition,
        'CUP' => l10n.cupCompetition,
        'SUPER_CUP' => l10n.superCupCompetition,
        'FRIENDLY' => l10n.friendlyCompetition,
        _ => l10n.otherCompetition,
      };

  static String getStaffPosition(String position, AppLocalizations l10n) =>
      switch (position) {
        'Goalkeeper' => l10n.goalkeeperPosition,
        'Defence' => l10n.defencePosition,
        'Midfield' => l10n.midfieldPosition,
        'Offence' => l10n.offencePosition,
        'Left-Back' => l10n.leftBackPosition,
        'Central Midfield' => l10n.centralMidfieldPosition,
        'Attacking Midfield' => l10n.attackingMidfieldPosition,
        'Centre-Forward' => l10n.centreForwardPosition,
        'Left Winger' => l10n.leftWingerPosition,
        'Centre-Back' => l10n.centreBackPosition,
        'Right Winger' => l10n.rightWingerPosition,
        'Right-Back' => l10n.rightBackPosition,
        'Defensive Midfield' => l10n.defensiveMidfieldPosition,
        'Left Midfield' => l10n.leftMidfieldPosition,
        'Right Midfield' => l10n.rightMidfieldPosition,
        'Secondary Forward' => l10n.secondaryForwardPosition,
        'Coach' => l10n.coachPosition,
        'Assistant Coach' => l10n.assistantCoachPosition,
        'Goalkeeping Coach' => l10n.goalkeepingCoachPosition,
        'Forward Coach' => l10n.forwardCoachPosition,
        'Caretaker Manager' => l10n.caretakerManagerPosition,
        _ => l10n.unknownPosition,
      };

  static String getColorName(String colorName, AppLocalizations l10n) =>
      switch (colorName) {
        'RED' => l10n.colorRed,
        'PINK' => l10n.colorPink,
        'PURPLE' => l10n.colorPurple,
        'DEEP_PURPLE' => l10n.colorDeepPurple,
        'INDIGO' => l10n.colorIndigo,
        'BLUE' => l10n.colorBlue,
        'LIGHT_BLUE' => l10n.colorLightBlue,
        'CYAN' => l10n.colorCyan,
        'TEAL' => l10n.colorTeal,
        'GREEN' => l10n.colorGreen,
        'LIGHT_GREEN' => l10n.colorLightGreen,
        'LIME' => l10n.colorLime,
        'YELLOW' => l10n.colorYellow,
        'AMBER' => l10n.colorAmber,
        'ORANGE' => l10n.colorOrange,
        'DEEP_ORANGE' => l10n.colorDeepOrange,
        'BROWN' => l10n.colorBrown,
        'GREY' => l10n.colorGrey,
        'BLUE_GREY' => l10n.colorBlueGrey,
        _ => colorName,
      };

  static Color getStaffPositionColor(String position) => switch (position) {
    'Goalkeeper' => Colors.orange.shade600,
    'Defence' ||
    'Left-Back' ||
    'Centre-Back' ||
    'Right-Back' => Colors.blue.shade600,
    'Midfield' ||
    'Central Midfield' ||
    'Defensive Midfield' ||
    'Left Midfield' ||
    'Right Midfield' ||
    'Attacking Midfield' => Colors.green.shade600,
    'Offence' ||
    'Centre-Forward' ||
    'Left Winger' ||
    'Right Winger' ||
    'Secondary Forward' => Colors.red.shade600,
    'Coach' ||
    'Assistant Coach' ||
    'Goalkeeping Coach' ||
    'Forward Coach' ||
    'Caretaker Manager' => Colors.purple.shade600,
    _ => Colors.grey.shade600,
  };

  static int getStaffPositionOrder(String position) => switch (position) {
    'Goalkeeper' => 1,
    'Defence' || 'Left-Back' || 'Centre-Back' || 'Right-Back' => 2,
    'Midfield' ||
    'Central Midfield' ||
    'Defensive Midfield' ||
    'Left Midfield' ||
    'Right Midfield' ||
    'Attacking Midfield' => 3,
    'Offence' ||
    'Centre-Forward' ||
    'Left Winger' ||
    'Right Winger' ||
    'Secondary Forward' => 4,
    'Coach' ||
    'Assistant Coach' ||
    'Goalkeeping Coach' ||
    'Forward Coach' ||
    'Caretaker Manager' => 5,
    _ => 6,
  };

  static List<List<dynamic>> getStaffPositionIcon(String position) =>
      switch (position) {
        'Goalkeeper' => HugeIcons.strokeRoundedFootball,
        'Defence' ||
        'Left-Back' ||
        'Centre-Back' ||
        'Right-Back' => HugeIcons.strokeRoundedKnightShield,
        'Midfield' ||
        'Central Midfield' ||
        'Defensive Midfield' ||
        'Left Midfield' ||
        'Right Midfield' ||
        'Attacking Midfield' => HugeIcons.strokeRoundedAlignVerticalCenter,
        'Offence' ||
        'Centre-Forward' ||
        'Left Winger' ||
        'Right Winger' ||
        'Secondary Forward' => HugeIcons.strokeRoundedArrowRightDouble,
        'Coach' ||
        'Assistant Coach' ||
        'Goalkeeping Coach' ||
        'Forward Coach' ||
        'Caretaker Manager' => HugeIcons.strokeRoundedUser,
        _ => HugeIcons.strokeRoundedQuestion,
      };

  static String getTeamTranslatedName(String name, AppLocalizations l10n) =>
      switch (name) {
        'Bosnia-Herzegovina' => l10n.teamBosniaHerzegovina,
        'Panama' => l10n.teamPanama,
        'Cape Verde Islands' => l10n.teamCapeVerdeIslands,
        'Congo DR' => l10n.teamCongoDR,
        'Ivory Coast' => l10n.teamIvoryCoast,
        'Uruguay' => l10n.teamUruguay,
        'Germany' => l10n.teamGermany,
        'Spain' => l10n.teamSpain,
        'Paraguay' => l10n.teamParaguay,
        'Argentina' => l10n.teamArgentina,
        'Ghana' => l10n.teamGhana,
        'Brazil' => l10n.teamBrazil,
        'Portugal' => l10n.teamPortugal,
        'Japan' => l10n.teamJapan,
        'Mexico' => l10n.teamMexico,
        'England' => l10n.teamEngland,
        'United States' => l10n.teamUnitedStates,
        'South Korea' => l10n.teamSouthKorea,
        'France' => l10n.teamFrance,
        'South Africa' => l10n.teamSouthAfrica,
        'Algeria' => l10n.teamAlgeria,
        'Australia' => l10n.teamAustralia,
        'New Zealand' => l10n.teamNewZealand,
        'Switzerland' => l10n.teamSwitzerland,
        'Ecuador' => l10n.teamEcuador,
        'Sweden' => l10n.teamSweden,
        'Czechia' => l10n.teamCzechia,
        'Croatia' => l10n.teamCroatia,
        'Saudi Arabia' => l10n.teamSaudiArabia,
        'Tunisia' => l10n.teamTunisia,
        'Turkey' => l10n.teamTurkey,
        'Qatar' => l10n.teamQatar,
        'Senegal' => l10n.teamSenegal,
        'Jordan' => l10n.teamJordan,
        'Belgium' => l10n.teamBelgium,
        'Iraq' => l10n.teamIraq,
        'Uzbekistan' => l10n.teamUzbekistan,
        'Morocco' => l10n.teamMorocco,
        'Austria' => l10n.teamAustria,
        'Colombia' => l10n.teamColombia,
        'Egypt' => l10n.teamEgypt,
        'Canada' => l10n.teamCanada,
        'Haiti' => l10n.teamHaiti,
        'Iran' => l10n.teamIran,
        'Netherlands' => l10n.teamNetherlands,
        'Norway' => l10n.teamNorway,
        'Scotland' => l10n.teamScotland,
        'Curaçao' => l10n.teamCuracao,
        _ => name,
      };
}
