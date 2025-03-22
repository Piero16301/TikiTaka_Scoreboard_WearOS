import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_api/user_api.dart';
import 'package:user_repository/user_repository.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this.userRepository) : super(const HomeState());

  final UserRepository userRepository;

  Future<void> initialLoadMatches() async {
    emit(state.copyWith(status: HomeStatus.loading));
    try {
      final matches = <Match>[]..sort((a, b) {
          final statusOrder = {
            'IN_PLAY': 0,
            'PAUSED': 1,
            'SCHEDULED': 2,
            'TIMED': 3,
          };
          final aStatus = a.status;
          final bStatus = b.status;
          final aOrder = statusOrder[aStatus] ?? 4;
          final bOrder = statusOrder[bStatus] ?? 4;
          if (aOrder != bOrder) {
            return aOrder - bOrder;
          }
          return aStatus.compareTo(bStatus);
        });
      emit(
        state.copyWith(
          status: HomeStatus.success,
          matches: matches,
          updatedAt: DateTime.now(),
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: HomeStatus.failure));
    }
  }

  Future<void> updateMatches() async {
    try {
      final matches = <Match>[]..sort((a, b) {
          final statusOrder = {
            'IN_PLAY': 0,
            'PAUSED': 1,
            'SCHEDULED': 2,
            'TIMED': 3,
          };
          final aStatus = a.status;
          final bStatus = b.status;
          final aOrder = statusOrder[aStatus] ?? 4;
          final bOrder = statusOrder[bStatus] ?? 4;
          if (aOrder != bOrder) {
            return aOrder - bOrder;
          }
          return aStatus.compareTo(bStatus);
        });
      emit(state.copyWith(matches: matches, updatedAt: DateTime.now()));
    } catch (_) {}
  }

  void updateLastUpdated() {
    if (state.updatedAt == null) return;
    emit(
      state.copyWith(
        lastUpdated: DateTime.now().difference(state.updatedAt!).inSeconds,
      ),
    );
  }
}
