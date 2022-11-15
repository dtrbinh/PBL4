import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';

class ChatUser {
  String uid;
  String? phoneNumber;
  String? email;
  String? displayName;
  String? photoURL;

  ChatUser(
      {required this.uid,
      this.phoneNumber,
      this.email,
      this.displayName,
      this.photoURL});

  static ChatUser fromUser(User user) {
    return ChatUser(
        uid: user.uid,
        phoneNumber: user.phoneNumber,
        email: user.email,
        displayName: user.displayName,
        photoURL: user.photoURL);
  }

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "phoneNumber": phoneNumber,
      "email": email,
      "displayName": displayName,
      "photoURL": photoURL,
    };
  }

  factory ChatUser.fromJson(String str) => ChatUser.fromMap(json.decode(str));

  factory ChatUser.fromMap(Map<String, dynamic> json) => ChatUser(
        photoURL: json["photoURL"],
        uid: json["uid"],
        phoneNumber: json["phoneNumber"],
        displayName: json["displayName"],
        email: json["email"],
      );
}
