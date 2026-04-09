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
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    l10n.errorNotifications,
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
                AppTitleText(title: l10n.titleNotifications.toUpperCase()),
                ...List.generate(
                  AppVariables.numberOfShimmers,
                  (index) => const ShimmerCardNotifications(),
                ),
                const BackButtonNotifications(),
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
                    l10n.emptyNotifications,
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

        final leagues = snapshot.data!;

        return AppScaffold.scrollable(
          controller: _scrollController,
          child: Column(
            spacing: AppVariables.scaffoldSpacing,
            children: [
              const SizedBox(height: AppVariables.topScaffoldSpacing),
              AppTitleText(title: l10n.titleNotifications.toUpperCase()),
              ...leagues.map(
                (league) => LeagueCardNotifications(league: league),
              ),
              const BackButtonNotifications(),
              const SizedBox(height: AppVariables.bottomScaffoldSpacing),
            ],
          ),
        );
      },
    );
  }
}

class ShimmerCardNotifications extends StatelessWidget {
  const ShimmerCardNotifications({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppCardData(
      content: Row(
        children: [
          SizedBox(width: 10),
          AppSchimmer(height: 40, width: 40),
          SizedBox(width: 10),
          Expanded(child: AppSchimmer()),
          SizedBox(width: 10),
          SizedBox(
            width: 40,
            height: 40,
            child: IconButton(
              onPressed: null,
              icon: Icon(Icons.arrow_forward_ios),
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
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
    return AppCardData(
      content: Row(
        spacing: 5,
        children: [
          CrestImage(crest: league.emblem, margin: 2.5),
          Expanded(child: ScrollText(text: league.name)),
          SizedBox(
            width: 40,
            height: 40,
            child: IconButton(
              onPressed: () => Navigator.of(context).pushNamed(
                TeamsPage.routeName,
                arguments: league.id,
              ),
              icon: const Icon(Icons.arrow_forward_ios),
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }
}

class BackButtonNotifications extends StatelessWidget {
  const BackButtonNotifications({super.key});

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
