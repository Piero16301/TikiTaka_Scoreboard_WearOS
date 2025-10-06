import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:tiki_taka_scoreboard_wearos/app/app.dart';
import 'package:user_repository/user_repository.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit(this.userRepository) : super(const NotificationsState());

  final UserRepository userRepository;

  void initCollections() {
    final leagues = FirebaseFirestore.instance.collection(leaguesCollection);
    emit(state.copyWith(leaguesCollection: leagues));
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>? getLeagues() {
    final snapshots = state.leaguesCollection?.snapshots();
    return snapshots;
  }
}
