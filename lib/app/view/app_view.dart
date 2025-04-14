import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiki_taka/ambient_mode/ambient_mode.dart';
import 'package:tiki_taka/app/app.dart';
import 'package:tiki_taka/home/home.dart';
import 'package:tiki_taka/l10n/l10n.dart';
import 'package:tiki_taka/languages/languages.dart';
import 'package:tiki_taka/leagues/leagues.dart';
import 'package:tiki_taka/match/match.dart';
import 'package:tiki_taka/settings/settings.dart';
import 'package:tiki_taka/themes/themes.dart';

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  @override
  void initState() {
    context.read<AppCubit>().initialLoad();
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
            routes: {
              HomePage.routeName: (_) => const HomePage(),
              MatchPage.routeName: (context) => MatchPage(
                    matchId:
                        ModalRoute.of(context)!.settings.arguments as int? ?? 0,
                  ),
              SettingsPage.routeName: (_) => const SettingsPage(),
              LeaguesPage.routeName: (_) => const LeaguesPage(),
              LanguagesPage.routeName: (_) => const LanguagesPage(),
              ThemesPage.routeName: (_) => const ThemesPage(),
            },
          );
        },
      ),
    );
  }
}
