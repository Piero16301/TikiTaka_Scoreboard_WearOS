part of 'notifications_cubit.dart';

class NotificationsState extends Equatable {
  const NotificationsState({
    this.leaguesCollection,
  });

  final CollectionReference<Map<String, dynamic>>? leaguesCollection;

  NotificationsState copyWith({
    CollectionReference<Map<String, dynamic>>? leaguesCollection,
  }) {
    return NotificationsState(
      leaguesCollection: leaguesCollection ?? this.leaguesCollection,
    );
  }

  @override
  List<Object?> get props => [
        leaguesCollection,
      ];
}
