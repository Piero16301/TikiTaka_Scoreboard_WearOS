import 'dart:async';

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

class _HomeViewState extends State<HomeView> with WidgetsBindingObserver {
  final ScrollController _scrollController = ScrollController();
  late StreamSubscription<void> _updateSubscription;
  late StreamSubscription<void> _updatedAtSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _updateSubscription = Stream<void>.periodic(
      const Duration(seconds: 20),
    ).listen(
      // ignore: use_build_context_synchronously
      (_) => context.read<HomeCubit>().updateMatches(),
    );
    _updatedAtSubscription = Stream<void>.periodic(
      const Duration(seconds: 1),
    ).listen(
      // ignore: use_build_context_synchronously
      (_) => context.read<HomeCubit>().updateLastUpdated(),
    );
  }

  @override
  void dispose() {
    _updateSubscription.cancel();
    _updatedAtSubscription.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read<HomeCubit>().updateMatches();
      _updateSubscription.resume();
      _updatedAtSubscription.resume();
    } else {
      if (!_updateSubscription.isPaused) _updateSubscription.pause();
      if (!_updatedAtSubscription.isPaused) _updatedAtSubscription.pause();
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        switch (state.status) {
          case HomeStatus.initial:
            return const SizedBox.shrink();
          case HomeStatus.loading:
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
          case HomeStatus.success:
            if (state.matches.isEmpty) {
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
            return Scaffold(
              body: SizedBox.expand(
                child: RotaryScrollbar(
                  controller: _scrollController,
                  scrollAnimationCurve: Curves.easeInOut,
                  scrollAnimationDuration: scrollDuration,
                  scrollMagnitude: scrollMagnitude,
                  width: scrollWidth,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
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
                          Text(
                            l10n.updatedMatches(state.lastUpdated),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ...state.matches
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
          case HomeStatus.failure:
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
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () =>
                              context.read<HomeCubit>().initialLoadMatches(),
                          child: Text(
                            l10n.retryMatches,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
        }
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
        onPressed: () =>
            Navigator.of(context).pushNamed(SettingsPage.routeName),
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
