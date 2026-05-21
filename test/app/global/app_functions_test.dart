import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';
import 'package:tiki_taka_scoreboard_wearos/l10n/l10n.dart';

class MockAppLocalizations extends Mock implements AppLocalizations {}

void main() {
  group('AppFunctions', () {
    late MockAppLocalizations l10n;

    setUp(() {
      l10n = MockAppLocalizations();
      when(() => l10n.inPlayMatch).thenReturn('in play');
      when(() => l10n.pausedMatch).thenReturn('paused');
      when(() => l10n.finishedMatch).thenReturn('finished');
      when(() => l10n.postponedMatch).thenReturn('postponed');
      when(() => l10n.suspendMatch).thenReturn('suspended');
      when(() => l10n.cancelledMatch).thenReturn('cancelled');
      when(() => l10n.awardedMatch).thenReturn('awarded');
      when(() => l10n.unknownMatch).thenReturn('unknown');

      when(() => l10n.englishLanguage).thenReturn('English');
      when(() => l10n.spanishLanguage).thenReturn('Español');
      when(() => l10n.italianLanguage).thenReturn('Italiano');

      when(() => l10n.leagueCompetition).thenReturn('League');
      when(() => l10n.cupCompetition).thenReturn('Cup');
      when(() => l10n.superCupCompetition).thenReturn('Super Cup');
      when(() => l10n.friendlyCompetition).thenReturn('Friendly');
      when(() => l10n.otherCompetition).thenReturn('Other');

      when(() => l10n.colorRed).thenReturn('Red Color');
      when(() => l10n.colorPink).thenReturn('Pink Color');

      when(() => l10n.goalkeeperPosition).thenReturn('GK');
      when(() => l10n.defencePosition).thenReturn('DF');
      when(() => l10n.midfieldPosition).thenReturn('MF');
      when(() => l10n.offencePosition).thenReturn('FW');
      when(() => l10n.leftBackPosition).thenReturn('LB');
      when(() => l10n.centralMidfieldPosition).thenReturn('CM');
      when(() => l10n.attackingMidfieldPosition).thenReturn('AM');
      when(() => l10n.centreForwardPosition).thenReturn('CF');
      when(() => l10n.leftWingerPosition).thenReturn('LW');
      when(() => l10n.centreBackPosition).thenReturn('CB');
      when(() => l10n.rightWingerPosition).thenReturn('RW');
      when(() => l10n.rightBackPosition).thenReturn('RB');
      when(() => l10n.defensiveMidfieldPosition).thenReturn('DM');
      when(() => l10n.leftMidfieldPosition).thenReturn('LM');
      when(() => l10n.rightMidfieldPosition).thenReturn('RM');
      when(() => l10n.secondaryForwardPosition).thenReturn('SS');
      when(() => l10n.coachPosition).thenReturn('Coach');
      when(() => l10n.assistantCoachPosition).thenReturn('Asst Coach');
      when(() => l10n.goalkeepingCoachPosition).thenReturn('GK Coach');
      when(() => l10n.forwardCoachPosition).thenReturn('FW Coach');
      when(() => l10n.caretakerManagerPosition).thenReturn('Caretaker');
      when(() => l10n.unknownPosition).thenReturn('Unknown Pos');
    });

    test('getMatchState returns correct strings', () {
      final date = DateTime(2023, 1, 1, 15, 30);
      expect(AppFunctions.getMatchState('SCHEDULED', date, l10n), '15:30');
      expect(AppFunctions.getMatchState('TIMED', date, l10n), '15:30');
      expect(AppFunctions.getMatchState('IN_PLAY', date, l10n), 'in play');
      expect(AppFunctions.getMatchState('PAUSED', date, l10n), 'paused');
      expect(AppFunctions.getMatchState('FINISHED', date, l10n), 'finished');
      expect(AppFunctions.getMatchState('POSTPONED', date, l10n), 'postponed');
      expect(AppFunctions.getMatchState('SUSPENDED', date, l10n), 'suspended');
      expect(AppFunctions.getMatchState('CANCELED', date, l10n), 'cancelled');
      expect(AppFunctions.getMatchState('AWARDED', date, l10n), 'awarded');
      expect(AppFunctions.getMatchState('BLAH', date, l10n), 'unknown');
    });

    test('getLanguageLabel returns correct language name', () {
      expect(
        AppFunctions.getLanguageLabel(l10n, const Locale('en', 'US')),
        'English',
      );
      expect(
        AppFunctions.getLanguageLabel(l10n, const Locale('es', 'ES')),
        'Español',
      );
      expect(
        AppFunctions.getLanguageLabel(l10n, const Locale('it', 'IT')),
        'Italiano',
      );
      expect(
        AppFunctions.getLanguageLabel(l10n, const Locale('fr', 'FR')),
        'fr',
      );
    });

    test('notMatchState returns correctly formatted match string', () {
      expect(AppFunctions.notMatchState('IN_PLAY', l10n), 'IN PLAY');
      expect(AppFunctions.notMatchState('PAUSED', l10n), 'PAUSED');
      expect(AppFunctions.notMatchState('FINISHED', l10n), 'FINISHED');
      expect(AppFunctions.notMatchState('BLAH', l10n), 'UNKNOWN');
      expect(AppFunctions.notMatchState('POSTPONED', l10n), 'POSTPONED');
      expect(AppFunctions.notMatchState('SUSPENDED', l10n), 'SUSPENDED');
      expect(AppFunctions.notMatchState('CANCELED', l10n), 'CANCELLED');
      expect(AppFunctions.notMatchState('AWARDED', l10n), 'AWARDED');
    });

    test('getTeamColors parses correctly', () {
      final colors = AppFunctions.getTeamColors('Red / White');
      expect(colors.length, 2);

      final empty = AppFunctions.getTeamColors('');
      expect(empty.length, 2);

      final single = AppFunctions.getTeamColors('Royal Blue');
      expect(single.length, 2);
    });

    test('getCompetitionType returns correct strings', () {
      expect(AppFunctions.getCompetitionType('LEAGUE', l10n), 'League');
      expect(AppFunctions.getCompetitionType('CUP', l10n), 'Cup');
      expect(AppFunctions.getCompetitionType('SUPER_CUP', l10n), 'Super Cup');
      expect(AppFunctions.getCompetitionType('FRIENDLY', l10n), 'Friendly');
      expect(AppFunctions.getCompetitionType('BLAH', l10n), 'Other');
    });

    test('getStaffPosition returns correct strings', () {
      expect(AppFunctions.getStaffPosition('Goalkeeper', l10n), 'GK');
      expect(AppFunctions.getStaffPosition('Defence', l10n), 'DF');
      expect(AppFunctions.getStaffPosition('Midfield', l10n), 'MF');
      expect(AppFunctions.getStaffPosition('Offence', l10n), 'FW');
      expect(AppFunctions.getStaffPosition('Left-Back', l10n), 'LB');
      expect(AppFunctions.getStaffPosition('Central Midfield', l10n), 'CM');
      expect(AppFunctions.getStaffPosition('Attacking Midfield', l10n), 'AM');
      expect(AppFunctions.getStaffPosition('Centre-Forward', l10n), 'CF');
      expect(AppFunctions.getStaffPosition('Left Winger', l10n), 'LW');
      expect(AppFunctions.getStaffPosition('Centre-Back', l10n), 'CB');
      expect(AppFunctions.getStaffPosition('Right Winger', l10n), 'RW');
      expect(AppFunctions.getStaffPosition('Right-Back', l10n), 'RB');
      expect(AppFunctions.getStaffPosition('Defensive Midfield', l10n), 'DM');
      expect(AppFunctions.getStaffPosition('Left Midfield', l10n), 'LM');
      expect(AppFunctions.getStaffPosition('Right Midfield', l10n), 'RM');
      expect(AppFunctions.getStaffPosition('Secondary Forward', l10n), 'SS');
      expect(AppFunctions.getStaffPosition('Coach', l10n), 'Coach');
      expect(
        AppFunctions.getStaffPosition('Assistant Coach', l10n),
        'Asst Coach',
      );
      expect(
        AppFunctions.getStaffPosition('Goalkeeping Coach', l10n),
        'GK Coach',
      );
      expect(AppFunctions.getStaffPosition('Forward Coach', l10n), 'FW Coach');
      expect(
        AppFunctions.getStaffPosition('Caretaker Manager', l10n),
        'Caretaker',
      );
      expect(AppFunctions.getStaffPosition('BLAH', l10n), 'Unknown Pos');
    });

    test('getColorName returns correct localized color', () {
      expect(AppFunctions.getColorName('RED', l10n), 'Red Color');
      expect(AppFunctions.getColorName('PINK', l10n), isNotNull);
      expect(AppFunctions.getColorName('UNKNOWN_COLOR', l10n), 'UNKNOWN_COLOR');
    });

    test('getStaffPositionColor returns relevant colors', () {
      expect(
        AppFunctions.getStaffPositionColor('Goalkeeper'),
        Colors.orange.shade600,
      );
      expect(
        AppFunctions.getStaffPositionColor('Left-Back'),
        Colors.blue.shade600,
      );
      expect(
        AppFunctions.getStaffPositionColor('Central Midfield'),
        Colors.green.shade600,
      );
      expect(
        AppFunctions.getStaffPositionColor('Centre-Forward'),
        Colors.red.shade600,
      );
      expect(
        AppFunctions.getStaffPositionColor('Coach'),
        Colors.purple.shade600,
      );
      expect(AppFunctions.getStaffPositionColor('BLAH'), Colors.grey.shade600);
    });

    test('getStaffPositionOrder returns integers', () {
      expect(AppFunctions.getStaffPositionOrder('Goalkeeper'), 1);
      expect(AppFunctions.getStaffPositionOrder('Defence'), 2);
      expect(AppFunctions.getStaffPositionOrder('Midfield'), 3);
      expect(AppFunctions.getStaffPositionOrder('Offence'), 4);
      expect(AppFunctions.getStaffPositionOrder('Coach'), 5);
      expect(AppFunctions.getStaffPositionOrder('BLAH'), 6);
    });

    test('getStaffPositionIcon returns huge icons', () {
      expect(
        AppFunctions.getStaffPositionIcon('Goalkeeper'),
        HugeIcons.strokeRoundedFootball,
      );
      expect(
        AppFunctions.getStaffPositionIcon('Defence'),
        HugeIcons.strokeRoundedKnightShield,
      );
      expect(
        AppFunctions.getStaffPositionIcon('Midfield'),
        HugeIcons.strokeRoundedAlignVerticalCenter,
      );
      expect(
        AppFunctions.getStaffPositionIcon('Offence'),
        HugeIcons.strokeRoundedArrowRightDouble,
      );
      expect(
        AppFunctions.getStaffPositionIcon('Coach'),
        HugeIcons.strokeRoundedUser,
      );
      expect(
        AppFunctions.getStaffPositionIcon('BLAH'),
        HugeIcons.strokeRoundedQuestion,
      );
    });
  });
}
