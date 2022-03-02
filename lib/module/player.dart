class Player {
  String name;
  String avatar;
  Player({required this.name, required this.avatar});
  Map<String, Object> toMap() {
    return {
      "name": name,
      "avatar": avatar,
    };
  }
}
