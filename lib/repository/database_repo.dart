import 'package:cloud_firestore/cloud_firestore.dart';
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
}
