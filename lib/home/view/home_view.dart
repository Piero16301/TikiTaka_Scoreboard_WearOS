import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rotary_scrollbar/rotary_scrollbar.dart';
import 'package:tiki_taka/app/app.dart';
import 'package:tiki_taka/home/home.dart';
import 'package:tiki_taka/l10n/l10n.dart';
import 'package:tiki_taka/match/match.dart';
import 'package:tiki_taka/settings/settings.dart';
import 'package:user_api/user_api.dart';
import 'package:wearable_rotary/wearable_rotary.dart' as wearable_rotary
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
    final l10n = context.l10n;

    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        context.read<HomeCubit>().reload(value: false);

        return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          key: state.reload ? UniqueKey() : null,
          stream: context.read<HomeCubit>().getMatches(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Scaffold(
                body: SizedBox.expand(
                  child: Center(
                    child: SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator(),
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
                          Text(
                            l10n.errorMatches,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
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
                          Text(
                            l10n.emptyMatches,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          const SettingsHome(),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }

            final matches = snapshot.data!.docs
                .map((doc) => Match.fromJson(doc.data()))
                .toList();

            return Scaffold(
              body: SizedBox.expand(
                child: RotaryScrollbar(
                  controller: _scrollController,
                  scrollAnimationCurve: Curves.easeInOut,
                  scrollAnimationDuration: scrollDuration,
                  scrollMagnitude: scrollMagnitude,
                  width: scrollWidth,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          Text(
                            l10n.titleMatches.toUpperCase(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          const LastUpdateHome(),
                          const SizedBox(height: 10),
                          ...matches
                              .map((match) => MatchCardHome(match: match)),
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
  const LastUpdateHome({super.key});

  @override
  State<LastUpdateHome> createState() => _LastUpdateHomeState();
}

class _LastUpdateHomeState extends State<LastUpdateHome>
    with WidgetsBindingObserver {
  late StreamSubscription<void> _nowSubscription;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _nowSubscription = Stream<void>.periodic(const Duration(seconds: 1))
        .listen((_) => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _nowSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return StreamBuilder(
      stream: context.read<HomeCubit>().getMatchConfigs(),
      builder: (context, snapshot) {
        final configs = snapshot.data?.docs
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
          l10n.updatedMatches(delta.inSeconds),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
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
    final state = getMatchState(match.status, match.utcDate!, context.l10n);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: GestureDetector(
        onTap: () => Navigator.of(context).pushNamed(
          MatchPage.routeName,
          arguments: match,
        ),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
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
            Text(
              state,
              style: const TextStyle(
                fontSize: 10,
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
            Text(
              state,
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
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: ElevatedButton(
        onPressed: () async {
          final reload = (await Navigator.of(context)
                  .pushNamed(SettingsPage.routeName)) as bool? ??
              true;
          if (reload) {
            // ignore: use_build_context_synchronously
            context.read<HomeCubit>().reload();
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                l10n.titleSettings.toUpperCase(),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
