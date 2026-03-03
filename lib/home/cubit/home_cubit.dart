import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());

  final LocalStorageService localStorage = getIt<LocalStorageService>();

  void reload({bool value = true}) {
    emit(state.copyWith(reload: value));
  }
}
