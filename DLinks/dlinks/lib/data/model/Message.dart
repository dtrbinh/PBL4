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

class TextMessage extends Message {
  String content;

  TextMessage(
      {required super.senderUid,
      required super.receiverUid,
      required super.createAt,
      required super.isRecallBySender,
      required super.isRecallByReceiver,
      required super.isRemoveBySender,
      required this.content});

  @override
  Map<String, dynamic> toJson() {
    return {
      'senderUid': super.senderUid,
      'receiverUid': super.receiverUid,
      'createAt': super.createAt,
      'isRecallBySender': super.isRecallBySender,
      'isRecallByReceiver': super.isRecallByReceiver,
      'isRemoveBySender': super.isRemoveBySender,
      'content': content,
    };
  }

  factory TextMessage.fromMap(Map<String, dynamic> json) => TextMessage(
      senderUid: json['senderUid'],
      receiverUid: json['receiverUid'],
      createAt: json['createAt'],
      isRecallBySender: json['isRecallBySender'],
      isRecallByReceiver: json['isRecallByReceiver'],
      isRemoveBySender: json['isRemoveBySender'],
      content: json['content']);
}

class ImageMessage extends Message {
  String imageUrl;

  ImageMessage(
      {required super.senderUid,
      required super.receiverUid,
      required super.createAt,
      required super.isRecallBySender,
      required super.isRecallByReceiver,
      required super.isRemoveBySender,
      required this.imageUrl});

  @override
  Map<String, dynamic> toJson() {
    return {
      'senderUid': super.senderUid,
      'receiverUid': super.receiverUid,
      'createAt': super.createAt,
      'isRecallBySender': super.isRecallBySender,
      'isRecallByReceiver': super.isRecallByReceiver,
      'isRemoveBySender': super.isRemoveBySender,
      'imageUrl': imageUrl,
    };
  }

  factory ImageMessage.fromMap(Map<String, dynamic> json) => ImageMessage(
      senderUid: json['senderUid'],
      receiverUid: json['receiverUid'],
      createAt: json['createAt'],
      isRecallBySender: json['isRecallBySender'],
      isRecallByReceiver: json['isRecallByReceiver'],
      isRemoveBySender: json['isRemoveBySender'],
      imageUrl: json['imageUrl']);
}

class AudioMessage extends Message {
  String audioUrl;
  AudioMessage(
      {required super.senderUid,
      required super.receiverUid,
      required super.createAt,
      required super.isRecallBySender,
      required super.isRecallByReceiver,
      required super.isRemoveBySender,
      required this.audioUrl});

  @override
  Map<String, dynamic> toJson() {
    return {
      'senderUid': super.senderUid,
      'receiverUid': super.receiverUid,
      'createAt': super.createAt,
      'isRecallBySender': super.isRecallBySender,
      'isRecallByReceiver': super.isRecallByReceiver,
      'isRemoveBySender': super.isRemoveBySender,
      'audioUrl': audioUrl,
    };
  }
}

class FileMessage extends Message {
  String fileUrl;

  FileMessage(
      {required super.senderUid,
      required super.receiverUid,
      required super.createAt,
      required super.isRecallBySender,
      required super.isRecallByReceiver,
      required super.isRemoveBySender,
      required this.fileUrl});

  @override
  Map<String, dynamic> toJson() {
    return {
      'senderUid': super.senderUid,
      'receiverUid': super.receiverUid,
      'createAt': super.createAt,
      'isRecallBySender': super.isRecallBySender,
      'isRecallByReceiver': super.isRecallByReceiver,
      'isRemoveBySender': super.isRemoveBySender,
      'fileUrl': fileUrl,
    };
  }
}
