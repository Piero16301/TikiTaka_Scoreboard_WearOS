import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';
import 'package:tiki_taka_scoreboard_wearos/l10n/l10n.dart';
import 'package:tiki_taka_scoreboard_wearos/teams/teams.dart';
import 'package:user_api/user_api.dart';
import 'package:wearable_rotary/wearable_rotary.dart'
    as wearable_rotary
    show rotaryEvents;
import 'package:wearable_rotary/wearable_rotary.dart' hide rotaryEvents;

class TeamsView extends StatefulWidget {
  TeamsView({
    super.key,
    @visibleForTesting Stream<RotaryEvent>? rotaryEvents,
  }) : rotaryEvents = rotaryEvents ?? wearable_rotary.rotaryEvents;

  final Stream<RotaryEvent> rotaryEvents;

  @override
  State<TeamsView> createState() => _TeamsViewState();
}

class _TeamsViewState extends State<TeamsView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: context.read<TeamsCubit>().getTeams(),
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
                          text: l10n.titleTeams.toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: titleSize,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ...List.generate(
                        numberOfShimmers,
                        (index) => const ShimmerCardTeams(),
                      ),
                      const BackButtonTeams(),
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
            backgroundColor: Colors.black,
            body: SizedBox.expand(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        l10n.errorTeams,
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
                        l10n.emptyTeams,
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

        final teams = snapshot.data!.docs
            .map((doc) => Team.fromJson(doc.data()))
            .toList();

        return Scaffold(
          body: SizedBox.expand(
            child: AppRotaryScrollbar(
              controller: _scrollController,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: ScrollText(
                          text: l10n.titleTeams.toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: titleSize,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: context.read<TeamsCubit>().getDevices(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const SizedBox.shrink();
                          }

                          if (snapshot.hasError) {
                            return const SizedBox.shrink();
                          }

                          if (snapshot.data!.docs.isEmpty) {
                            return const SizedBox.shrink();
                          }

                          final enabledTeams =
                              snapshot.data!.docs.first.data()['enabledTeams']
                                  as List<dynamic>? ??
                              [];

                          return Column(
                            children: teams
                                .map(
                                  (team) => TeamCardTeams(
                                    enabledTeams: enabledTeams
                                        .map((e) => e.toString())
                                        .toList(),
                                    team: team,
                                  ),
                                )
                                .toList(),
                          );
                        },
                      ),
                      const BackButtonTeams(),
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
  }
}

class ShimmerCardTeams extends StatelessWidget {
  const ShimmerCardTeams({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppCardData(
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: FittedBox(
              fit: BoxFit.fill,
              child: Switch(
                padding: EdgeInsets.zero,
                value: false,
                onChanged: null,
              ),
            ),
          ),
          SizedBox(width: 5),
          AppSchimmer(height: 40, width: 40),
          SizedBox(width: 5),
          Expanded(child: AppSchimmer()),
        ],
      ),
    );
  }
}

class TeamCardTeams extends StatelessWidget {
  const TeamCardTeams({
    required this.enabledTeams,
    required this.team,
    super.key,
  });

  final List<String> enabledTeams;
  final Team team;

  @override
  Widget build(BuildContext context) {
    return AppCardData(
      child: Row(
        children: [
          BlocBuilder<TeamsCubit, TeamsState>(
            builder: (context, state) {
              final enabled = enabledTeams.contains(team.id.toString());
              return SizedBox(
                width: 40,
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: Switch(
                    padding: EdgeInsets.zero,
                    value: enabled,
                    onChanged: (value) {
                      context.read<TeamsCubit>().toggleTeam(
                        team: team,
                        enabledTeams: enabledTeams,
                      );
                    },
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 5),
          CrestImage(crest: team.crest),
          const SizedBox(width: 5),
          Expanded(child: ScrollText(text: team.name)),
        ],
      ),
    );
  }
}

class BackButtonTeams extends StatelessWidget {
  const BackButtonTeams({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: ElevatedButton(
        onPressed: () => Navigator.of(context).pop(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Text(
                l10n.backText.toUpperCase(),
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
