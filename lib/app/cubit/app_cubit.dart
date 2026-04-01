import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(const AppState());

  final LocalStorageService localStorage = getIt<LocalStorageService>();
  final DatabaseService database = getIt<DatabaseService>();
  final NotificationService notification = getIt<NotificationService>();

  void initialize() {
    final performance = getIt<PerformanceService>();
    final trace = performance.startTrace('app_cubit_initialization');
    // Setting the language to the device language if it's not set
    final language = localStorage.getLanguage();
    if (language == null) {
      final deviceLanguage = AppVariables.supportedLocales.first;
      localStorage.saveLanguage(language: deviceLanguage);
    }

    // Setting the base color to GREEN if it's not set
    final baseColor = localStorage.getBaseColor();
    if (baseColor == null) {
      localStorage.saveBaseColor(baseColor: AppVariables.defaultBaseColor);
    }

    // Setting the font family to Popping if it's not set
    var fontFamily = localStorage.getFontFamily();
    final isFontSupported = fontFamily != null &&
        AppVariables.availableFonts.containsValue(fontFamily);

    if (!isFontSupported) {
      final defaultFont =
          AppVariables.availableFonts[AppVariables.defaultFontFamily] ??
              AppVariables.defaultFontFamily;
      localStorage.saveFontFamily(fontFamily: defaultFont);
      fontFamily = defaultFont;
    }

    // Emit state with all loaded configurations at once
    emit(
      state.copyWith(
        language: localStorage.getLanguage(),
        baseColor: localStorage.getBaseColor(),
        fontFamily: localStorage.getFontFamily(),
      ),
    );
    performance.stopTrace(trace);
  }

  void changeLanguage({required Locale language}) {
    localStorage.saveLanguage(language: language);
    database.updateDeviceSettings(
      token: notification.token,
      language: language,
    );
    emit(state.copyWith(language: language));
  }

  void changeBaseColor({required Color baseColor}) {
    localStorage.saveBaseColor(baseColor: baseColor);
    emit(state.copyWith(baseColor: baseColor));
  }

  void changeFontFamily({required String fontFamily}) {
    localStorage.saveFontFamily(fontFamily: fontFamily);
    emit(state.copyWith(fontFamily: fontFamily));
  }
}
