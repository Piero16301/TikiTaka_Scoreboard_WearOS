// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get titleMatches => 'Matches';

  @override
  String get updatingMatches => 'Updating matches...';

  @override
  String updatedSecondsAgo(num seconds) {
    String _temp0 = intl.Intl.pluralLogic(
      seconds,
      locale: localeName,
      other: 'Updated $seconds seconds ago',
      one: 'Updated $seconds second ago',
      zero: 'Updated now',
    );
    return '$_temp0';
  }

  @override
  String get emptyMatches => 'No matches for today';

  @override
  String get errorMatches => 'Error loading matches';

  @override
  String get retryMatches => 'Retry';

  @override
  String get inPlayMatch => 'In Play';

  @override
  String get pausedMatch => 'Paused';

  @override
  String get finishedMatch => 'Finished';

  @override
  String get postponedMatch => 'Postponed';

  @override
  String get suspendMatch => 'Suspended';

  @override
  String get cancelledMatch => 'Cancelled';

  @override
  String get awardedMatch => 'Awarded';

  @override
  String get unknownMatch => 'Unknown';

  @override
  String get titleMatch => 'Match';

  @override
  String get errorMatch => 'Error loading match';

  @override
  String get notFoundMatch => 'Match not found';

  @override
  String get updatedAtMatch => 'Updated at';

  @override
  String get halfTimeAbbr => 'HT';

  @override
  String get fullTimeAbbr => 'FT';

  @override
  String get refereeMatch => 'Referee';

  @override
  String get refereeNationalityMatch => 'Nationality';

  @override
  String get competitionMatch => 'Competition';

  @override
  String get seasonMatch => 'Season';

  @override
  String get matchdayMatch => 'Matchday';

  @override
  String get standingsMatch => 'Standings';

  @override
  String get playedGamesAbbr => 'PL';

  @override
  String get goalDifferenceAbbr => 'GD';

  @override
  String get pointsAbbr => 'PT';

  @override
  String get titleTeam => 'Team';

  @override
  String get errorTeam => 'Error loading team';

  @override
  String get notFoundTeam => 'Team not found';

  @override
  String updatedDaysAgo(num days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Updated $days days ago',
      one: 'Updated $days day ago',
      zero: 'Updated today',
    );
    return '$_temp0';
  }

  @override
  String get areaTeam => 'Area';

  @override
  String get coachTeam => 'Coach';

  @override
  String ageTeam(num age) {
    String _temp0 = intl.Intl.pluralLogic(
      age,
      locale: localeName,
      other: '$age years',
      one: '$age year',
      zero: 'Not available',
    );
    return '$_temp0';
  }

  @override
  String get untilTeam => 'Until';

  @override
  String get competitionsTeam => 'Competitions';

  @override
  String get squadTeam => 'Squad';

  @override
  String get staffTeam => 'Staff';

  @override
  String get infoTeam => 'Info';

  @override
  String get stadiumTeam => 'Stadium';

  @override
  String get foundedTeam => 'Founded';

  @override
  String get addressTeam => 'Address';

  @override
  String get websiteTeam => 'Website';

  @override
  String get titleSettings => 'Settings';

  @override
  String get titleLeagues => 'Leagues';

  @override
  String get emptyLeagues => 'No leagues available';

  @override
  String get errorLeagues => 'Error loading leagues';

  @override
  String get retryLeagues => 'Retry';

  @override
  String get titleLanguage => 'Language';

  @override
  String get englishFlag => 'us';

  @override
  String get spanishFlag => 'es';

  @override
  String get italianFlag => 'it';

  @override
  String get englishLanguage => 'English';

  @override
  String get spanishLanguage => 'Spanish';

  @override
  String get italianLanguage => 'Italian';

  @override
  String get titleTheme => 'Theme';

  @override
  String get lightTheme => 'Light';

  @override
  String get darkTheme => 'Dark';

  @override
  String get titleNotifications => 'Notifications';

  @override
  String get errorNotifications => 'Error loading notifications';

  @override
  String get emptyNotifications => 'No notifications available';

  @override
  String get titleTeams => 'Teams';

  @override
  String get errorTeams => 'Error loading teams';

  @override
  String get emptyTeams => 'No teams available';

  @override
  String get backText => 'Back';

  @override
  String get updatedOn => 'Updated';

  @override
  String get todayText => 'Today';

  @override
  String get leagueCompetition => 'League';

  @override
  String get cupCompetition => 'Cup';

  @override
  String get superCupCompetition => 'Super Cup';

  @override
  String get friendlyCompetition => 'Friendly';

  @override
  String get otherCompetition => 'Other';

  @override
  String get goalkeeperPosition => 'GK';

  @override
  String get defencePosition => 'DF';

  @override
  String get midfieldPosition => 'MF';

  @override
  String get offencePosition => 'OF';

  @override
  String get leftBackPosition => 'LB';

  @override
  String get centralMidfieldPosition => 'CM';

  @override
  String get attackingMidfieldPosition => 'AM';

  @override
  String get centreForwardPosition => 'CF';

  @override
  String get leftWingerPosition => 'LW';

  @override
  String get centreBackPosition => 'CB';

  @override
  String get rightWingerPosition => 'RW';

  @override
  String get rightBackPosition => 'RB';

  @override
  String get defensiveMidfieldPosition => 'DM';

  @override
  String get unknownPosition => 'UK';

  @override
  String get leftMidfieldPosition => 'LM';

  @override
  String get rightMidfieldPosition => 'RM';

  @override
  String get secondaryForwardPosition => 'SF';

  @override
  String get coachPosition => 'CO';

  @override
  String get assistantCoachPosition => 'AC';

  @override
  String get goalkeepingCoachPosition => 'GC';

  @override
  String get forwardCoachPosition => 'FC';

  @override
  String get caretakerManagerPosition => 'CM';
}
