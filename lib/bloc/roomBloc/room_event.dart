part of 'room_bloc.dart';

@immutable
abstract class RoomEvent {}

class RoomEventIncRounds extends RoomEvent {}

class RoomEventDicRounds extends RoomEvent {}

class RoomEventNewRoom extends RoomEvent {}
