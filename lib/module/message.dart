import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String content;
  String userId;
  String username;
  Timestamp? createdAt = Timestamp.now();
  Message(
      {required this.content,
      required this.userId,
      required this.username,
      this.createdAt});

  toMap() {
    return {
      "content": content,
      "userId": userId,
      "username": username,
      "createdAt": Timestamp.now(),
    };
  }
}

Message messageFromMap(Map map) {
  return Message(
    content: map["content"],
    userId: map["userId"],
    username: map["username"],
    createdAt: map["createdAt"],
  );
}
