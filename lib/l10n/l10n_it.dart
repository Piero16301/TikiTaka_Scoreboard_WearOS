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
  String updatedMatches(num seconds) {
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
  String notificationTitle(String team) {
    return 'Goal per $team! ⚽';
  }

  @override
  String notificationStatus(String status) {
    return 'La partita è $status! 🥅';
  }
}
