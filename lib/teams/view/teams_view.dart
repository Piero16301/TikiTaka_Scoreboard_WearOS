import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';
import 'package:tiki_taka_scoreboard_wearos/l10n/l10n.dart';
import 'package:tiki_taka_scoreboard_wearos/teams/teams.dart';
import 'package:wearable_rotary/wearable_rotary.dart' as wearable_rotary
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
    final leagueId = context.read<TeamsCubit>().state.leagueId;
    final database = getIt<DatabaseService>();
    final notification = getIt<NotificationService>();

    return StreamBuilder<List<Team>>(
      stream: database.getTeamsByLeague(leagueId: leagueId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return AppScaffold(
            controller: _scrollController,
            child: SingleChildScrollView(
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
                      text: l10n.titleTeams.toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: AppVariables.titleSize,
                      ),
                    ),
                  ),
                  ...List.generate(
                    AppVariables.numberOfShimmers,
                    (index) => const ShimmerCardTeams(),
                  ),
                  const BackButtonTeams(),
                  const SizedBox(height: AppVariables.bottomScaffoldSpacing),
                ],
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return AppScaffold(
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
          );
        }

        if (snapshot.data!.isEmpty) {
          return AppScaffold(
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
          );
        }

        final teams = snapshot.data!;

        return AppScaffold(
          controller: _scrollController,
          child: SingleChildScrollView(
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
                    text: l10n.titleTeams.toUpperCase(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: AppVariables.titleSize,
                    ),
                  ),
                ),
                StreamBuilder<List<Map<String, dynamic>>>(
                  stream: database.getDevices(token: notification.token),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const SizedBox.shrink();
                    }

                    if (snapshot.hasError) {
                      return const SizedBox.shrink();
                    }

                    if (snapshot.data!.isEmpty) {
                      return const SizedBox.shrink();
                    }

                    final enabledTeams = snapshot.data!.first['enabledTeams']
                            as List<dynamic>? ??
                        [];
                    final noShowCrestTeams = [779, 828];

                    return Column(
                      spacing: AppVariables.scaffoldSpacing,
                      children: teams
                          .map(
                            (team) => TeamCardTeams(
                              enabledTeams: enabledTeams
                                  .map((e) => e.toString())
                                  .toList(),
                              team: team,
                              hideCrest: noShowCrestTeams.contains(team.id),
                            ),
                          )
                          .toList(),
                    );
                  },
                ),
                const BackButtonTeams(),
                const SizedBox(height: AppVariables.bottomScaffoldSpacing),
              ],
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
    required this.hideCrest,
    super.key,
  });

  final List<String> enabledTeams;
  final Team team;
  final bool hideCrest;

  @override
  Widget build(BuildContext context) {
    final notification = getIt<NotificationService>();
    final database = getIt<DatabaseService>();

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
                    onChanged: (value) => database.changeEnabledTeams(
                      teamId: team.id,
                      token: notification.token,
                      enabledTeams: enabledTeams,
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 5),
          CrestImage(crest: team.crest, hideCrest: hideCrest),
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

    return ElevatedButton(
      onPressed: () => Navigator.of(context).pop(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: AppVariables.verticalPaddingBackButton,
            ),
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
    );
  }
}
