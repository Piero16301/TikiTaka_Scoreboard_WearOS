import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tiki_taka_scoreboard_wearos/app/global/functions.dart';
import 'package:tiki_taka_scoreboard_wearos/l10n/l10n.dart';

void main() {
  group('AppFunctions', () {
    late AppLocalizations l10n;

    setUp(() {
      l10n = lookupAppLocalizations(const Locale('en'));
    });

    group('getMatchState', () {
      final testDate = DateTime(2025, 10, 22, 15, 30);

      test('returns formatted time for SCHEDULED status', () {
        final result = AppFunctions.getMatchState('SCHEDULED', testDate, l10n);

        expect(result, equals('15:30'));
      });

      test('returns formatted time for TIMED status', () {
        final result = AppFunctions.getMatchState('TIMED', testDate, l10n);

        expect(result, equals('15:30'));
      });

      test('returns IN_PLAY text for IN_PLAY status', () {
        final result = AppFunctions.getMatchState('IN_PLAY', testDate, l10n);

        expect(result, equals(l10n.inPlayMatch.toUpperCase()));
      });

      test('returns PAUSED text for PAUSED status', () {
        final result = AppFunctions.getMatchState('PAUSED', testDate, l10n);

        expect(result, equals(l10n.pausedMatch.toUpperCase()));
      });

      test('returns FINISHED text for FINISHED status', () {
        final result = AppFunctions.getMatchState('FINISHED', testDate, l10n);

        expect(result, equals(l10n.finishedMatch.toUpperCase()));
      });

      test('returns POSTPONED text for POSTPONED status', () {
        final result = AppFunctions.getMatchState('POSTPONED', testDate, l10n);

        expect(result, equals(l10n.postponedMatch.toUpperCase()));
      });

      test('returns SUSPENDED text for SUSPENDED status', () {
        final result = AppFunctions.getMatchState('SUSPENDED', testDate, l10n);

        expect(result, equals(l10n.suspendMatch.toUpperCase()));
      });

      test('returns CANCELED text for CANCELED status', () {
        final result = AppFunctions.getMatchState('CANCELED', testDate, l10n);

        expect(result, equals(l10n.cancelledMatch.toUpperCase()));
      });

      test('returns AWARDED text for AWARDED status', () {
        final result = AppFunctions.getMatchState('AWARDED', testDate, l10n);

        expect(result, equals(l10n.awardedMatch.toUpperCase()));
      });

      test('returns UNKNOWN text for unknown status', () {
        final result = AppFunctions.getMatchState('UNKNOWN', testDate, l10n);

        expect(result, equals(l10n.unknownMatch.toUpperCase()));
      });

      test('handles midnight time correctly', () {
        final midnightDate = DateTime(2025, 10, 22);
        final result = AppFunctions.getMatchState(
          'SCHEDULED',
          midnightDate,
          l10n,
        );

        expect(result, equals('00:00'));
      });

      test('handles late night time correctly', () {
        final lateNightDate = DateTime(2025, 10, 22, 23, 45);
        final result = AppFunctions.getMatchState('TIMED', lateNightDate, l10n);

        expect(result, equals('23:45'));
      });
    });

    group('notMatchState', () {
      test('returns IN_PLAY text for IN_PLAY status', () {
        final result = AppFunctions.notMatchState('IN_PLAY', l10n);

        expect(result, equals(l10n.inPlayMatch.toUpperCase()));
      });

      test('returns PAUSED text for PAUSED status', () {
        final result = AppFunctions.notMatchState('PAUSED', l10n);

        expect(result, equals(l10n.pausedMatch.toUpperCase()));
      });

      test('returns FINISHED text for FINISHED status', () {
        final result = AppFunctions.notMatchState('FINISHED', l10n);

        expect(result, equals(l10n.finishedMatch.toUpperCase()));
      });

      test('returns POSTPONED text for POSTPONED status', () {
        final result = AppFunctions.notMatchState('POSTPONED', l10n);

        expect(result, equals(l10n.postponedMatch.toUpperCase()));
      });

      test('returns SUSPENDED text for SUSPENDED status', () {
        final result = AppFunctions.notMatchState('SUSPENDED', l10n);

        expect(result, equals(l10n.suspendMatch.toUpperCase()));
      });

      test('returns CANCELED text for CANCELED status', () {
        final result = AppFunctions.notMatchState('CANCELED', l10n);

        expect(result, equals(l10n.cancelledMatch.toUpperCase()));
      });

      test('returns AWARDED text for AWARDED status', () {
        final result = AppFunctions.notMatchState('AWARDED', l10n);

        expect(result, equals(l10n.awardedMatch.toUpperCase()));
      });

      test('returns UNKNOWN text for unknown status', () {
        final result = AppFunctions.notMatchState('UNKNOWN', l10n);

        expect(result, equals(l10n.unknownMatch.toUpperCase()));
      });
    });

    group('getTeamColors', () {
      test('returns two colors for single color input', () {
        final result = AppFunctions.getTeamColors('Red');

        expect(result.length, equals(2));
        expect(result[0].a, equals(0.4));
        expect(result[1].a, equals(0.4));
      });

      test('returns two colors for two color input', () {
        final result = AppFunctions.getTeamColors('Red / Blue');

        expect(result.length, equals(2));
        expect(result[0], isNot(equals(result[1])));
      });

      test('returns only two colors for three color input', () {
        final result = AppFunctions.getTeamColors('Red / Blue / Green');

        expect(result.length, equals(2));
      });

      test('returns default colors for empty input', () {
        final result = AppFunctions.getTeamColors('');

        expect(result.length, equals(2));
        expect(result[0].a, equals(0.4));
        expect(result[1].a, equals(0.4));
      });

      test('returns default colors for whitespace only input', () {
        final result = AppFunctions.getTeamColors('   ');

        expect(result.length, equals(2));
        expect(result[0].a, equals(0.4));
        expect(result[1].a, equals(0.4));
      });

      test('returns colors with alpha value 0.4', () {
        final result = AppFunctions.getTeamColors('Red / Blue');

        expect(result[0].a, equals(0.4));
        expect(result[1].a, equals(0.4));
      });

      test('handles unknown color names with default color', () {
        final result = AppFunctions.getTeamColors('UnknownColor');

        expect(result.length, equals(2));
        expect(result[0].a, equals(0.4));
      });

      test('handles mixed known and unknown colors', () {
        final result = AppFunctions.getTeamColors('Red / UnknownColor');

        expect(result.length, equals(2));
      });
    });

    group('getCompetitionType', () {
      test('returns league text for LEAGUE type', () {
        final result = AppFunctions.getCompetitionType('LEAGUE', l10n);

        expect(result, equals(l10n.leagueCompetition));
      });

      test('returns cup text for CUP type', () {
        final result = AppFunctions.getCompetitionType('CUP', l10n);

        expect(result, equals(l10n.cupCompetition));
      });

      test('returns super cup text for SUPER_CUP type', () {
        final result = AppFunctions.getCompetitionType('SUPER_CUP', l10n);

        expect(result, equals(l10n.superCupCompetition));
      });

      test('returns friendly text for FRIENDLY type', () {
        final result = AppFunctions.getCompetitionType('FRIENDLY', l10n);

        expect(result, equals(l10n.friendlyCompetition));
      });

      test('returns other text for unknown type', () {
        final result = AppFunctions.getCompetitionType('UNKNOWN', l10n);

        expect(result, equals(l10n.otherCompetition));
      });
    });

    group('getStaffPosition', () {
      test('returns goalkeeper text for Goalkeeper position', () {
        final result = AppFunctions.getStaffPosition('Goalkeeper', l10n);

        expect(result, equals(l10n.goalkeeperPosition));
      });

      test('returns defence text for Defence position', () {
        final result = AppFunctions.getStaffPosition('Defence', l10n);

        expect(result, equals(l10n.defencePosition));
      });

      test('returns midfield text for Midfield position', () {
        final result = AppFunctions.getStaffPosition('Midfield', l10n);

        expect(result, equals(l10n.midfieldPosition));
      });

      test('returns offence text for Offence position', () {
        final result = AppFunctions.getStaffPosition('Offence', l10n);

        expect(result, equals(l10n.offencePosition));
      });

      test('returns left-back text for Left-Back position', () {
        final result = AppFunctions.getStaffPosition('Left-Back', l10n);

        expect(result, equals(l10n.leftBackPosition));
      });

      test('returns central midfield text for Central Midfield position', () {
        final result = AppFunctions.getStaffPosition('Central Midfield', l10n);

        expect(result, equals(l10n.centralMidfieldPosition));
      });

      test(
        'returns attacking midfield text for Attacking Midfield position',
        () {
          final result = AppFunctions.getStaffPosition(
            'Attacking Midfield',
            l10n,
          );

          expect(result, equals(l10n.attackingMidfieldPosition));
        },
      );

      test('returns centre-forward text for Centre-Forward position', () {
        final result = AppFunctions.getStaffPosition('Centre-Forward', l10n);

        expect(result, equals(l10n.centreForwardPosition));
      });

      test('returns left winger text for Left Winger position', () {
        final result = AppFunctions.getStaffPosition('Left Winger', l10n);

        expect(result, equals(l10n.leftWingerPosition));
      });

      test('returns centre-back text for Centre-Back position', () {
        final result = AppFunctions.getStaffPosition('Centre-Back', l10n);

        expect(result, equals(l10n.centreBackPosition));
      });

      test('returns right winger text for Right Winger position', () {
        final result = AppFunctions.getStaffPosition('Right Winger', l10n);

        expect(result, equals(l10n.rightWingerPosition));
      });

      test('returns right-back text for Right-Back position', () {
        final result = AppFunctions.getStaffPosition('Right-Back', l10n);

        expect(result, equals(l10n.rightBackPosition));
      });

      test(
        'returns defensive midfield text for Defensive Midfield position',
        () {
          final result = AppFunctions.getStaffPosition(
            'Defensive Midfield',
            l10n,
          );

          expect(result, equals(l10n.defensiveMidfieldPosition));
        },
      );

      test('returns left midfield text for Left Midfield position', () {
        final result = AppFunctions.getStaffPosition('Left Midfield', l10n);

        expect(result, equals(l10n.leftMidfieldPosition));
      });

      test('returns right midfield text for Right Midfield position', () {
        final result = AppFunctions.getStaffPosition('Right Midfield', l10n);

        expect(result, equals(l10n.rightMidfieldPosition));
      });

      test('returns secondary forward text for Secondary Forward position', () {
        final result = AppFunctions.getStaffPosition('Secondary Forward', l10n);

        expect(result, equals(l10n.secondaryForwardPosition));
      });

      test('returns coach text for Coach position', () {
        final result = AppFunctions.getStaffPosition('Coach', l10n);

        expect(result, equals(l10n.coachPosition));
      });

      test('returns assistant coach text for Assistant Coach position', () {
        final result = AppFunctions.getStaffPosition('Assistant Coach', l10n);

        expect(result, equals(l10n.assistantCoachPosition));
      });

      test('returns goalkeeping coach text for Goalkeeping Coach position', () {
        final result = AppFunctions.getStaffPosition('Goalkeeping Coach', l10n);

        expect(result, equals(l10n.goalkeepingCoachPosition));
      });

      test('returns forward coach text for Forward Coach position', () {
        final result = AppFunctions.getStaffPosition('Forward Coach', l10n);

        expect(result, equals(l10n.forwardCoachPosition));
      });

      test('returns caretaker manager text for Caretaker Manager position', () {
        final result = AppFunctions.getStaffPosition('Caretaker Manager', l10n);

        expect(result, equals(l10n.caretakerManagerPosition));
      });

      test('returns unknown text for unknown position', () {
        final result = AppFunctions.getStaffPosition('Unknown', l10n);

        expect(result, equals(l10n.unknownPosition));
      });
    });

    group('getColorName', () {
      test('returns red text for RED color', () {
        final result = AppFunctions.getColorName('RED', l10n);

        expect(result, equals(l10n.colorRed));
      });

      test('returns pink text for PINK color', () {
        final result = AppFunctions.getColorName('PINK', l10n);

        expect(result, equals(l10n.colorPink));
      });

      test('returns purple text for PURPLE color', () {
        final result = AppFunctions.getColorName('PURPLE', l10n);

        expect(result, equals(l10n.colorPurple));
      });

      test('returns deep purple text for DEEP_PURPLE color', () {
        final result = AppFunctions.getColorName('DEEP_PURPLE', l10n);

        expect(result, equals(l10n.colorDeepPurple));
      });

      test('returns indigo text for INDIGO color', () {
        final result = AppFunctions.getColorName('INDIGO', l10n);

        expect(result, equals(l10n.colorIndigo));
      });

      test('returns blue text for BLUE color', () {
        final result = AppFunctions.getColorName('BLUE', l10n);

        expect(result, equals(l10n.colorBlue));
      });

      test('returns light blue text for LIGHT_BLUE color', () {
        final result = AppFunctions.getColorName('LIGHT_BLUE', l10n);

        expect(result, equals(l10n.colorLightBlue));
      });

      test('returns cyan text for CYAN color', () {
        final result = AppFunctions.getColorName('CYAN', l10n);

        expect(result, equals(l10n.colorCyan));
      });

      test('returns teal text for TEAL color', () {
        final result = AppFunctions.getColorName('TEAL', l10n);

        expect(result, equals(l10n.colorTeal));
      });

      test('returns green text for GREEN color', () {
        final result = AppFunctions.getColorName('GREEN', l10n);

        expect(result, equals(l10n.colorGreen));
      });

      test('returns light green text for LIGHT_GREEN color', () {
        final result = AppFunctions.getColorName('LIGHT_GREEN', l10n);

        expect(result, equals(l10n.colorLightGreen));
      });

      test('returns lime text for LIME color', () {
        final result = AppFunctions.getColorName('LIME', l10n);

        expect(result, equals(l10n.colorLime));
      });

      test('returns yellow text for YELLOW color', () {
        final result = AppFunctions.getColorName('YELLOW', l10n);

        expect(result, equals(l10n.colorYellow));
      });

      test('returns amber text for AMBER color', () {
        final result = AppFunctions.getColorName('AMBER', l10n);

        expect(result, equals(l10n.colorAmber));
      });

      test('returns orange text for ORANGE color', () {
        final result = AppFunctions.getColorName('ORANGE', l10n);

        expect(result, equals(l10n.colorOrange));
      });

      test('returns deep orange text for DEEP_ORANGE color', () {
        final result = AppFunctions.getColorName('DEEP_ORANGE', l10n);

        expect(result, equals(l10n.colorDeepOrange));
      });

      test('returns brown text for BROWN color', () {
        final result = AppFunctions.getColorName('BROWN', l10n);

        expect(result, equals(l10n.colorBrown));
      });

      test('returns grey text for GREY color', () {
        final result = AppFunctions.getColorName('GREY', l10n);

        expect(result, equals(l10n.colorGrey));
      });

      test('returns blue grey text for BLUE_GREY color', () {
        final result = AppFunctions.getColorName('BLUE_GREY', l10n);

        expect(result, equals(l10n.colorBlueGrey));
      });

      test('returns original color name for unknown color', () {
        final result = AppFunctions.getColorName('UNKNOWN_COLOR', l10n);

        expect(result, equals('UNKNOWN_COLOR'));
      });
    });

    group('getStaffPositionColor', () {
      test('returns orange for Goalkeeper position', () {
        final result = AppFunctions.getStaffPositionColor('Goalkeeper');

        expect(result, equals(Colors.orange.shade600));
      });

      test('returns blue for Defence position', () {
        final result = AppFunctions.getStaffPositionColor('Defence');

        expect(result, equals(Colors.blue.shade600));
      });

      test('returns blue for Left-Back position', () {
        final result = AppFunctions.getStaffPositionColor('Left-Back');

        expect(result, equals(Colors.blue.shade600));
      });

      test('returns blue for Centre-Back position', () {
        final result = AppFunctions.getStaffPositionColor('Centre-Back');

        expect(result, equals(Colors.blue.shade600));
      });

      test('returns blue for Right-Back position', () {
        final result = AppFunctions.getStaffPositionColor('Right-Back');

        expect(result, equals(Colors.blue.shade600));
      });

      test('returns green for Midfield position', () {
        final result = AppFunctions.getStaffPositionColor('Midfield');

        expect(result, equals(Colors.green.shade600));
      });

      test('returns green for Central Midfield position', () {
        final result = AppFunctions.getStaffPositionColor('Central Midfield');

        expect(result, equals(Colors.green.shade600));
      });

      test('returns green for Defensive Midfield position', () {
        final result = AppFunctions.getStaffPositionColor('Defensive Midfield');

        expect(result, equals(Colors.green.shade600));
      });

      test('returns green for Left Midfield position', () {
        final result = AppFunctions.getStaffPositionColor('Left Midfield');

        expect(result, equals(Colors.green.shade600));
      });

      test('returns green for Right Midfield position', () {
        final result = AppFunctions.getStaffPositionColor('Right Midfield');

        expect(result, equals(Colors.green.shade600));
      });

      test('returns green for Attacking Midfield position', () {
        final result = AppFunctions.getStaffPositionColor('Attacking Midfield');

        expect(result, equals(Colors.green.shade600));
      });

      test('returns red for Offence position', () {
        final result = AppFunctions.getStaffPositionColor('Offence');

        expect(result, equals(Colors.red.shade600));
      });

      test('returns red for Centre-Forward position', () {
        final result = AppFunctions.getStaffPositionColor('Centre-Forward');

        expect(result, equals(Colors.red.shade600));
      });

      test('returns red for Left Winger position', () {
        final result = AppFunctions.getStaffPositionColor('Left Winger');

        expect(result, equals(Colors.red.shade600));
      });

      test('returns red for Right Winger position', () {
        final result = AppFunctions.getStaffPositionColor('Right Winger');

        expect(result, equals(Colors.red.shade600));
      });

      test('returns red for Secondary Forward position', () {
        final result = AppFunctions.getStaffPositionColor('Secondary Forward');

        expect(result, equals(Colors.red.shade600));
      });

      test('returns purple for Coach position', () {
        final result = AppFunctions.getStaffPositionColor('Coach');

        expect(result, equals(Colors.purple.shade600));
      });

      test('returns purple for Assistant Coach position', () {
        final result = AppFunctions.getStaffPositionColor('Assistant Coach');

        expect(result, equals(Colors.purple.shade600));
      });

      test('returns purple for Goalkeeping Coach position', () {
        final result = AppFunctions.getStaffPositionColor('Goalkeeping Coach');

        expect(result, equals(Colors.purple.shade600));
      });

      test('returns purple for Forward Coach position', () {
        final result = AppFunctions.getStaffPositionColor('Forward Coach');

        expect(result, equals(Colors.purple.shade600));
      });

      test('returns purple for Caretaker Manager position', () {
        final result = AppFunctions.getStaffPositionColor('Caretaker Manager');

        expect(result, equals(Colors.purple.shade600));
      });

      test('returns grey for unknown position', () {
        final result = AppFunctions.getStaffPositionColor('Unknown');

        expect(result, equals(Colors.grey.shade600));
      });
    });

    group('getStaffPositionOrder', () {
      test('returns 1 for Goalkeeper position', () {
        final result = AppFunctions.getStaffPositionOrder('Goalkeeper');

        expect(result, equals(1));
      });

      test('returns 2 for defensive positions', () {
        expect(AppFunctions.getStaffPositionOrder('Defence'), equals(2));
        expect(AppFunctions.getStaffPositionOrder('Left-Back'), equals(2));
        expect(AppFunctions.getStaffPositionOrder('Centre-Back'), equals(2));
        expect(AppFunctions.getStaffPositionOrder('Right-Back'), equals(2));
      });

      test('returns 3 for midfield positions', () {
        expect(AppFunctions.getStaffPositionOrder('Midfield'), equals(3));
        expect(
          AppFunctions.getStaffPositionOrder('Central Midfield'),
          equals(3),
        );
        expect(
          AppFunctions.getStaffPositionOrder('Defensive Midfield'),
          equals(3),
        );
        expect(
          AppFunctions.getStaffPositionOrder('Left Midfield'),
          equals(3),
        );
        expect(
          AppFunctions.getStaffPositionOrder('Right Midfield'),
          equals(3),
        );
        expect(
          AppFunctions.getStaffPositionOrder('Attacking Midfield'),
          equals(3),
        );
      });

      test('returns 4 for offensive positions', () {
        expect(AppFunctions.getStaffPositionOrder('Offence'), equals(4));
        expect(
          AppFunctions.getStaffPositionOrder('Centre-Forward'),
          equals(4),
        );
        expect(AppFunctions.getStaffPositionOrder('Left Winger'), equals(4));
        expect(AppFunctions.getStaffPositionOrder('Right Winger'), equals(4));
        expect(
          AppFunctions.getStaffPositionOrder('Secondary Forward'),
          equals(4),
        );
      });

      test('returns 5 for technical staff positions', () {
        expect(AppFunctions.getStaffPositionOrder('Coach'), equals(5));
        expect(
          AppFunctions.getStaffPositionOrder('Assistant Coach'),
          equals(5),
        );
        expect(
          AppFunctions.getStaffPositionOrder('Goalkeeping Coach'),
          equals(5),
        );
        expect(
          AppFunctions.getStaffPositionOrder('Forward Coach'),
          equals(5),
        );
        expect(
          AppFunctions.getStaffPositionOrder('Caretaker Manager'),
          equals(5),
        );
      });

      test('returns 6 for unknown position', () {
        final result = AppFunctions.getStaffPositionOrder('Unknown');

        expect(result, equals(6));
      });
    });

    group('getStaffPositionIcon', () {
      test('returns football icon for Goalkeeper position', () {
        final result = AppFunctions.getStaffPositionIcon('Goalkeeper');

        expect(result, isA<List<List<dynamic>>>());
        expect(result, isNotEmpty);
      });

      test('returns knight shield icon for defensive positions', () {
        final defenceIcon = AppFunctions.getStaffPositionIcon('Defence');
        final leftBackIcon = AppFunctions.getStaffPositionIcon('Left-Back');
        final centreBackIcon = AppFunctions.getStaffPositionIcon('Centre-Back');
        final rightBackIcon = AppFunctions.getStaffPositionIcon('Right-Back');

        expect(defenceIcon, equals(leftBackIcon));
        expect(defenceIcon, equals(centreBackIcon));
        expect(defenceIcon, equals(rightBackIcon));
      });

      test('returns align vertical center icon for midfield positions', () {
        final midfieldIcon = AppFunctions.getStaffPositionIcon('Midfield');
        final centralIcon = AppFunctions.getStaffPositionIcon(
          'Central Midfield',
        );

        expect(midfieldIcon, equals(centralIcon));
      });

      test('returns arrow right double icon for offensive positions', () {
        final offenceIcon = AppFunctions.getStaffPositionIcon('Offence');
        final forwardIcon = AppFunctions.getStaffPositionIcon('Centre-Forward');

        expect(offenceIcon, equals(forwardIcon));
      });

      test('returns user icon for technical staff positions', () {
        final coachIcon = AppFunctions.getStaffPositionIcon('Coach');
        final assistantIcon = AppFunctions.getStaffPositionIcon(
          'Assistant Coach',
        );

        expect(coachIcon, equals(assistantIcon));
      });

      test('returns question icon for unknown position', () {
        final result = AppFunctions.getStaffPositionIcon('Unknown');

        expect(result, isA<List<List<dynamic>>>());
        expect(result, isNotEmpty);
      });
    });
  });
}
