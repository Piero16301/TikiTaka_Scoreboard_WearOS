import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';
import 'package:tiki_taka_scoreboard_wearos/l10n/l10n.dart';
import 'package:tiki_taka_scoreboard_wearos/teams/teams.dart';

class TeamsView extends StatefulWidget {
  const TeamsView({super.key});

  @override
  State<TeamsView> createState() => _TeamsViewState();
}

class _TeamsViewState extends State<TeamsView> {
  final _scrollController = ScrollController(keepScrollOffset: false);
  late final Stream<List<Team>> _teamsStream;
  late final Stream<Device> _deviceStream;

  @override
  void initState() {
    super.initState();
    final leagueId = context.read<TeamsCubit>().state.leagueId;
    final database = getIt<DatabaseService>();
    final notification = getIt<NotificationService>();

    _teamsStream = database.getTeamsStream(leagueId: leagueId);
    _deviceStream = database.getDeviceStream(token: notification.token);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return StreamBuilder<List<Team>>(
      stream: _teamsStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return AppScaffold.basic(
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

        if (!snapshot.hasData) {
          return AppScaffold.scrollable(
            controller: _scrollController,
            child: Column(
              spacing: AppVariables.scaffoldSpacing,
              children: [
                const SizedBox(height: AppVariables.topScaffoldSpacing),
                AppTitleText(title: l10n.titleTeams.toUpperCase()),
                ...List.generate(
                  AppVariables.numberOfShimmers,
                  (index) => const ShimmerCardTeams(),
                ),
                const BackButtonTeams(),
                const SizedBox(height: AppVariables.bottomScaffoldSpacing),
              ],
            ),
          );
        }

        if (snapshot.data!.isEmpty) {
          return AppScaffold.basic(
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

        return AppScaffold.scrollable(
          controller: _scrollController,
          child: Column(
            spacing: AppVariables.scaffoldSpacing,
            children: [
              const SizedBox(height: AppVariables.topScaffoldSpacing),
              AppTitleText(title: l10n.titleTeams.toUpperCase()),
              StreamBuilder<Device>(
                stream: _deviceStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const SizedBox.shrink();
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox.shrink();
                  }

                  if (snapshot.data == null) {
                    return const SizedBox.shrink();
                  }

                  final device = snapshot.data!;
                  final enabledTeams = device.enabledTeams;

                  return Column(
                    spacing: AppVariables.scaffoldSpacing,
                    children: teams
                        .map(
                          (team) => TeamCardTeams(
                            enabledTeams: enabledTeams,
                            team: team,
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
      content: Row(
        spacing: 5,
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
          AppSchimmer(height: 40, width: 40),
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
    final notification = getIt<NotificationService>();
    final database = getIt<DatabaseService>();
    final leagueId = context.read<TeamsCubit>().state.leagueId;

    return AppCardData(
      content: Row(
        spacing: 5,
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
                    onChanged: (value) => database.updateDeviceSettings(
                      token: notification.token,
                      teamToModify: team.id,
                      enabledTeams: enabledTeams,
                    ),
                  ),
                ),
              );
            },
          ),
          CrestImage(
            crest: team.crest,
            margin: leagueId == 2000 ? 0 : 2.5,
          ),
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
      padding: const EdgeInsets.only(
        top: AppVariables.bottomScaffoldSpacingButton,
      ),
      child: Row(
        children: [
          Expanded(
            child: AppFilledButton(
              onPressed: () => Navigator.of(context).pop(),
              label: l10n.backText,
            ),
          ),
        ],
      ),
    );
  }
}
