import 'Message.dart';

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
  @override
  String toString() {
    return content;
  }
}