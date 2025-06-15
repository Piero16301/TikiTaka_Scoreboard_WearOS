// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get titleMatches => 'Partite';

  @override
  String get updatingMatches => 'Aggiornamento partite...';

  @override
  String updatedSecondsAgo(num seconds) {
    String _temp0 = intl.Intl.pluralLogic(
      seconds,
      locale: localeName,
      other: 'Aggiornato $seconds secondi fa',
      one: 'Aggiornato $seconds secondo fa',
      zero: 'Aggiornato adesso',
    );
    return '$_temp0';
  }

  @override
  String get emptyMatches => 'Nessuna partita per oggi';

  @override
  String get errorMatches => 'Errore nel caricamento delle partite';

  @override
  String get retryMatches => 'Riprova';

  @override
  String get inPlayMatch => 'In Corso';

  @override
  String get pausedMatch => 'In Pausa';

  @override
  String get finishedMatch => 'Finito';

  @override
  String get postponedMatch => 'Rinviato';

  @override
  String get suspendMatch => 'Sospeso';

  @override
  String get cancelledMatch => 'Annullato';

  @override
  String get awardedMatch => 'Assegnato';

  @override
  String get unknownMatch => 'Sconosciuto';

  @override
  String get titleMatch => 'Partita';

  @override
  String get errorMatch => 'Errore nel caricamento della partita';

  @override
  String get notFoundMatch => 'Partita non trovata';

  @override
  String get updatedAtMatch => 'Aggiornato alle';

  @override
  String get halfTimeAbbr => 'HT';

  @override
  String get fullTimeAbbr => 'FT';

  @override
  String get refereeMatch => 'Arbitro';

  @override
  String get refereeNationalityMatch => 'Nazionalità';

  @override
  String get competitionMatch => 'Competizione';

  @override
  String get seasonMatch => 'Stagione';

  @override
  String get matchdayMatch => 'Giornata';

  @override
  String get standingsMatch => 'Classifica';

  @override
  String get playedGamesAbbr => 'PG';

  @override
  String get goalDifferenceAbbr => 'DG';

  @override
  String get pointsAbbr => 'PT';

  @override
  String get titleTeam => 'Squadra';

  @override
  String get errorTeam => 'Errore nel caricamento della squadra';

  @override
  String get notFoundTeam => 'Squadra non trovata';

  @override
  String updatedDaysAgo(num days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Aggiornata $days giorni fa',
      one: 'Aggiornata $days giorno fa',
      zero: 'Aggiornata oggi',
    );
    return '$_temp0';
  }

  @override
  String get areaTeam => 'Area';

  @override
  String get coachTeam => 'Allenatore';

  @override
  String coachAgeTeam(num age) {
    return '$age anni';
  }

  @override
  String get untilTeam => 'Fino a';

  @override
  String get titleSettings => 'Impostazioni';

  @override
  String get titleLeagues => 'Leghe';

  @override
  String get emptyLeagues => 'Nessuna lega disponibile';

  @override
  String get errorLeagues => 'Errore nel caricamento delle leghe';

  @override
  String get retryLeagues => 'Riprova';

  @override
  String get titleLanguage => 'Lingua';

  @override
  String get englishFlag => 'us';

  @override
  String get spanishFlag => 'es';

  @override
  String get italianFlag => 'it';

  @override
  String get englishLanguage => 'Inglese';

  @override
  String get spanishLanguage => 'Spagnolo';

  @override
  String get italianLanguage => 'Italiano';

  @override
  String get titleTheme => 'Tema';

  @override
  String get lightTheme => 'Chiaro';

  @override
  String get darkTheme => 'Scuro';

  @override
  String get titleNotifications => 'Notifiche';

  @override
  String get errorNotifications => 'Errore nel caricamento delle notifiche';

  @override
  String get emptyNotifications => 'Nessuna notifica disponibile';

  @override
  String get titleTeams => 'Squadre';

  @override
  String get errorTeams => 'Errore nel caricamento delle squadre';

  @override
  String get emptyTeams => 'Nessuna squadra disponibile';

  @override
  String get backText => 'Indietro';

  @override
  String get updatedOn => 'Aggiornato';

  @override
  String get todayText => 'Oggi';
}
