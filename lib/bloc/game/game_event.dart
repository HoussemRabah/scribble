part of 'game_bloc.dart';

@immutable
abstract class GameEvent {}

class GameEventInit extends GameEvent {}

class GameEventRefresh extends GameEvent {}
