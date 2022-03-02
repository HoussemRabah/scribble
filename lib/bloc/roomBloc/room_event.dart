part of 'room_bloc.dart';

@immutable
abstract class RoomEvent {}

class RoomEventIncRounds extends RoomEvent {}

class RoomEventDicRounds extends RoomEvent {}

class RoomEventNewRoom extends RoomEvent {}

class RoomEventJoinRoom extends RoomEvent {}

class RoomEventJoinRoomStart extends RoomEvent {
  final String roomId;
  RoomEventJoinRoomStart({required this.roomId}) : super();
}

class RoomEventRefresh extends RoomEvent {}

class RoomEventError extends RoomEvent {
  final RoomState nextStat;
  final String error;
  RoomEventError({required this.error, required this.nextStat}) : super();
}
