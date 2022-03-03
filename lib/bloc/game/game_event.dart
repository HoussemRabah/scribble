part of 'game_bloc.dart';

@immutable
abstract class GameEvent {}

class GameEventInit extends GameEvent {}

class GameEventRefresh extends GameEvent {}

class GameEventExpand extends GameEvent {}

class GameEventThisWord extends GameEvent {
  final String word;
  GameEventThisWord({required this.word}) : super();
}

class GameEventSendMessage extends GameEvent {}

class GameEventNextPlayer extends GameEvent {}
