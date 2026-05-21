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

  @override
  void initState() {
    super.initState();

    final leagueId = context.read<TeamsCubit>().state.leagueId;
    _teamsStream = getIt<DatabaseService>().getTeamsStream(leagueId: leagueId);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final enabledTeams = context.select<AppCubit, List<String>>(
      (cubit) => cubit.state.device?.enabledTeams ?? [],
    );

    return StreamBuilder<List<Team>>(
      stream: _teamsStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return AppScaffold.basic(
            child: AppError(text: l10n.errorTeams),
          );
        }

        if (!snapshot.hasData) {
          return const AppScaffold.basic(
            child: AppLoader(),
          );
        }

        if (snapshot.data!.isEmpty) {
          return AppScaffold.basic(
            child: AppEmpty(text: l10n.emptyTeams),
          );
        }

        final teams = snapshot.data!;

        return AppScaffold.scrollable(
          controller: _scrollController,
          child: Column(
            children: [
              const SizedBox(height: AppVariables.topScaffoldSpacing),
              AppTitleText(title: l10n.titleTeams),
              for (final (index, team) in teams.indexed) ...[
                TeamCardTeams(enabledTeams: enabledTeams, team: team),
                if (index < teams.length - 1)
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

    return AppCardAction(
      innerPadding: EdgeInsets.zero,
      onPressed: () {
        getIt<AnalyticsService>().logEvent(
          name: 'team_toggled',
          parameters: {'team': team.id},
        );
        database.updateDeviceSettings(
          token: notification.token,
          teamToModify: team.id,
          enabledTeams: enabledTeams,
        );
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
                    BlocBuilder<TeamsCubit, TeamsState>(
                      builder: (context, state) {
                        final enabled =
                            enabledTeams.contains(team.id.toString());
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
                      child: Text(
                        team.name,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            CrestImage(
              crest: team.crest,
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
