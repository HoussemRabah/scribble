import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:scribble/UI/pages/home.dart';
import 'package:scribble/module/message.dart';
import 'package:scribble/repository/database_repo.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  DatabaseRepository database = DatabaseRepository();
  List<Message> messages = [];
  bool expanded = false;
  int currentPlayer = 0;
  int currentRound = 0;
  bool myTurn = false;
  String currentWord = "";
  String lastCurrentWord = "";
  List<Object?> listOfWords = [];
  int totalScore = 0;
  int nowErrors = 0;
  String winner = "";
  Timestamp? beginTime;
  BuildContext? context;

  GameBloc() : super(GameInitial()) {
    on<GameEvent>((event, emit) async {
      if (event is GameEventInit) {
        if (roomBloc.roomId != null) {
          context = event.context;
          messages = await database.getMessages(roomBloc.roomId!);
          winner = await database.getWinner(roomBloc.roomId!);
          database.gameListener(roomBloc.roomId!);

          currentRound = await database.getCurrentRound(roomBloc.roomId!);
          currentPlayer = await database.getCurrentPlayer(roomBloc.roomId!);
          if (userBloc.user!.user!.uid == roomBloc.players[currentPlayer].id) {
            myTurn = true;
            listOfWords = (await database.getListOfWords(roomBloc.roomId!));

            currentWord = "";
          } else {
            print(roomBloc.players[currentPlayer].id);
            myTurn = false;
          }
        }
      }
      if (event is GameEventRefresh) {
        messages = await database.getMessages(roomBloc.roomId!);
        currentRound = await database.getCurrentRound(roomBloc.roomId!);
        winner = await database.getWinner(roomBloc.roomId!);
        beginTime = await database.getTimeBegin(roomBloc.roomId!);
        currentPlayer = await database.getCurrentPlayer(roomBloc.roomId!);
        if (userBloc.user!.user!.uid == roomBloc.players[currentPlayer].id) {
          myTurn = true;
          listOfWords = (await database.getListOfWords(roomBloc.roomId!));
          currentWord = "";
        } else {
          myTurn = false;
        }
        currentWord = (await database.getCurrentWord(roomBloc.roomId!));
        emit(GameInitial());
      }

      if (event is GameEventSendMessage) {
        int nowScore = 0;
        await database.addMessage(roomBloc.roomId!, event.word);
        if (currentWord.toUpperCase().contains(event.word.toUpperCase())) {
          lastCurrentWord = currentWord;
          nowScore = 100 - nowErrors * 5;
          if (nowScore < 0) nowScore = 0;
          database.addPlayerScore(userBloc.userName!, roomBloc.roomId!,
              userBloc.user!.user!.uid, nowScore);
          totalScore = totalScore + nowScore;
          add(GameEventNextPlayer());
        } else {
          nowErrors++;
          emit(GameInitial());
        }
      }

      if (event is GameEventThisWord) {
        await database.setWord(roomBloc.roomId!, event.word);
        Timestamp now = Timestamp.now();
        await database.setTimeBegin(roomBloc.roomId!, now);
      }

      if (event is GameEventExpand) {
        expanded = !expanded;
        emit(GameInitial());
      }
      if (event is GameEventNextPlayer) {
        currentPlayer++;
        if (currentPlayer >= roomBloc.players.length) {
          currentPlayer = 0;
          await database.nextPlayer(roomBloc.roomId!, currentPlayer);
          add(GameEventNewRound());
        } else {
          database.nextPlayer(roomBloc.roomId!, currentPlayer);
          emit(GameInitial());
        }
      }

      if (event is GameEventNewRound) {
        emit(GameStateLoading());
        currentRound++;
        if (currentRound >= roomBloc.rounds) {
          database.gameEnd(roomBloc.roomId!);

          add(GameEventGameEnd());
        } else {
          await database.nextRound(roomBloc.roomId!, currentRound);
          Future.delayed(Duration(seconds: 7));
          emit(GameInitial());
        }
      }

      if (event is GameEventGameEnd) {
        Navigator.of(context!)
            .pushReplacement(MaterialPageRoute(builder: (context) => Home()));
      }
    });
  }
}
