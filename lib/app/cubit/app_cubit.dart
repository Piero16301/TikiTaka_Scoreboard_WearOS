import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit(this.userRepository) : super(const AppState());

  final UserRepository userRepository;

  Future<void> initialLoad() async {
    final darkMode = userRepository.getDarkMode();
    if (darkMode == null) {
      await userRepository.saveDarkMode();
    }

    final language = userRepository.getLanguage();
    if (language == null) {
      const platformLocale = 'en_US';
      await userRepository.saveLanguage(language: platformLocale);
    }

    emit(
      state.copyWith(
        darkMode: userRepository.getDarkMode(),
        language: userRepository.getLanguage(),
      ),
    );
  }

  Future<void> changeTheme({bool darkMode = true}) async {
    await userRepository.saveDarkMode(darkMode: darkMode);
    emit(state.copyWith(darkMode: darkMode));
  }

  Future<void> changeLanguage(String language) async {
    await userRepository.saveLanguage(language: language);
    emit(state.copyWith(language: language));
  }
}
