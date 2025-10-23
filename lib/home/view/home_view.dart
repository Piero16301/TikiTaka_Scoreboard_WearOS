import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';
import 'package:tiki_taka_scoreboard_wearos/home/home.dart';
import 'package:tiki_taka_scoreboard_wearos/l10n/l10n.dart';
import 'package:tiki_taka_scoreboard_wearos/match/match.dart';
import 'package:tiki_taka_scoreboard_wearos/settings/settings.dart';
import 'package:user_api/user_api.dart';
import 'package:wearable_rotary/wearable_rotary.dart'
    as wearable_rotary
    show rotaryEvents;
import 'package:wearable_rotary/wearable_rotary.dart' hide rotaryEvents;

class HomeView extends StatefulWidget {
  HomeView({
    super.key,
    @visibleForTesting Stream<RotaryEvent>? rotaryEvents,
  }) : rotaryEvents = rotaryEvents ?? wearable_rotary.rotaryEvents;

  final Stream<RotaryEvent> rotaryEvents;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        context.read<HomeCubit>().reload(value: false);

        return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          key: state.reload ? UniqueKey() : null,
          stream: context.read<HomeCubit>().getMatches(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Scaffold(
                body: SizedBox.expand(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: ScrollText(
                              text: l10n.titleMatches.toUpperCase(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: titleSize,
                              ),
                            ),
                          ),
                          const LastUpdateHome(isLoading: true),
                          const SizedBox(height: 10),
                          ...List.generate(
                            numberOfShimmers,
                            (index) => const ShimmerMatchCardHome(),
                          ),
                          const SettingsHome(),
                          const SizedBox(height: 50),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }

            if (snapshot.hasError) {
              return Scaffold(
                body: SizedBox.expand(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: ScrollText(text: l10n.errorMatches),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }

            if (snapshot.data!.docs.isEmpty) {
              return Scaffold(
                body: SizedBox.expand(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: ScrollText(text: l10n.emptyMatches),
                          ),
                          const SettingsHome(),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }

            final nowDate = DateTime.now();
            final matches =
                snapshot.data!.docs
                    .map((doc) => Match.fromJson(doc.data()))
                    .toList()
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

            return Scaffold(
              key: Key('${nowDate.year}-${nowDate.month}-${nowDate.day}'),
              body: SizedBox.expand(
                child: AppRotaryScrollbar(
                  controller: _scrollController,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: ScrollText(
                              text: l10n.titleMatches.toUpperCase(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: titleSize,
                              ),
                            ),
                          ),
                          const LastUpdateHome(),
                          const SizedBox(height: 10),
                          ...matches.map(
                            (match) => MatchCardHome(match: match),
                          ),
                          const SettingsHome(),
                          const SizedBox(height: 50),
                        ],
                      ),
                    ),
                  ),
                ),
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

    return StreamBuilder(
      stream: context.read<HomeCubit>().getMatchConfigs(),
      builder: (context, snapshot) {
        final configs =
            snapshot.data?.docs
                .map((doc) => Config.fromJson(doc.data()))
                .toList() ??
            [Config(id: matchesCollection, lastUpdate: DateTime.now())];

        if (configs.isEmpty) {
          configs.add(
            Config(id: matchesCollection, lastUpdate: DateTime.now()),
          );
        }

        final delta = DateTime.now().difference(configs.first.lastUpdate);

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
      child: Column(
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
      child: GestureDetector(
        onTap: () => Navigator.of(context).pushNamed(
          MatchPage.routeName,
          arguments: match.id,
        ),
        child: Column(
          children: [
            Text(
              match.competition.name,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CrestImage(crest: match.homeTeam.crest),
                      const SizedBox(height: 5),
                      Text(
                        match.homeTeam.tla,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                getMatchStatus(match.status, state, match),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CrestImage(crest: match.awayTeam.crest),
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
          ],
        ),
      ),
    );
  }

  Widget getMatchStatus(String status, String state, Match match) {
    if (status == 'SCHEDULED' || status == 'TIMED') {
      return Expanded(
        child: Column(
          children: [
            Text(
              state,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    } else if (status == 'IN_PLAY' || status == 'PAUSED') {
      return Expanded(
        child: Column(
          children: [
            Text(
              '${match.score.fullTime.home} - '
              '${match.score.fullTime.away}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
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
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: LinearProgressIndicator(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                backgroundColor: Colors.grey,
              ),
            ),
          ],
        ),
      );
    } else {
      return Expanded(
        child: Column(
          children: [
            Text(
              '${match.score.fullTime.home} - '
              '${match.score.fullTime.away}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
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

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: ElevatedButton(
        onPressed: () async {
          final reload =
              (await Navigator.of(context).pushNamed(SettingsPage.routeName))
                  as bool? ??
              true;
          if (reload) {
            // ignore: use_build_context_synchronously // It's safe here
            context.read<HomeCubit>().reload();
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: ScrollText(
                text: l10n.titleSettings.toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
