import 'dart:core';

class Message {
  String senderUid;
  String receiverUid;

  DateTime createAt = DateTime.now();

  bool isRecallBySender; //
  bool isRecallByReceiver;

  bool isRemoveBySender;

  Message(this.senderUid, this.receiverUid, this.createAt,
      this.isRecallBySender, this.isRecallByReceiver, this.isRemoveBySender);

  Map<String, dynamic> toJson(){
    return {
      'senderUid': senderUid,
      'receiverUid': receiverUid,
      'createAt': createAt,
      'isRecallBySender': isRecallBySender,
      'isRecallByReceiver': isRecallByReceiver,
      'isRemoveBySender': isRemoveBySender,
    };
  }
}

class TextMessage extends Message {
  String content;

  TextMessage(
      super.senderUid,
      super.receiverUid,
      super.createAt,
      super.isRecallBySender,
      super.isRecallByReceiver,
      super.isRemoveBySender,
      this.content);

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
}

class ImageMessage extends Message {
  String imageUrl;

  ImageMessage(
      super.senderUid,
      super.receiverUid,
      super.createAt,
      super.isRecallBySender,
      super.isRecallByReceiver,
      super.isRemoveBySender,
      this.imageUrl);

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
}

class AudioMessage extends Message {
  String audioUrl;

  AudioMessage(
      super.senderUid,
      super.receiverUid,
      super.createAt,
      super.isRecallBySender,
      super.isRecallByReceiver,
      super.isRemoveBySender,
      this.audioUrl);

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
      super.senderUid,
      super.receiverUid,
      super.createAt,
      super.isRecallBySender,
      super.isRecallByReceiver,
      super.isRemoveBySender,
      this.fileUrl);

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
