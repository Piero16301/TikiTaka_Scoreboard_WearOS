import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';
import 'package:tiki_taka_scoreboard_wearos/l10n/l10n.dart';
import 'package:tiki_taka_scoreboard_wearos/leagues/leagues.dart';
import 'package:wear_os_scrollbar/wear_os_scrollbar.dart';

class LeaguesView extends StatefulWidget {
  const LeaguesView({super.key});

  @override
  State<LeaguesView> createState() => _LeaguesViewState();
}

class _LeaguesViewState extends State<LeaguesView> {
  final ScrollController _scrollController = ScrollController(
    keepScrollOffset: false,
  );
  late final Stream<List<League>> _leaguesStream;

  @override
  void initState() {
    super.initState();
    _leaguesStream = getIt<DatabaseService>().getLeaguesStream();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return StreamBuilder<List<League>>(
      stream: _leaguesStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return AppScaffold.basic(
            child: AppError(text: l10n.errorLeagues),
          );
        }

        if (!snapshot.hasData) {
          return const AppScaffold.basic(
            child: AppLoader(),
          );
        }

        if (snapshot.data!.isEmpty) {
          return AppScaffold.basic(
            child: AppEmpty(text: l10n.emptyLeagues),
          );
        }

        final leagues = snapshot.data!;

        return AppScaffold.scrollable(
          controller: _scrollController,
          child: Column(
            children: [
              const SizedBox(height: AppVariables.topScaffoldSpacing),
              AppTitleText(title: l10n.titleLeagues),
              for (final (index, league) in leagues.indexed) ...[
                WearOsExpressiveItem(
                  scrollController: _scrollController,
                  child: LeagueCardCompetitions(league: league),
                ),
                if (index < leagues.length - 1)
                  const SizedBox(height: AppVariables.listSpacing),
              ],
              const SizedBox(height: AppVariables.bottomScaffoldSpacing),
            ],
          ),
        );
      },
    );
  }
}

class LeagueCardCompetitions extends StatelessWidget {
  const LeagueCardCompetitions({
    required this.league,
    super.key,
  });

  final League league;

  @override
  Widget build(BuildContext context) {
    return AppCardAction(
      innerPadding: EdgeInsets.zero,
      onPressed: () {
        getIt<AnalyticsService>().logEvent(
          name: 'league_toggled',
          parameters: {'league': league.code},
        );
        context.read<LeaguesCubit>().toggleLeague(league: league.code);
      },
      content: SizedBox(
        height: 48,
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Row(
                  spacing: 5,
                  children: [
                    BlocBuilder<LeaguesCubit, LeaguesState>(
                      builder: (context, state) {
                        final enabled =
                            state.enabledLeagues[league.code] ?? false;
                        return SizedBox(
                          width: 34,
                          child: FittedBox(
                            fit: BoxFit.fill,
                            child: IgnorePointer(
                              child: Switch(
                                padding: EdgeInsets.zero,
                                value: enabled,
                                onChanged: (v) {},
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    Expanded(
                      child: AutoSizeText(
                        league.name,
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(
                              fontVariations: <FontVariation>[
                                ...(Theme.of(
                                              context,
                                            )
                                            .textTheme
                                            .labelMedium
                                            ?.fontVariations ??
                                        const <FontVariation>[])
                                    .where((v) => v.axis != 'wght'),
                                const FontVariation('wght', 700),
                              ],
                            ),
                        maxLines: 2,
                        minFontSize: 8,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            CrestImage(
              crest: league.emblem,
              margin: 2.5,
              showBackground: true,
              fit: BoxFit.contain,
              height: double.infinity,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
