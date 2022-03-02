import 'package:bloc/bloc.dart';
import 'package:firebase/firebase.dart';
import 'package:meta/meta.dart';
import 'package:scribble/UI/pages/home.dart';
import 'package:scribble/module/player.dart';
import 'package:scribble/module/round.dart';
import 'package:scribble/repository/database_repo.dart';
import 'package:scribble/sys.dart';

part 'room_event.dart';
part 'room_state.dart';

class RoomBloc extends Bloc<RoomEvent, RoomState> {
  DatabaseRepository database = DatabaseRepository();
  int rounds = 1;
  bool iamTheCreator = false;
  String? roomId;
  List<Player> players = [];
  String error = "";
  RoomBloc() : super(RoomInitial()) {
    on<RoomEvent>((event, emit) async {
      if (event is RoomEventIncRounds) {
        if (rounds + 1 <= 20) rounds++;
        emit(RoomInitial());
      }
      if (event is RoomEventDicRounds) {
        if (rounds - 1 > 0) rounds--;
        emit(RoomInitial());
      }

      if (event is RoomEventRefresh) {
        players = await database.getPlayers(roomId!);
        emit(RoomStateNewRoom(id: roomId!, players: players));
      }

      if (event is RoomEventNewRoom) {
        emit(RoomStateLoading(process: 0.3));
        roomId = await database.createRoom(
            Round(creatorId: userBloc.user!.user!.uid, roundsNumber: rounds),
            Player(
                name: userBloc.userName ?? getDefaultName(),
                avatar: userBloc.avatar,
                id: userBloc.user!.user!.uid));
        database.playersListener(roomId!);
        emit(RoomStateLoading(process: 0.5));
        players = await database.getPlayers(roomId!);
        iamTheCreator = true;
        emit(RoomStateLoading(process: 0.9));
        await Future.delayed(Duration(seconds: 1));
        emit(RoomStateNewRoom(id: roomId!, players: players));
      }

      if (event is RoomEventJoinRoom) {
        emit(RoomStateJoinRoom());
      }

      if (event is RoomEventJoinRoomStart) {
        emit(RoomStateLoading(process: 0.1));
        bool reponse = await database.joinRoom(
            event.roomId,
            Player(
                name: userBloc.userName ?? getDefaultName(),
                avatar: userBloc.avatar,
                id: userBloc.user!.user!.uid));
        if (reponse) {
          database.playersListener(roomId!);
          emit(RoomStateLoading(process: 0.5));
          players = await database.getPlayers(roomId!);
          iamTheCreator = false;
          emit(RoomStateLoading(process: 0.9));
          await Future.delayed(Duration(seconds: 1));
          emit(RoomStateNewRoom(id: roomId!, players: players));
        } else {}
      }

      if (event is RoomEventError) {
        error = event.error;
      }
    });
  }
}
