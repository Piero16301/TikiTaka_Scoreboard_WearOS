part of 'leagues_cubit.dart';

class LeaguesState extends Equatable {
  const LeaguesState({
    this.enabledLeagues = const <String, bool>{},
  });

  final Map<String, bool> enabledLeagues;

  LeaguesState copyWith({
    Map<String, bool>? enabledLeagues,
  }) {
    return LeaguesState(
      enabledLeagues: enabledLeagues ?? this.enabledLeagues,
    );
  }

  @override
  List<Object> get props => [
        enabledLeagues,
      ];
}
