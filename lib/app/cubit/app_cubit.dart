import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';
import 'package:user_repository/user_repository.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit(this.userRepository) : super(const AppState());

  final UserRepository userRepository;

  Future<void> initialLoad() async {
    // Ensure platform info is loaded before proceeding with NotificationService
    // which depends on it
    await LocalSettingsService.instance.loadPlatformInfo();

    // Initialize Notification Service in background
    await NotificationService.instance.initialize();

    final baseColor = userRepository.getBaseColor();
    if (baseColor == null) {
      await userRepository.saveBaseColor(baseColor: state.baseColor);
    }

    final language = userRepository.getLanguage();
    if (language == null) {
      await userRepository.saveLanguage(language: state.language);
    }

    emit(
      state.copyWith(
        baseColor: userRepository.getBaseColor(),
        language: userRepository.getLanguage(),
      ),
    );
  }

  Future<void> changeBaseColor(String baseColor) async {
    await userRepository.saveBaseColor(baseColor: baseColor);
    emit(state.copyWith(baseColor: baseColor));
    LocalSettingsService.instance.saveBaseColorOnFirestore(
      baseColor: baseColor,
    );
  }

  Future<void> changeLanguage(String language) async {
    await userRepository.saveLanguage(language: language);
    emit(state.copyWith(language: language));
    LocalSettingsService.instance.saveLanguageOnFirestore(language: language);
  }
}
