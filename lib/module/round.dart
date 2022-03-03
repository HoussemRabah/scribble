class Round {
  String creatorId;
  int roundsNumber;
  Round({required this.creatorId, required this.roundsNumber});
  Map<String, Object?> toMap() {
    return {
      "creatorId": creatorId,
      "roundsNumber": roundsNumber,
      "gameOn": false,
      "currentRound": creatorId,
      "currentPlayer": 0,
      "listOfWords": ["h", "h", "h"],
      "currentWord": "",
    };
  }

  Map<String, Object?> gameOn() {
    return {
      "creatorId": creatorId,
      "roundsNumber": roundsNumber,
      "gameOn": true,
      "currentRound": creatorId,
      "currentPlayer": 0,
      "listOfWords": ["h", "h", "h"],
      "currentWord": "",
    };
  }
}
