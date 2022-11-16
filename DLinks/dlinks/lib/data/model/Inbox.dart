import 'dart:convert';

import 'package:dlinks/data/model/Message.dart';
import 'package:flutter/material.dart';

class Inbox {
  Inbox({
    required this.uid,
    required this.messageBox,
  });

  String uid;
  List<Message> messageBox;

    Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'messageBox': messageBox.map((e) => e.toJson()).toList()
    };
  }

  factory Inbox.fromJson(String str) => Inbox.fromMap(json.decode(str));

  factory Inbox.fromMap(Map<String, dynamic> json) => Inbox(
    uid: json["uid"],
    messageBox: List<Message>.from(json["messageBox"].map((x) => Message.fromMap(x))),
  );
}

// class Inbox {
//   String uid;
//   List<Message> messageBox = [];
//
//   Inbox({required this.uid, required this.messageBox});
//
//   Map<String, dynamic> toJson() {
//     return {
//       'uid': uid,
//       'messageBox': messageBox.map((e) => e.toJson()).toList()
//     };
//   }
//
//   factory Inbox.fromMap(Map<String, dynamic> json) => Inbox(
//       uid: json["uid"],
//       messageBox: List<Message>.from(json["messageBox"].map((x) {
//         debugPrint(json["messageBox"]);
//         if (x.containsKey('content')) TextMessage.fromMap(x);
//         if (x.containsKey('imageUrl')) ImageMessage.fromMap(x);
//         // if (x.containsKey('audioUrl')) AudioMessage.fromMap(x);
//         // if (x.containsKey('fileUrl')) FileMessage.fromMap(x);
//       })));
// }
