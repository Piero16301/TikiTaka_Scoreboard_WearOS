import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiki_taka_scoreboard_wearos/ambient_mode/ambient_mode.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';
import 'package:tiki_taka_scoreboard_wearos/home/home.dart';
import 'package:tiki_taka_scoreboard_wearos/l10n/l10n.dart';

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) => AmbientModeBuilder(
        child: const HomePage(),
        builder: (context, isAmbientModeActive, child) {
          return MaterialApp(
            title: AppVariables.appName,
            navigatorKey: AppVariables.navigatorKey,
            theme: AppThemes.globalTheme(
              isAmbientModeActive: isAmbientModeActive,
              baseColor: state.baseColor,
              fontFamily: state.fontFamily,
            ),
            themeMode: ThemeMode.dark,
            themeAnimationCurve: Curves.easeInOut,
            themeAnimationDuration: const Duration(milliseconds: 500),
            locale: state.language,
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
