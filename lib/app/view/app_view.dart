import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiki_taka_scoreboard_wearos/ambient_mode/ambient_mode.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';
import 'package:tiki_taka_scoreboard_wearos/home/home.dart';
import 'package:tiki_taka_scoreboard_wearos/l10n/l10n.dart';

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  @override
  void initState() {
    unawaited(context.read<AppCubit>().initialLoad());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) => AmbientModeBuilder(
        child: const HomePage(),
        builder: (context, isAmbientModeActive, child) {
          return MaterialApp(
            title: 'Tiki Taka',
            navigatorKey: navigatorKey,
            theme: appLightTheme(isAmbientModeActive: isAmbientModeActive),
            darkTheme: appDarkTheme(isAmbientModeActive: isAmbientModeActive),
            themeMode: state.darkMode ? ThemeMode.dark : ThemeMode.light,
            themeAnimationCurve: Curves.easeInOut,
            themeAnimationDuration: const Duration(milliseconds: 500),
            locale: Locale(
              state.language.split('_').first,
              state.language.split('_').last,
            ),
            debugShowCheckedModeBanner: false,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            routes: AppRoutes.routes,
          );
        },
      ),
    );
  }
}
