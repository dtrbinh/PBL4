import 'Message.dart';

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

  factory AudioMessage.fromMap(Map<String, dynamic> json) => AudioMessage(
      senderUid: json['senderUid'],
      receiverUid: json['receiverUid'],
      createAt: json['createAt'],
      isRecallBySender: json['isRecallBySender'],
      isRecallByReceiver: json['isRecallByReceiver'],
      isRemoveBySender: json['isRemoveBySender'],
      audioUrl: json['audioUrl']);

  @override
  String toString() {
    // TODO: implement toString
    return 'Đã gửi một tin nhắn âm thanh';
  }
}