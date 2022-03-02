part of 'user_bloc.dart';

@immutable
abstract class UserEvent {}

class UserEventNewUser extends UserEvent {
  final String username;
  UserEventNewUser({required this.username}) : super();
}

class UserEventInit extends UserEvent {
  final BuildContext context;
  UserEventInit({required this.context}) : super();
}

class UserEventChangeAvatar extends UserEvent {
  final String newAvatar;
  UserEventChangeAvatar({required this.newAvatar}) : super();
}
