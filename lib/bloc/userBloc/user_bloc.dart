import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
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

  UserBloc() : super(UserInitial()) {
    on<UserEvent>((event, emit) async {
      if (event is UserEventInit) {
        emit(UserStateLoading(process: 0.1));
        user = await auth.signIn();
        emit(UserStateLoading(process: 0.3));
        userName = await storage.getUser();
        emit(UserStateLoading(process: 0.6));
        if (userName == null) {
          emit(UserStateWriteName());
        } else {
          emit(UserStateLoadedSigned(username: userName ?? getDefaultName()));
        }
      }

      if (event is UserEventNewUser) {
        emit(UserStateLoading(process: 0.8));
        bool reponse = await storage.setUser(userName ?? getDefaultName());

        if (reponse) emit(UserStateLoading(process: 1.0));
      }
    });
  }
}
