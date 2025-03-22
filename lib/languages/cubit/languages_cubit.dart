import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'languages_state.dart';

class LanguagesCubit extends Cubit<LanguagesState> {
  LanguagesCubit() : super(const LanguagesState());
}
