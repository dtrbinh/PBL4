import 'dart:convert';

import 'AudioMessage.dart';
import 'FileMessage.dart';
import 'ImageMessage.dart';
import 'TextMessage.dart';
import 'VideoMessage.dart';

class Inbox {
  Inbox({
    required this.uid,
    required this.messageBox,
  });

  String uid;
  List<dynamic> messageBox;

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'messageBox': messageBox.map((e) {
        if (e is TextMessage) {
          return e.toJson();
        } else if (e is ImageMessage) {
          return e.toJson();
        } else if (e is VideoMessage) {
          return e.toJson();
        } else if (e is AudioMessage) {
          return e.toJson();
        } else if (e is FileMessage) {
          return e.toJson();
        } else {
          return e.toJson();
        }
        // =>e.toJson()
      }).toList()
    };
  }

  factory Inbox.fromJson(String str) => Inbox.fromMap(json.decode(str));

  factory Inbox.fromMap(Map<String, dynamic> json) => Inbox(
        uid: json["uid"],
        messageBox: List.from(json["messageBox"].map((x) {
          if (x.containsKey('content')) {
            return TextMessage.fromMap(x);
          }
          if (x.containsKey('imageUrl')) {
            return ImageMessage.fromMap(x);
          }
          if (x.containsKey('audioUrl')) {
            return AudioMessage.fromMap(x);
          }
          if (x.containsKey('fileUrl')) {
            return FileMessage.fromMap(x);
          }
          if (x.containsKey('videoUrl')) {
            return VideoMessage.fromMap(x);
          }
        })),
      );
}

