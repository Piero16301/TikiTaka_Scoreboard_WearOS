part of 'home_cubit.dart';

class HomeState extends Equatable {
  const HomeState({
    this.matchesCollection,
    this.configsCollection,
  });

  final CollectionReference<Map<String, dynamic>>? matchesCollection;
  final CollectionReference<Map<String, dynamic>>? configsCollection;

  HomeState copyWith({
    CollectionReference<Map<String, dynamic>>? matchesCollection,
    CollectionReference<Map<String, dynamic>>? configsCollection,
  }) {
    return HomeState(
      matchesCollection: matchesCollection ?? this.matchesCollection,
      configsCollection: configsCollection ?? this.configsCollection,
    );
  }

  @override
  List<Object?> get props => [
        matchesCollection,
        configsCollection,
      ];
}
