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
      when(() => l10n.frenchLanguage).thenReturn('French');
      when(() => l10n.germanLanguage).thenReturn('German');
      when(() => l10n.portugueseLanguage).thenReturn('Portuguese');

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
        'French',
      );
      expect(
        AppFunctions.getLanguageLabel(l10n, const Locale('de', 'DE')),
        'German',
      );
      expect(
        AppFunctions.getLanguageLabel(l10n, const Locale('pt', 'BR')),
        'Portuguese',
      );
      expect(
        AppFunctions.getLanguageLabel(l10n, const Locale('zh', 'CN')),
        'zh',
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
      when(() => l10n.colorRed).thenReturn('Red');
      when(() => l10n.colorPink).thenReturn('Pink');
      when(() => l10n.colorPurple).thenReturn('Purple');
      when(() => l10n.colorDeepPurple).thenReturn('Deep Purple');
      when(() => l10n.colorIndigo).thenReturn('Indigo');
      when(() => l10n.colorBlue).thenReturn('Blue');
      when(() => l10n.colorLightBlue).thenReturn('Light Blue');
      when(() => l10n.colorCyan).thenReturn('Cyan');
      when(() => l10n.colorTeal).thenReturn('Teal');
      when(() => l10n.colorGreen).thenReturn('Green');
      when(() => l10n.colorLightGreen).thenReturn('Light Green');
      when(() => l10n.colorLime).thenReturn('Lime');
      when(() => l10n.colorYellow).thenReturn('Yellow');
      when(() => l10n.colorAmber).thenReturn('Amber');
      when(() => l10n.colorOrange).thenReturn('Orange');
      when(() => l10n.colorDeepOrange).thenReturn('Deep Orange');
      when(() => l10n.colorBrown).thenReturn('Brown');
      when(() => l10n.colorGrey).thenReturn('Grey');
      when(() => l10n.colorBlueGrey).thenReturn('Blue Grey');

      expect(AppFunctions.getColorName('RED', l10n), 'Red');
      expect(AppFunctions.getColorName('PINK', l10n), 'Pink');
      expect(AppFunctions.getColorName('PURPLE', l10n), 'Purple');
      expect(AppFunctions.getColorName('DEEP_PURPLE', l10n), 'Deep Purple');
      expect(AppFunctions.getColorName('INDIGO', l10n), 'Indigo');
      expect(AppFunctions.getColorName('BLUE', l10n), 'Blue');
      expect(AppFunctions.getColorName('LIGHT_BLUE', l10n), 'Light Blue');
      expect(AppFunctions.getColorName('CYAN', l10n), 'Cyan');
      expect(AppFunctions.getColorName('TEAL', l10n), 'Teal');
      expect(AppFunctions.getColorName('GREEN', l10n), 'Green');
      expect(AppFunctions.getColorName('LIGHT_GREEN', l10n), 'Light Green');
      expect(AppFunctions.getColorName('LIME', l10n), 'Lime');
      expect(AppFunctions.getColorName('YELLOW', l10n), 'Yellow');
      expect(AppFunctions.getColorName('AMBER', l10n), 'Amber');
      expect(AppFunctions.getColorName('ORANGE', l10n), 'Orange');
      expect(AppFunctions.getColorName('DEEP_ORANGE', l10n), 'Deep Orange');
      expect(AppFunctions.getColorName('BROWN', l10n), 'Brown');
      expect(AppFunctions.getColorName('GREY', l10n), 'Grey');
      expect(AppFunctions.getColorName('BLUE_GREY', l10n), 'Blue Grey');

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

    test(
      'getTeamTranslatedName returns correct translated name or original',
      () {
        when(() => l10n.teamBosniaHerzegovina).thenReturn('Bosnia-Herzegovina');
        when(() => l10n.teamPanama).thenReturn('Panama');
        when(() => l10n.teamCapeVerdeIslands).thenReturn('Cape Verde Islands');
        when(() => l10n.teamCongoDR).thenReturn('Congo DR');
        when(() => l10n.teamIvoryCoast).thenReturn('Ivory Coast');
        when(() => l10n.teamUruguay).thenReturn('Uruguay');
        when(() => l10n.teamGermany).thenReturn('Germany');
        when(() => l10n.teamSpain).thenReturn('España');
        when(() => l10n.teamParaguay).thenReturn('Paraguay');
        when(() => l10n.teamArgentina).thenReturn('Argentina');
        when(() => l10n.teamGhana).thenReturn('Ghana');
        when(() => l10n.teamBrazil).thenReturn('Brasil');
        when(() => l10n.teamPortugal).thenReturn('Portugal');
        when(() => l10n.teamJapan).thenReturn('Japan');
        when(() => l10n.teamMexico).thenReturn('Mexico');
        when(() => l10n.teamEngland).thenReturn('England');
        when(() => l10n.teamUnitedStates).thenReturn('United States');
        when(() => l10n.teamSouthKorea).thenReturn('South Korea');
        when(() => l10n.teamFrance).thenReturn('France');
        when(() => l10n.teamSouthAfrica).thenReturn('South Africa');
        when(() => l10n.teamAlgeria).thenReturn('Algeria');
        when(() => l10n.teamAustralia).thenReturn('Australia');
        when(() => l10n.teamNewZealand).thenReturn('New Zealand');
        when(() => l10n.teamSwitzerland).thenReturn('Switzerland');
        when(() => l10n.teamEcuador).thenReturn('Ecuador');
        when(() => l10n.teamSweden).thenReturn('Sweden');
        when(() => l10n.teamCzechia).thenReturn('Czechia');
        when(() => l10n.teamCroatia).thenReturn('Croatia');
        when(() => l10n.teamSaudiArabia).thenReturn('Saudi Arabia');
        when(() => l10n.teamTunisia).thenReturn('Tunisia');
        when(() => l10n.teamTurkey).thenReturn('Turkey');
        when(() => l10n.teamQatar).thenReturn('Qatar');
        when(() => l10n.teamSenegal).thenReturn('Senegal');
        when(() => l10n.teamJordan).thenReturn('Jordan');
        when(() => l10n.teamBelgium).thenReturn('Belgium');
        when(() => l10n.teamIraq).thenReturn('Iraq');
        when(() => l10n.teamUzbekistan).thenReturn('Uzbekistan');
        when(() => l10n.teamMorocco).thenReturn('Morocco');
        when(() => l10n.teamAustria).thenReturn('Austria');
        when(() => l10n.teamColombia).thenReturn('Colombia');
        when(() => l10n.teamEgypt).thenReturn('Egypt');
        when(() => l10n.teamCanada).thenReturn('Canada');
        when(() => l10n.teamHaiti).thenReturn('Haiti');
        when(() => l10n.teamIran).thenReturn('Iran');
        when(() => l10n.teamNetherlands).thenReturn('Netherlands');
        when(() => l10n.teamNorway).thenReturn('Norway');
        when(() => l10n.teamScotland).thenReturn('Scotland');
        when(() => l10n.teamCuracao).thenReturn('Curaçao');

        final teams = {
          'Bosnia-Herzegovina': 'Bosnia-Herzegovina',
          'Panama': 'Panama',
          'Cape Verde Islands': 'Cape Verde Islands',
          'Congo DR': 'Congo DR',
          'Ivory Coast': 'Ivory Coast',
          'Uruguay': 'Uruguay',
          'Germany': 'Germany',
          'Spain': 'España',
          'Paraguay': 'Paraguay',
          'Argentina': 'Argentina',
          'Ghana': 'Ghana',
          'Brazil': 'Brasil',
          'Portugal': 'Portugal',
          'Japan': 'Japan',
          'Mexico': 'Mexico',
          'England': 'England',
          'United States': 'United States',
          'South Korea': 'South Korea',
          'France': 'France',
          'South Africa': 'South Africa',
          'Algeria': 'Algeria',
          'Australia': 'Australia',
          'New Zealand': 'New Zealand',
          'Switzerland': 'Switzerland',
          'Ecuador': 'Ecuador',
          'Sweden': 'Sweden',
          'Czechia': 'Czechia',
          'Croatia': 'Croatia',
          'Saudi Arabia': 'Saudi Arabia',
          'Tunisia': 'Tunisia',
          'Turkey': 'Turkey',
          'Qatar': 'Qatar',
          'Senegal': 'Senegal',
          'Jordan': 'Jordan',
          'Belgium': 'Belgium',
          'Iraq': 'Iraq',
          'Uzbekistan': 'Uzbekistan',
          'Morocco': 'Morocco',
          'Austria': 'Austria',
          'Colombia': 'Colombia',
          'Egypt': 'Egypt',
          'Canada': 'Canada',
          'Haiti': 'Haiti',
          'Iran': 'Iran',
          'Netherlands': 'Netherlands',
          'Norway': 'Norway',
          'Scotland': 'Scotland',
          'Curaçao': 'Curaçao',
        };

        for (final entry in teams.entries) {
          expect(
            AppFunctions.getTeamTranslatedName(entry.key, l10n),
            entry.value,
          );
        }

        expect(
          AppFunctions.getTeamTranslatedName('Unknown Team', l10n),
          'Unknown Team',
        );
      },
    );
  });
}
