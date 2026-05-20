import 'package:flutter/material.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';
import 'package:tiki_taka_scoreboard_wearos/l10n/l10n.dart';
import 'package:tiki_taka_scoreboard_wearos/teams/teams.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  final _scrollController = ScrollController(keepScrollOffset: false);
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
            child: AppError(text: l10n.errorNotifications),
          );
        }

        if (!snapshot.hasData) {
          return const AppScaffold.basic(
            child: AppLoader(),
          );
        }

        if (snapshot.data!.isEmpty) {
          return AppScaffold.basic(
            child: AppEmpty(text: l10n.emptyNotifications),
          );
        }

        final leagues = snapshot.data!;

        return AppScaffold.scrollable(
          controller: _scrollController,
          child: Column(
            children: [
              const SizedBox(height: AppVariables.topScaffoldSpacing),
              AppTitleText(title: l10n.titleNotifications),
              for (final (index, league) in leagues.indexed) ...[
                LeagueCardNotifications(league: league),
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

class LeagueCardNotifications extends StatelessWidget {
  const LeagueCardNotifications({
    required this.league,
    super.key,
  });

  final League league;

  @override
  Widget build(BuildContext context) {
    return AppCardAction(
      innerPadding: EdgeInsets.zero,
      onPressed: () => Navigator.of(context).pushNamed(
        TeamsPage.routeName,
        arguments: league.id,
      ),
      content: SizedBox(
        height: 48,
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: 10,
                ),
                child: Row(
                  spacing: 5,
                  children: [
                    Expanded(
                      child: Text(
                        league.name,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            CrestImage(
              crest: league.emblem,
              margin: 2.5,
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
