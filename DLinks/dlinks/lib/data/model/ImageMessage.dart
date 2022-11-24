import 'Message.dart';

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

  @override
  String toString() {
    // TODO: implement toString
    return 'Đã gửi một hình ảnh';
  }
}