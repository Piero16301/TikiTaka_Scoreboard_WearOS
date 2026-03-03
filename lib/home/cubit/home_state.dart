part of 'home_cubit.dart';

class HomeState extends Equatable {
  const HomeState({
    this.reload = false,
  });

  final bool reload;

  HomeState copyWith({
    bool? reload,
  }) {
    return HomeState(
      reload: reload ?? this.reload,
    );
  }

  @override
  List<Object?> get props => [
        reload,
      ];
}
