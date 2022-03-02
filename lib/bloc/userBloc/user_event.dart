part of 'user_bloc.dart';

@immutable
abstract class UserEvent {}

class UserEventNewUser extends UserEvent {
  final String username;
  BuildContext context;
  UserEventNewUser({required this.username, required this.context}) : super();
}

class UserEventInit extends UserEvent {}
