import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:tiki_taka/app/app.dart';
import 'package:user_api/user_api.dart';
import 'package:user_repository/user_repository.dart';

part 'teams_state.dart';

class TeamsCubit extends Cubit<TeamsState> {
  TeamsCubit(this.userRepository) : super(const TeamsState());

  final UserRepository userRepository;

  void initCollections(int leagueId) {
    final teams = FirebaseFirestore.instance.collection(teamsCollection);
    final notDevices =
        FirebaseFirestore.instance.collection(notDevicesCollection);
    emit(
      state.copyWith(
        leagueId: leagueId,
        teamsCollection: teams,
        notDevicesCollection: notDevices,
      ),
    );
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>? getTeams() {
    final snapshots = state.teamsCollection
        ?.where('competition.id', isEqualTo: state.leagueId)
        .orderBy('name')
        .snapshots();
    return snapshots;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>? getNotDevices() {
    final snapshots = state.notDevicesCollection
        ?.where('token', isEqualTo: NotificationService.instance.getToken())
        .snapshots();
    return snapshots;
  }

  Future<void> toggleTeam({
    required Team team,
    required bool enabled,
  }) async {
    // Get FCM token
    final token = NotificationService.instance.getToken();

    // Add or remove to team topic
    if (enabled) {
      await NotificationService.instance.subscribeToTopic(
        'team-${team.id}',
      );
    } else {
      await NotificationService.instance.unsubscribeFromTopic(
        'team-${team.id}',
      );
    }

    await state.notDevicesCollection?.doc(token).get().then((doc) {
      if (doc.exists) {
        // Get current enabled teams
        final currentEnabledTeams =
            doc.data()?['enabledTeams'] as Map<String, dynamic>? ?? {};

        // Update the enabled teams
        currentEnabledTeams[team.id.toString()] = enabled;

        // Update the document with the new enabled teams
        state.notDevicesCollection?.doc(token).update({
          'enabledTeams': currentEnabledTeams,
        });
      } else {
        // Create new document
        state.notDevicesCollection?.doc(token).set({
          'enabledTeams': {
            team: enabled,
          },
        });
      }
    });
  }
}
