import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scribble/UI/pages/avatarPage.dart';
import 'package:scribble/repository/auth_repo.dart';
import 'package:scribble/repository/storage_repo.dart';
import 'package:scribble/sys.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  StorageRepository storage = StorageRepository();
  AuthRepository auth = AuthRepository();
  UserCredential? user;
  String? userName;
  BuildContext? context;
  String avatar = "assets/Skins/Boy.svg";

  UserBloc() : super(UserStateLoading(process: 0.0)) {
    on<UserEvent>((event, emit) async {
      if (event is UserEventInit) {
        context = event.context;
        emit(UserStateLoading(process: 0.1));
        user = await auth.signIn();
        emit(UserStateLoading(process: 0.3));

        userName = await storage.getUser();

        emit(UserStateLoading(process: 0.6));

        if (userName == null) {
          emit(UserStateWriteName());
        } else {
          await Future.delayed(Duration(milliseconds: 1000));
          emit(UserStateLoading(process: 1.0));

          Navigator.of(context!).pushReplacement(
              MaterialPageRoute(builder: (context) => AvatarPage()));
        }
      }

      if (event is UserEventChangeAvatar) {
        emit(UserStateLoading(process: 1.0));
        avatar = event.newAvatar;
      }

      if (event is UserEventNewUser) {
        emit(UserStateLoading(process: 0.8));
        userName = event.username;
        if (userName!.isEmpty) userName = getDefaultName();
        bool reponse = await storage.setUser(userName!);

        if (reponse) {
          emit(UserStateLoading(process: 1.0));
          await Future.delayed(Duration(milliseconds: 1000));
          Navigator.of(context!).pushReplacement(
              MaterialPageRoute(builder: (context) => AvatarPage()));
        }
      }
    });
  }
}
