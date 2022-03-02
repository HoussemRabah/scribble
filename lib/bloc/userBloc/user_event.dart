part of 'user_bloc.dart';

@immutable
abstract class UserEvent {}

class UserEventNewUser extends UserEvent {
  final String username;
  UserEventNewUser({required this.username}) : super();
}

class UserEventInit extends UserEvent {
  BuildContext context;
  UserEventInit({required this.context}) : super();
}
