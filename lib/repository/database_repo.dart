import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scribble/UI/pages/home.dart';
import 'package:scribble/bloc/roomBloc/room_bloc.dart';
import 'package:scribble/module/player.dart';
import 'package:scribble/module/round.dart';

class DatabaseRepository {
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
