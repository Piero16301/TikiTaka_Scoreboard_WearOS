import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'themes_state.dart';

class ThemesCubit extends Cubit<ThemesState> {
  ThemesCubit() : super(const ThemesState());
}
