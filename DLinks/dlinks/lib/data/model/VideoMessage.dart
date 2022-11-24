import 'Message.dart';

class VideoMessage extends Message {
  String videoUrl;

  VideoMessage(
      {required super.senderUid,
        required super.receiverUid,
        required super.createAt,
        required super.isRecallBySender,
        required super.isRecallByReceiver,
        required super.isRemoveBySender,
        required this.videoUrl});

  @override
  Map<String, dynamic> toJson() {
    return {
      'senderUid': super.senderUid,
      'receiverUid': super.receiverUid,
      'createAt': super.createAt,
      'isRecallBySender': super.isRecallBySender,
      'isRecallByReceiver': super.isRecallByReceiver,
      'isRemoveBySender': super.isRemoveBySender,
      'videoUrl': videoUrl,
    };
  }
  factory VideoMessage.fromMap(Map<String, dynamic> json) => VideoMessage(
      senderUid: json['senderUid'],
      receiverUid: json['receiverUid'],
      createAt: json['createAt'],
      isRecallBySender: json['isRecallBySender'],
      isRecallByReceiver: json['isRecallByReceiver'],
      isRemoveBySender: json['isRemoveBySender'],
      videoUrl: json['videoUrl']);
@override
  String toString() {
    // TODO: implement toString
    return 'Đã gửi một video';
  }
}