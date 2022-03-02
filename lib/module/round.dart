class Round {
  String creatorId;
  int roundsNumber;
  Round({required this.creatorId, required this.roundsNumber});
  Map<String, Object?> toMap() {
    return {"creatorId": creatorId, "roundsNumber": roundsNumber};
  }
}
