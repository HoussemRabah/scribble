class Player {
  String name;
  String avatar;
  String id;
  int nowScore = 0;
  int totalScore = 0;
  Player(
      {required this.name,
      required this.avatar,
      required this.id,
      required this.nowScore,
      required this.totalScore});
  Map<String, Object> toMap() {
    return {
      "name": name,
      "avatar": avatar,
      "id": id,
      "nowScore": nowScore,
      "totalScore": totalScore
    };
  }
}

Player playerFromMap(Map map) {
  return Player(
      name: map["name"],
      avatar: map["avatar"],
      id: map['id'],
      totalScore: map['totalScore'],
      nowScore: map['nowScore']);
}
