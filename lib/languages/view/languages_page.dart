import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiki_taka_scoreboard_wearos/languages/languages.dart';

class LanguagesPage extends StatelessWidget {
  const LanguagesPage({super.key});

  static const String routeName = '/languages';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LanguagesCubit(),
      child: LanguagesView(),
    );
  }
}
