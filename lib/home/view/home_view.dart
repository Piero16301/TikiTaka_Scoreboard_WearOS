import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';
import 'package:tiki_taka_scoreboard_wearos/l10n/l10n.dart';
import 'package:tiki_taka_scoreboard_wearos/match/match.dart';
import 'package:tiki_taka_scoreboard_wearos/settings/settings.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with WidgetsBindingObserver {
  late Stream<List<Match>> _matchesStream;
  final ScrollController _scrollController = ScrollController(
    keepScrollOffset: false,
  );
  late DateTime _streamDate;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _reloadStream();
  }

  void _reloadStream() {
    _streamDate = DateTime.now();
    _matchesStream = getIt<DatabaseService>().getMatchesStream(
      enabledLeagues: getIt<LocalStorageService>().getEnabledLeagues() ?? [],
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      final now = DateTime.now();
      final streamDay = DateTime(
        _streamDate.year,
        _streamDate.month,
        _streamDate.day,
      );
      final today = DateTime(now.year, now.month, now.day);
      if (today != streamDay) {
        setState(_reloadStream);
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return StreamBuilder<List<Match>>(
      stream: _matchesStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return AppScaffold.basic(
            child: AppError(
              text: l10n.errorMatches,
            ),
          );
        }

        if (!snapshot.hasData) {
          return const AppScaffold.basic(
            child: AppLoader(),
          );
        }

        if (snapshot.data!.isEmpty) {
          return AppScaffold.basic(
            child: AppEmpty(
              text: l10n.emptyMatches,
              onPressedSettings: () => _onTapSettings(context),
            ),
          );
        }

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

        return AppScaffold.scrollable(
          key: Key('${nowDate.year}-${nowDate.month}-${nowDate.day}'),
          controller: _scrollController,
          child: Column(
            children: [
              const SizedBox(height: AppVariables.topScaffoldSpacing),
              AppTitleText(title: l10n.titleMatches),
              for (final (index, match) in matches.indexed) ...[
                MatchCardHome(match: match),
                if (index < matches.length - 1)
                  const SizedBox(height: AppVariables.listSpacing),
              ],
              const SizedBox(
                height: AppVariables.bottomScaffoldSpacingButton,
              ),
              const LastUpdateHome(),
              const SizedBox(
                height: AppVariables.bottomScaffoldSpacingButton,
              ),
              AppIconButton(
                icon: HugeIcons.strokeRoundedSettings01,
                onPressed: () => _onTapSettings(context),
              ),
              const SizedBox(height: AppVariables.bottomScaffoldSpacing),
            ],
          ),
        );
      },
    );
  }

  Future<void> _onTapSettings(BuildContext context) async {
    getIt<AnalyticsService>().logEvent(name: 'settings_clicked');
    final reload =
        (await Navigator.of(context).pushNamed(SettingsPage.routeName))
            as bool? ??
        true;
    if (reload) {
      setState(_reloadStream);
    }
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
  Stream<Config>? _configStream;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _nowSubscription = Stream<void>.periodic(
      const Duration(seconds: 1),
    ).listen((_) => setState(() {}));
    _configStream = database.getConfigStream(
      id: AppVariables.matchesCollection,
    );
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
        textAlign: TextAlign.center,
        style: const TextStyle(
          height: 1,
          fontSize: 10,
        ),
      );
    }

    return StreamBuilder<Config>(
      stream: _configStream,
      builder: (context, snapshot) {
        final config =
            snapshot.data ??
            Config(
              id: AppVariables.matchesCollection,
              lastUpdate: DateTime.now(),
            );

        final delta = DateTime.now().difference(config.lastUpdate);

        return Text(
          l10n.updatedSecondsAgo(delta.inSeconds),
          textAlign: TextAlign.center,
          style: const TextStyle(
            height: 1,
            fontSize: 10,
          ),
        );
      },
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

    return AppCardAction(
      onPressed: () {
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
      title: match.competition.name,
      content: Row(
        spacing: 5,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 5,
              children: [
                CrestImage(
                  crest: match.homeTeam.crest,
                  height: 50,
                  width: 50,
                ),
                Text(match.homeTeam.tla),
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
              spacing: 5,
              children: [
                CrestImage(
                  crest: match.awayTeam.crest,
                  height: 50,
                  width: 50,
                ),
                Text(match.awayTeam.tla),
              ],
            ),
          ),
        ],
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
                style: const TextStyle(fontSize: 60),
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
                style: const TextStyle(fontSize: 60),
              ),
            ),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                state,
                style: const TextStyle(fontSize: 10),
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
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                state,
                style: const TextStyle(
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}
