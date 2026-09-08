import 'package:material_ui/material_ui.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';

class LocalStorageService {
  LocalStorageService({required this._localStorageRepository});

  final LocalStorageRepository _localStorageRepository;

  Future<void> initialize() async {
    final performance = getIt<PerformanceService>();
    final trace = performance.startTrace(
      'local_storage_service_initialization',
    );
    await _localStorageRepository.initialize();
    performance.stopTrace(trace);
  }

  void saveEnabledLeague({
    required String league,
    required bool enabled,
  }) {
    _localStorageRepository.saveEnabledLeague(league: league, enabled: enabled);
  }

  List<String>? getEnabledLeagues() {
    return _localStorageRepository.getEnabledLeagues();
  }

  void saveLanguage({required Locale language}) {
    _localStorageRepository.saveLanguage(language: language);
  }

  Locale? getLanguage() {
    return _localStorageRepository.getLanguage();
  }

  void saveBaseColor({required Color baseColor}) {
    _localStorageRepository.saveBaseColor(baseColor: baseColor);
  }

  Color? getBaseColor() {
    return _localStorageRepository.getBaseColor();
  }

  void saveFontFamily({required String fontFamily}) {
    _localStorageRepository.saveFontFamily(fontFamily: fontFamily);
  }

  String? getFontFamily() {
    return _localStorageRepository.getFontFamily();
  }
}
