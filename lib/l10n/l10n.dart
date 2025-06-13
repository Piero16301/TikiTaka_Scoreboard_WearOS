import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'l10n_en.dart';
import 'l10n_es.dart';
import 'l10n_it.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/l10n.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('it')
  ];

  /// No description provided for @titleMatches.
  ///
  /// In en, this message translates to:
  /// **'Matches'**
  String get titleMatches;

  /// No description provided for @updatingMatches.
  ///
  /// In en, this message translates to:
  /// **'Updating matches...'**
  String get updatingMatches;

  /// No description provided for @updatedMatches.
  ///
  /// In en, this message translates to:
  /// **'{seconds, plural, =0 {Updated now} one {Updated {seconds} second ago} other {Updated {seconds} seconds ago}}'**
  String updatedMatches(num seconds);

  /// No description provided for @emptyMatches.
  ///
  /// In en, this message translates to:
  /// **'No matches for today'**
  String get emptyMatches;

  /// No description provided for @errorMatches.
  ///
  /// In en, this message translates to:
  /// **'Error loading matches'**
  String get errorMatches;

  /// No description provided for @retryMatches.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retryMatches;

  /// No description provided for @inPlayMatch.
  ///
  /// In en, this message translates to:
  /// **'In Play'**
  String get inPlayMatch;

  /// No description provided for @pausedMatch.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get pausedMatch;

  /// No description provided for @finishedMatch.
  ///
  /// In en, this message translates to:
  /// **'Finished'**
  String get finishedMatch;

  /// No description provided for @postponedMatch.
  ///
  /// In en, this message translates to:
  /// **'Postponed'**
  String get postponedMatch;

  /// No description provided for @suspendMatch.
  ///
  /// In en, this message translates to:
  /// **'Suspended'**
  String get suspendMatch;

  /// No description provided for @cancelledMatch.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelledMatch;

  /// No description provided for @awardedMatch.
  ///
  /// In en, this message translates to:
  /// **'Awarded'**
  String get awardedMatch;

  /// No description provided for @unknownMatch.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknownMatch;

  /// No description provided for @titleMatch.
  ///
  /// In en, this message translates to:
  /// **'Match'**
  String get titleMatch;

  /// No description provided for @updatedAtMatch.
  ///
  /// In en, this message translates to:
  /// **'Updated at'**
  String get updatedAtMatch;

  /// No description provided for @halfTimeAbbr.
  ///
  /// In en, this message translates to:
  /// **'HT'**
  String get halfTimeAbbr;

  /// No description provided for @fullTimeAbbr.
  ///
  /// In en, this message translates to:
  /// **'FT'**
  String get fullTimeAbbr;

  /// No description provided for @refereeMatch.
  ///
  /// In en, this message translates to:
  /// **'Referee'**
  String get refereeMatch;

  /// No description provided for @refereeNationalityMatch.
  ///
  /// In en, this message translates to:
  /// **'Nationality'**
  String get refereeNationalityMatch;

  /// No description provided for @competitionMatch.
  ///
  /// In en, this message translates to:
  /// **'Competition'**
  String get competitionMatch;

  /// No description provided for @seasonMatch.
  ///
  /// In en, this message translates to:
  /// **'Season'**
  String get seasonMatch;

  /// No description provided for @matchdayMatch.
  ///
  /// In en, this message translates to:
  /// **'Matchday'**
  String get matchdayMatch;

  /// No description provided for @standingsMatch.
  ///
  /// In en, this message translates to:
  /// **'Standings'**
  String get standingsMatch;

  /// No description provided for @playedGamesAbbr.
  ///
  /// In en, this message translates to:
  /// **'PL'**
  String get playedGamesAbbr;

  /// No description provided for @goalDifferenceAbbr.
  ///
  /// In en, this message translates to:
  /// **'GD'**
  String get goalDifferenceAbbr;

  /// No description provided for @pointsAbbr.
  ///
  /// In en, this message translates to:
  /// **'PT'**
  String get pointsAbbr;

  /// No description provided for @titleSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get titleSettings;

  /// No description provided for @titleLeagues.
  ///
  /// In en, this message translates to:
  /// **'Leagues'**
  String get titleLeagues;

  /// No description provided for @emptyLeagues.
  ///
  /// In en, this message translates to:
  /// **'No leagues available'**
  String get emptyLeagues;

  /// No description provided for @errorLeagues.
  ///
  /// In en, this message translates to:
  /// **'Error loading leagues'**
  String get errorLeagues;

  /// No description provided for @retryLeagues.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retryLeagues;

  /// No description provided for @titleLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get titleLanguage;

  /// No description provided for @englishFlag.
  ///
  /// In en, this message translates to:
  /// **'us'**
  String get englishFlag;

  /// No description provided for @spanishFlag.
  ///
  /// In en, this message translates to:
  /// **'es'**
  String get spanishFlag;

  /// No description provided for @italianFlag.
  ///
  /// In en, this message translates to:
  /// **'it'**
  String get italianFlag;

  /// No description provided for @englishLanguage.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get englishLanguage;

  /// No description provided for @spanishLanguage.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get spanishLanguage;

  /// No description provided for @italianLanguage.
  ///
  /// In en, this message translates to:
  /// **'Italian'**
  String get italianLanguage;

  /// No description provided for @titleTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get titleTheme;

  /// No description provided for @lightTheme.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get lightTheme;

  /// No description provided for @darkTheme.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get darkTheme;

  /// No description provided for @titleNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get titleNotifications;

  /// No description provided for @errorNotifications.
  ///
  /// In en, this message translates to:
  /// **'Error loading notifications'**
  String get errorNotifications;

  /// No description provided for @emptyNotifications.
  ///
  /// In en, this message translates to:
  /// **'No notifications available'**
  String get emptyNotifications;

  /// No description provided for @titleTeams.
  ///
  /// In en, this message translates to:
  /// **'Teams'**
  String get titleTeams;

  /// No description provided for @errorTeams.
  ///
  /// In en, this message translates to:
  /// **'Error loading teams'**
  String get errorTeams;

  /// No description provided for @emptyTeams.
  ///
  /// In en, this message translates to:
  /// **'No teams available'**
  String get emptyTeams;

  /// No description provided for @backText.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get backText;

  /// No description provided for @updatedOn.
  ///
  /// In en, this message translates to:
  /// **'Updated'**
  String get updatedOn;

  /// No description provided for @todayText.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get todayText;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'it'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'it':
      return AppLocalizationsIt();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
