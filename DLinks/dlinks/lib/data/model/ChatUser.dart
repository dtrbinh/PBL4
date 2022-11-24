import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatUser {
  String uid;
  String? phoneNumber;
  String? email;
  String? displayName;
  String? photoURL;

  bool? status;
  Timestamp? lastSeen;
  Timestamp? createdAt;

  ChatUser({
    required this.uid,
    this.phoneNumber,
    this.email,
    this.displayName,
    this.photoURL,
    this.status,
    this.lastSeen,
    this.createdAt,
  });

  static ChatUser fromUser(User user) {
    return ChatUser(
        uid: user.uid,
        phoneNumber: user.phoneNumber,
        email: user.email,
        displayName: user.displayName,
        photoURL: user.photoURL,
        status: false,
        lastSeen: Timestamp.now(),
        createdAt: Timestamp.now()
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "phoneNumber": phoneNumber,
      "email": email,
      "displayName": displayName,
      "photoURL": photoURL,
      "status": status,
      "lastSeen": lastSeen,
      "createdAt": createdAt,
    };
  }

  factory ChatUser.fromJson(String str) => ChatUser.fromMap(json.decode(str));

  factory ChatUser.fromMap(Map<String, dynamic> json) => ChatUser(
        photoURL: json["photoURL"],
        uid: json["uid"],
        phoneNumber: json["phoneNumber"],
        displayName: json["displayName"],
        email: json["email"],
        status: json["status"],
        lastSeen: json["lastSeen"],
        createdAt: json["createdAt"],
      );
}

