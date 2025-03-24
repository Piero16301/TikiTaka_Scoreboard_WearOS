part of 'home_cubit.dart';

class HomeState extends Equatable {
  const HomeState({
    this.matchesCollection,
    this.configsCollection,
    this.reload = false,
  });

  final CollectionReference<Map<String, dynamic>>? matchesCollection;
  final CollectionReference<Map<String, dynamic>>? configsCollection;
  final bool reload;

  HomeState copyWith({
    CollectionReference<Map<String, dynamic>>? matchesCollection,
    CollectionReference<Map<String, dynamic>>? configsCollection,
    bool? reload,
  }) {
    return HomeState(
      matchesCollection: matchesCollection ?? this.matchesCollection,
      configsCollection: configsCollection ?? this.configsCollection,
      reload: reload ?? this.reload,
    );
  }

  @override
  List<Object?> get props => [
        matchesCollection,
        configsCollection,
        reload,
      ];
}
