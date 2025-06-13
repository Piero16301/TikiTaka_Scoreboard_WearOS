// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get titleMatches => 'Partidos';

  @override
  String get updatingMatches => 'Actualizando partidos...';

  @override
  String updatedMatches(num seconds) {
    String _temp0 = intl.Intl.pluralLogic(
      seconds,
      locale: localeName,
      other: 'Actualizado hace $seconds segundos',
      one: 'Actualizado hace $seconds segundo',
      zero: 'Actualizado ahora',
    );
    return '$_temp0';
  }

  @override
  String get emptyMatches => 'No hay partidos para hoy';

  @override
  String get errorMatches => 'Error al cargar los partidos';

  @override
  String get retryMatches => 'Reintentar';

  @override
  String get inPlayMatch => 'En Curso';

  @override
  String get pausedMatch => 'Pausado';

  @override
  String get finishedMatch => 'Finalizado';

  @override
  String get postponedMatch => 'Aplazado';

  @override
  String get suspendMatch => 'Suspendido';

  @override
  String get cancelledMatch => 'Cancelado';

  @override
  String get awardedMatch => 'Otorgado';

  @override
  String get unknownMatch => 'Desconocido';

  @override
  String get titleMatch => 'Partido';

  @override
  String get updatedAtMatch => 'Actualizado a las';

  @override
  String get halfTimeAbbr => 'MT';

  @override
  String get fullTimeAbbr => 'FT';

  @override
  String get refereeMatch => 'Árbitro';

  @override
  String get refereeNationalityMatch => 'Nacionalidad';

  @override
  String get competitionMatch => 'Competición';

  @override
  String get seasonMatch => 'Temporada';

  @override
  String get matchdayMatch => 'Jornada';

  @override
  String get standingsMatch => 'Clasificación';

  @override
  String get playedGamesAbbr => 'PJ';

  @override
  String get goalDifferenceAbbr => 'DG';

  @override
  String get pointsAbbr => 'PT';

  @override
  String get titleSettings => 'Ajustes';

  @override
  String get titleLeagues => 'Ligas';

  @override
  String get emptyLeagues => 'No hay ligas disponibles';

  @override
  String get errorLeagues => 'Error al cargar las ligas';

  @override
  String get retryLeagues => 'Reintentar';

  @override
  String get titleLanguage => 'Idioma';

  @override
  String get englishFlag => 'us';

  @override
  String get spanishFlag => 'es';

  @override
  String get italianFlag => 'it';

  @override
  String get englishLanguage => 'Inglés';

  @override
  String get spanishLanguage => 'Español';

  @override
  String get italianLanguage => 'Italiano';

  @override
  String get titleTheme => 'Tema';

  @override
  String get lightTheme => 'Claro';

  @override
  String get darkTheme => 'Oscuro';

  @override
  String get titleNotifications => 'Notificaciones';

  @override
  String get errorNotifications => 'Error al cargar las notificaciones';

  @override
  String get emptyNotifications => 'No hay notificaciones disponibles';

  @override
  String get titleTeams => 'Equipos';

  @override
  String get errorTeams => 'Error al cargar los equipos';

  @override
  String get emptyTeams => 'No hay equipos disponibles';

  @override
  String get backText => 'Volver';

  @override
  String get updatedOn => 'Actualizado';

  @override
  String get todayText => 'Hoy';
}
