part of 'user_bloc.dart';

@immutable
abstract class UserState {}

class UserInitial extends UserState {}

class UserStateLoading extends UserState {
  final double process;
  UserStateLoading({required this.process}) : super();
}

class UserStateLoadedSigned extends UserState {
  final String username;
  UserStateLoadedSigned({required this.username}) : super();
}

class UserStateLoadedNotSigned extends UserState {}

class UserStateWriteName extends UserState {}
