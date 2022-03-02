part of 'room_bloc.dart';

@immutable
abstract class RoomState {}

class RoomInitial extends RoomState {}

class RoomStateJoinRoom extends RoomState {}

class RoomStateRoomJoined extends RoomState {
  final String id;
  final List<Player> players;
  RoomStateRoomJoined({required this.id, required this.players}) : super();
}

class RoomStateNewRoom extends RoomState {
  final String id;
  final List<Player> players;

  RoomStateNewRoom({required this.id, required this.players}) : super();
}

class RoomStateLoading extends RoomState {
  final double process;
  RoomStateLoading({required this.process}) : super();
}
