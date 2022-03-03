import 'package:cloud_firestore/cloud_firestore.dart';

class Round {
  String creatorId;
  int roundsNumber;
  String? winner;
  Round({required this.creatorId, required this.roundsNumber});
  Map<String, Object?> toMap() {
    return {
      "creatorId": creatorId,
      "roundsNumber": roundsNumber,
      "gameOn": false,
      "currentRound": 1,
      "currentPlayer": 0,
      "listOfWords": ["h", "h", "h"],
      "currentWord": "",
      "winner": "",
      "timeBegin": null,
    };
  }

  Map<String, Object?> gameOn() {
    return {
      "creatorId": creatorId,
      "roundsNumber": roundsNumber,
      "gameOn": true,
      "currentRound": 1,
      "currentPlayer": 0,
      "listOfWords": ["h", "h", "h"],
      "currentWord": "",
      "winner": "",
      "timeBegin": null,
    };
  }
}
