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
    DocumentSnapshot messagesDoc =
        await db.collection("/rooms/$roomId/").doc('messages').get();

    if (messagesDoc.exists) {
      for (Map message in (messagesDoc.data() as List)) {
        messages.add(messageFromMap(message));
      }
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

  Future<List<String>> getListOfWords(String roomId) async {
    List<String> listOfWords = [];
    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentSnapshot doc = await db.doc("/rooms/$roomId/").get();

    if (doc.exists) {
      listOfWords = (doc.data()! as Map)["listOfWords"];
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
      return await db.collection('${value.path}/players').add(player.toMap());
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
        await db.collection('/rooms/$roomId/players/').add(player.toMap());
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
