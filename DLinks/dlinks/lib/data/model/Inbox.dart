import 'package:dlinks/data/model/Message.dart';

class Inbox {
  String uid;
  List<Message> yourMessages = [];

  Inbox({required this.uid, required this.yourMessages});

  Map<String, dynamic> toJson() {
    return {'uid': uid, 'messageBox': yourMessages.map((e) => e.toJson()).toList()};
  }
}
