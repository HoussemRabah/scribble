part of 'room_bloc.dart';

@immutable
abstract class RoomState {}

class RoomInitial extends RoomState {}

class RoomStateNewRoom extends RoomState {
  String id;
  RoomStateNewRoom({required this.id}) : super();
}

class RoomStateLoading extends RoomState {
  final double process;
  RoomStateLoading({required this.process}) : super();
}
