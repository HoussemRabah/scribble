import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:scribble/UI/pages/gamePage.dart';
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
  bool iamTheCreator = true;
  String? roomId;
  List<Player> players = [];
  String error = "";
  BuildContext? context;

  RoomBloc() : super(RoomInitial()) {
    on<RoomEvent>((event, emit) async {
      if (event is RoomEventInit) {
        context = (event as RoomEventInit).context;
      }

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
              id: userBloc.user!.user!.uid,
              totalScore: 0,
              nowScore: 0,
            ));
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

      if (event is RoomEventGameOn) {
        Navigator.of(context!).pushReplacement(
            MaterialPageRoute(builder: (context) => GamePage()));
      }

      if (event is RoomEventJoinRoomStart) {
        emit(RoomStateLoading(process: 0.1));
        roomId = event.roomId;
        bool reponse = await database.joinRoom(
            event.roomId,
            Player(
              name: userBloc.userName ?? getDefaultName(),
              avatar: userBloc.avatar,
              id: userBloc.user!.user!.uid,
              totalScore: 0,
              nowScore: 0,
            ));
        if (reponse) {
          iamTheCreator = false;

          database.playersListener(roomId!);

          emit(RoomStateLoading(process: 0.5));
          players = await database.getPlayers(roomId!);

          emit(RoomStateLoading(process: 0.9));
          await Future.delayed(Duration(seconds: 1));
          emit(RoomStateNewRoom(id: roomId!, players: players));
        } else {
          error = "kach error ";

          emit(RoomStateJoinRoom());
        }
      }

      if (event is RoomEventError) {
        error = event.error;
        emit(event.nextStat);
      }
      if (event is RoomEventStartTheGame) {
        database.startTheGame(
          roomId!,
          Round(creatorId: userBloc.user!.user!.uid, roundsNumber: rounds),
        );
      }
    });
  }
}
