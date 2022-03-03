import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scribble/UI/pages/gamePage.dart';
import 'package:scribble/UI/pages/home.dart';
import 'package:scribble/bloc/game/game_bloc.dart';
import 'package:scribble/bloc/roomBloc/room_bloc.dart';
import 'package:scribble/module/message.dart';
import 'package:scribble/module/player.dart';
import 'package:scribble/module/round.dart';

class DatabaseRepository {
  Future<List<Message>> getMessages(String roomId) async {
    List<Message> messages = [];
    FirebaseFirestore db = FirebaseFirestore.instance;
    QuerySnapshot messagesDoc = await db
        .collection("/rooms/$roomId/messages/")
        .orderBy("createdAt", descending: true)
        .get();

    for (DocumentSnapshot message in (messagesDoc.docs)) {
      messages.add(messageFromMap(message.data() as Map));
    }
    return messages;
  }

  Future<int> getCurrentRound(String roomId) async {
    int currentRound = 0;
    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentSnapshot doc = await db.doc("/rooms/$roomId/").get();

    if (doc.exists) {
      currentRound = (doc.data()! as Map)["currentRound"];
    }
    return currentRound;
  }

  Future<int> getCurrentPlayer(String roomId) async {
    int currentPlayer = 0;
    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentSnapshot doc = await db.doc("/rooms/$roomId/").get();

    if (doc.exists) {
      currentPlayer = (doc.data()! as Map)["currentPlayer"];
    }
    return currentPlayer;
  }

  Future<List<Object?>> getListOfWords(String roomId) async {
    List<Object?> listOfWords = [];
    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentSnapshot doc = await db.doc("/rooms/$roomId/").get();

    if (doc.exists) {
      listOfWords = ((doc.data()! as Map)["listOfWords"]);
    }
    return listOfWords;
  }

  Future<String> getCurrentWord(String roomId) async {
    String currentWord = "";
    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentSnapshot doc = await db.doc("/rooms/$roomId/").get();

    if (doc.exists) {
      currentWord = (doc.data()! as Map)["currentWord"];
    }
    return currentWord;
  }

  Future<String> getWinner(String roomId) async {
    String winner = "";
    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentSnapshot doc = await db.doc("/rooms/$roomId/").get();

    if (doc.exists) {
      winner = (doc.data()! as Map)["winner"];
    }
    return winner;
  }

  setWord(String roomId, String word) async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    await db.doc("/rooms/$roomId/").update({
      'currentWord': word,
    });
  }

  gameListener(String roomId) {
    FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection("/rooms/$roomId/messages/").snapshots().listen((event) {
      gameBloc..add(GameEventRefresh());
    });
    db.doc("/rooms/$roomId/").snapshots().listen((event) {
      gameBloc..add(GameEventRefresh());
    });
  }

  Future<String> createRoom(Round round, Player player) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentReference roundDoc =
        await db.collection("/rooms/").add(round.toMap()).then((value) async {
      db.collection('${value.path}/messages').add(Message(
              content:
                  "hello players  hada messsage zyada brk lokan mandiroch tsra bug",
              userId: "0",
              username: "Game manager")
          .toMap());
      await db
          .doc('${value.path}/players/${userBloc.user!.user!.uid}')
          .set(player.toMap());
      return value;
    });

    return roundDoc.path.split('/')[1];
  }

  Future<List<Player>> getPlayers(String roomId) async {
    List<Player> players = [];
    FirebaseFirestore db = FirebaseFirestore.instance;
    QuerySnapshot playersSnapshot =
        await db.collection("/rooms/$roomId/players/").get();
    print("/rooms/$roomId/players/");
    for (QueryDocumentSnapshot player in playersSnapshot.docs) {
      if (player.data() != null) {
        players.add(playerFromMap(player.data() as Map));
      }
    }

    return players;
  }

  addPlayerScore(
      String username, String roomId, String playerId, int score) async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    await db.doc("/rooms/$roomId/players/$playerId/").update({
      'nowScore': score,
      'totalScore': gameBloc.totalScore + score,
    });
    await db.doc("/rooms/$roomId/").update({'winner': username});
  }

  nextPlayer(String roomId, int playerIndex) async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    await db.doc("/rooms/$roomId/").update({'currentPlayer': playerIndex});
  }

  nextRound(String roomId, int currentRound) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    await db.doc("/rooms/$roomId/").update({'currentRound': currentRound});
    QuerySnapshot data = await db.collection("/rooms/$roomId/messages/").get();
    for (QueryDocumentSnapshot doc in data.docs) {
      await db.doc("/rooms/$roomId/messages/${doc.id}").delete();
    }
    await addRoundMessage(roomId);
  }

  addMessage(String roomId, String word) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    await db.collection("/rooms/$roomId/messages/").add(Message(
            content: word,
            userId: userBloc.user!.user!.uid,
            username: userBloc.userName ?? "player")
        .toMap());
  }

  addRoundMessage(String roomId) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    await db.collection("/rooms/$roomId/messages/").add(
        Message(content: "new round !", userId: "0", username: "game manager")
            .toMap());
  }

  playersListener(String roomId) {
    FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection("/rooms/$roomId/players/").snapshots().listen((event) {
      roomBloc..add(RoomEventRefresh());
    });

    db.doc("/rooms/$roomId/").snapshots().listen((event) {
      if (event.data()!['gameOn'] as bool) {
        roomBloc..add(RoomEventGameOn());
      }
    });
  }

  startTheGame(String roundId, Round round) {
    FirebaseFirestore db = FirebaseFirestore.instance;
    db.doc("/rooms/$roundId").update(round.gameOn());
  }

  gameEnd(String roomId) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    await db.doc('/rooms/$roomId/').update({"gameOn": false});
  }

  Future<bool> joinRoom(String roomId, Player player) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    try {
      DocumentSnapshot? room =
          await db.collection('/rooms/').doc("$roomId/").get();
      if (!room.exists) {
        roomBloc
          ..add(RoomEventError(
              error: "no room with this code", nextStat: RoomStateJoinRoom()));

        return false;
      } else {
        await db.doc('/rooms/$roomId/players/${player.id}').set(player.toMap());
        return true;
      }
    } on FirebaseException catch (e) {
      roomBloc
        ..add(RoomEventError(
            error: "no room with this code", nextStat: RoomStateJoinRoom()));
      return false;
    }
  }
}
