class Player {
  String name;
  String avatar;
  String id;
  Player({required this.name, required this.avatar, required this.id});
  Map<String, Object> toMap() {
    return {"name": name, "avatar": avatar, "id": id};
  }
}

Player playerFromMap(Map map) {
  return Player(name: map["name"], avatar: map["avatar"], id: map['id']);
}
