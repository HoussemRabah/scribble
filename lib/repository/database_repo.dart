import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scribble/module/player.dart';
import 'package:scribble/module/round.dart';

class DatabaseRepository {
  Future<String> createRoom(Round round, Player player) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentReference roundDoc =
        await db.collection("/rooms/").add(round.toMap()).then((value) async {
      return await db
          .collection('/rooms/${value.id}/players')
          .add(player.toMap());
    });

    return roundDoc.id;
  }
}
