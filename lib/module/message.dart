class Message {
  String content;
  String userId;
  String username;
  Message(
      {required this.content, required this.userId, required this.username});

  toMap() {
    return {"content": content, "userId": userId, "username": username};
  }
}

Message messageFromMap(Map map) {
  return Message(
      content: map["content"],
      userId: map["userId"],
      username: map["username"]);
}
