import 'Message.dart';

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
  factory FileMessage.fromMap(Map<String, dynamic> json) => FileMessage(
      senderUid: json['senderUid'],
      receiverUid: json['receiverUid'],
      createAt: json['createAt'],
      isRecallBySender: json['isRecallBySender'],
      isRecallByReceiver: json['isRecallByReceiver'],
      isRemoveBySender: json['isRemoveBySender'],
      fileUrl: json['fileUrl']);
@override
  String toString() {
    // TODO: implement toString
    return 'Đã gửi một file';
  }
}