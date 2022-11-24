import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String senderUid;
  String receiverUid;

  Timestamp createAt;

  bool isRecallBySender; //
  bool isRecallByReceiver;

  bool isRemoveBySender;

  Message(
      {required this.senderUid,
      required this.receiverUid,
      required this.createAt,
      required this.isRecallBySender,
      required this.isRecallByReceiver,
      required this.isRemoveBySender});

  Map<String, dynamic> toJson() {
    return {
      'senderUid': senderUid,
      'receiverUid': receiverUid,
      'createAt': createAt,
      'isRecallBySender': isRecallBySender,
      'isRecallByReceiver': isRecallByReceiver,
      'isRemoveBySender': isRemoveBySender,
    };
  }

  factory Message.fromMap(Map<String, dynamic> json) => Message(
      senderUid: json['senderUid'],
      receiverUid: json['receiverUid'],
      createAt: json['createAt'],
      isRecallBySender: json['isRecallBySender'],
      isRecallByReceiver: json['isRecallByReceiver'],
      isRemoveBySender: json['isRemoveBySender']);
}