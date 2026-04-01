import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';
import 'package:tiki_taka_scoreboard_wearos/home/home.dart';
import 'package:tiki_taka_scoreboard_wearos/l10n/l10n.dart';
import 'package:tiki_taka_scoreboard_wearos/match/match.dart';
import 'package:tiki_taka_scoreboard_wearos/settings/settings.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  Stream<List<Match>>? _matchesStream;
  final ScrollController _scrollController =
      ScrollController(keepScrollOffset: false);

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final database = getIt<DatabaseService>();
    final localStorage = getIt<LocalStorageService>();

    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state.reload || _matchesStream == null) {
          _matchesStream = database.getMatchesStream(
            enabledLeagues: localStorage.getEnabledLeagues() ?? [],
          );
        }

        context.read<HomeCubit>().reload(value: false);

        return StreamBuilder<List<Match>>(
          key: state.reload ? UniqueKey() : null,
          stream: _matchesStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return AppScaffold.basic(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: AppVariables.scaffoldSpacing,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: ScrollText(text: l10n.errorMatches),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (!snapshot.hasData) {
              return AppScaffold.scrollable(
                controller: _scrollController,
                child: Column(
                  spacing: AppVariables.scaffoldSpacing,
                  children: [
                    const SizedBox(height: AppVariables.topScaffoldSpacing),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppVariables.horizontalPaddingTitle,
                      ),
                      child: ScrollText(
                        text: l10n.titleMatches.toUpperCase(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: AppVariables.titleSize,
                          height: AppVariables.titleTextHeight,
                        ),
                      ),
                    ),
                    const LastUpdateHome(isLoading: true),
                    ...List.generate(
                      AppVariables.numberOfShimmers,
                      (index) => const ShimmerMatchCardHome(),
                    ),
                    const SettingsHome(),
                    const SizedBox(
                      height: AppVariables.bottomScaffoldSpacing,
                    ),
                  ],
                ),
              );
            }

            if (snapshot.data!.isEmpty) {
              return AppScaffold.basic(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: AppVariables.scaffoldSpacing,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: ScrollText(text: l10n.emptyMatches),
                      ),
                      const SettingsHome(),
                    ],
                  ),
                ),
              );
            }

            final performance = getIt<PerformanceService>();
            final trace = performance.startTrace('home_matches_sorting');
            final nowDate = DateTime.now();
            final matches = snapshot.data!.map((match) => match).toList()
              ..sort((a, b) {
                final statusOrder = {
                  'IN_PLAY': 0,
                  'PAUSED': 1,
                  'SCHEDULED': 2,
                  'TIMED': 3,
                };
                final aStatus = a.status;
                final bStatus = b.status;
                final aOrder = statusOrder[aStatus] ?? 4;
                final bOrder = statusOrder[bStatus] ?? 4;
                if (aOrder != bOrder) {
                  return aOrder - bOrder;
                }
                return aStatus.compareTo(bStatus);
              });
            performance.stopTrace(trace);

            return AppScaffold.scrollable(
              key: Key('${nowDate.year}-${nowDate.month}-${nowDate.day}'),
              controller: _scrollController,
              child: Column(
                spacing: AppVariables.scaffoldSpacing,
                children: [
                  const SizedBox(height: AppVariables.topScaffoldSpacing),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppVariables.horizontalPaddingTitle,
                    ),
                    child: ScrollText(
                      text: l10n.titleMatches.toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: AppVariables.titleSize,
                        height: AppVariables.titleTextHeight,
                      ),
                    ),
                  ),
                  const LastUpdateHome(),
                  ...matches.map(
                    (match) => MatchCardHome(match: match),
                  ),
                  const SettingsHome(),
                  const SizedBox(
                    height: AppVariables.bottomScaffoldSpacing,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class LastUpdateHome extends StatefulWidget {
  const LastUpdateHome({
    this.isLoading = false,
    super.key,
  });

  final bool isLoading;

  @override
  State<LastUpdateHome> createState() => _LastUpdateHomeState();
}

class _LastUpdateHomeState extends State<LastUpdateHome>
    with WidgetsBindingObserver {
  late StreamSubscription<void> _nowSubscription;
  final DatabaseService database = getIt<DatabaseService>();

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _nowSubscription = Stream<void>.periodic(
      const Duration(seconds: 1),
    ).listen((_) => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_nowSubscription.cancel());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (widget.isLoading) {
      return Text(
        l10n.updatingMatches,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
      );
    }

    return StreamBuilder<Config>(
      stream: database.getConfigStream(id: AppVariables.matchesCollection),
      builder: (context, snapshot) {
        final config = snapshot.data ??
            Config(
              id: AppVariables.matchesCollection,
              lastUpdate: DateTime.now(),
            );

        final delta = DateTime.now().difference(config.lastUpdate);

        return Text(
          l10n.updatedSecondsAgo(delta.inSeconds),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 10,
          ),
        );
      },
    );
  }
}

class ShimmerMatchCardHome extends StatelessWidget {
  const ShimmerMatchCardHome({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppCardData(
      content: Column(
        children: [
          AppSchimmer(width: 100),
          SizedBox(height: 5),
          Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppSchimmer(height: 40, width: 40),
                    SizedBox(height: 5),
                    AppSchimmer(width: 40),
                  ],
                ),
              ),
              Expanded(child: AppSchimmer(height: 30)),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppSchimmer(height: 40, width: 40),
                    SizedBox(height: 5),
                    AppSchimmer(width: 40),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MatchCardHome extends StatelessWidget {
  const MatchCardHome({
    required this.match,
    super.key,
  });

  final Match match;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = AppFunctions.getMatchState(
      match.status,
      match.utcDate!,
      l10n,
    );

    return AppCardData(
      title: match.competition.name,
      content: GestureDetector(
        onTap: () {
          getIt<AnalyticsService>().logEvent(
            name: 'match_clicked',
            parameters: {'match_id': match.id.toString()},
          );
          unawaited(
            Navigator.of(context).pushNamed(
              MatchPage.routeName,
              arguments: match.id,
            ),
          );
        },
        child: Row(
          spacing: 5,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CrestImage(
                    crest: match.homeTeam.crest,
                    dimension: 50,
                    margin: 2.5,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    match.homeTeam.tla,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            getMatchStatus(
              context: context,
              status: match.status,
              state: state,
              match: match,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CrestImage(
                    crest: match.awayTeam.crest,
                    dimension: 50,
                    margin: 2.5,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    match.awayTeam.tla,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getMatchStatus({
    required BuildContext context,
    required String status,
    required String state,
    required Match match,
  }) {
    if (status == 'SCHEDULED' || status == 'TIMED') {
      return Expanded(
        child: Column(
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                state,
                style: const TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    } else if (status == 'IN_PLAY' || status == 'PAUSED') {
      return Expanded(
        child: Column(
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                '${match.score.fullTime.home} - '
                '${match.score.fullTime.away}',
                style: const TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ScrollText(
              text: state,
              style: const TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: AppLinearProgressBar(strokeWidth: 4),
            ),
          ],
        ),
      );
    } else {
      return Expanded(
        child: Column(
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                '${match.score.fullTime.home} - '
                '${match.score.fullTime.away}',
                style: const TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ScrollText(
              text: state,
              style: const TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }
  }
}

class SettingsHome extends StatelessWidget {
  const SettingsHome({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Row(
      children: [
        Expanded(
          child: AppFilledButton(
            onPressed: () async {
              getIt<AnalyticsService>().logEvent(name: 'settings_clicked');
              final reload = (await Navigator.of(context)
                      .pushNamed(SettingsPage.routeName)) as bool? ??
                  true;
              if (reload) {
                // ignore: use_build_context_synchronously // It's safe here
                context.read<HomeCubit>().reload();
              }
            },
            label: l10n.titleSettings.toUpperCase(),
          ),
        ),
      ],
    );
  }
}
