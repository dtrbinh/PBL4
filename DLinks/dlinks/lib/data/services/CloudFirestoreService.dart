import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/ChatUser.dart';
import '../model/Inbox.dart';
import '../model/Message.dart';
import '../../utils/error_manager/ErrorLogger.dart';

class CloudFirestoreService {
  //-----CHAT USERS REGION

  Future<void> createNewAccount(User user) async {
    bool isExist = false;
    await FirebaseFirestore.instance
        .collection('ChatUsers')
        .where("uid", isEqualTo: user.uid)
        .get()
        .then((value) {
      if (value.size == 0) {
        isExist = false;
      } else {
        isExist = true;
      }
    });
    if (!isExist) {
      logWarning("---------Users not exist.");
      createChatUser(user);
      createInbox(user);
    } else {
      logWarning("---------User already exist, not create new.");
    }
  }

  Future<void> createChatUser(User user) async {
    ChatUser chatUser = ChatUser.fromUser(user);

    await FirebaseFirestore.instance
        .collection('ChatUsers')
        .doc(chatUser.uid)
        .set(chatUser.toJson())
        .catchError((error, stackTrace) async {
      logError('----------Internal Error: $error');
    });
    logWarning("---------Created new chat user.");
  }

  Future<void> createInbox(User user) async {
    Inbox userInbox = Inbox(uid: user.uid, messageBox: []);
    TextMessage firstMessage = TextMessage(
        senderUid: '00000',
        receiverUid: user.uid,
        createAt: Timestamp.now(),
        isRecallBySender: false,
        isRecallByReceiver: false,
        isRemoveBySender: false,
        content: 'Welcome to DLinks. An application for send messages.');
    TextMessage secondMessage = TextMessage(
        senderUid: '00000',
        receiverUid: user.uid,
        createAt: Timestamp.now(),
        isRecallBySender: false,
        isRecallByReceiver: false,
        isRemoveBySender: false,
        content:
            'This is demo 5 types of message: Text, Audio, Image, Video, File.');
    ImageMessage imageMessage = ImageMessage(
        senderUid: '00000',
        receiverUid: user.uid,
        createAt: Timestamp.now(),
        isRecallBySender: false,
        isRecallByReceiver: false,
        isRemoveBySender: false,
        imageUrl: 'https://picsum.photos/200/300');
    AudioMessage audioMessage = AudioMessage(
        senderUid: '00000',
        receiverUid: user.uid,
        createAt: Timestamp.now(),
        isRecallBySender: false,
        isRecallByReceiver: false,
        isRemoveBySender: false,
        audioUrl:
            'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3');
    FileMessage fileMessage = FileMessage(
        senderUid: '00000',
        receiverUid: user.uid,
        createAt: Timestamp.now(),
        isRecallBySender: false,
        isRecallByReceiver: false,
        isRemoveBySender: false,
        fileUrl:
            'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf');
    VideoMessage videoMessage = VideoMessage(
        senderUid: '00000',
        receiverUid: user.uid,
        createAt: Timestamp.now(),
        isRecallBySender: false,
        isRecallByReceiver: false,
        isRemoveBySender: false,
        videoUrl:
            'https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4');

    TextMessage devMessage1 = TextMessage(
        senderUid: '11111',
        receiverUid: user.uid,
        createAt: Timestamp.now(),
        isRecallBySender: false,
        isRecallByReceiver: false,
        isRemoveBySender: false,
        content: 'Hello my friend.');
    TextMessage devMessage2 = TextMessage(
        senderUid: '11111',
        receiverUid: user.uid,
        createAt: Timestamp.now(),
        isRecallBySender: false,
        isRecallByReceiver: false,
        isRemoveBySender: false,
        content: 'Many thanks for your choice using DLinks');
    userInbox.messageBox
      ..add(firstMessage)
      ..add(secondMessage)
      ..add(imageMessage)
      ..add(audioMessage)
      ..add(fileMessage)
      ..add(videoMessage)
      ..add(devMessage1)
      ..add(devMessage2);
    await FirebaseFirestore.instance
        .collection('Inbox')
        .doc(user.uid)
        .set(userInbox.toJson())
        .catchError((error, stackTrace) async {
      logError('----------Internal Error: $error');
    });
    logWarning('----------Created inbox.');
  }

  Future<List<ChatUser>> getAllChatUser() async {
    List<ChatUser> result = [];
    await FirebaseFirestore.instance.collection("ChatUsers").get().then(
        (value) {
      for (var e in value.docs.map((e) => e.data()).toList()) {
        result.add(ChatUser.fromMap(e));
      }
    }, onError: (error) {
      logError('----------Internal Error: $error');
    });
    return result;
  }

  List<ChatUser>? searchChatUserByKeyWord(String keyword) {}

  Future<ChatUser?> getChatUserByUid(String uid) async {
    ChatUser? result;
    await FirebaseFirestore.instance
        .collection('ChatUsers')
        .where("uid", isEqualTo: uid)
        .get()
        .then((value) {
      if (value.size == 0) {
        result = null;
      } else {
        result = ChatUser.fromMap(value.docs.first.data());
      }
    });
    return result;
  }

  // -----MESSAGES FUNCTION REGION
  Future<List?> getAllMessagesForCurrentDialog(
      String myUid, String theirUid) async {
    Inbox? inbox;
    await FirebaseFirestore.instance
        .collection('Inbox')
        .doc(myUid)
        .get()
        .then((value) {
      inbox = Inbox.fromMap(value.data() ?? {});
    });
    var temp = [];
    for (Message i in inbox!.messageBox) {
      if (i.senderUid == myUid && i.receiverUid == theirUid) {
        temp.add(i);
      } else if (i.senderUid == theirUid && i.receiverUid == myUid) {
        temp.add(i);
      }
    }
    return temp; // select distinct
  }

  Future<Stream<DocumentSnapshot<Map<String, dynamic>>>> getMessageStream(
      String receiverUid) async {
    return FirebaseFirestore.instance
        .collection('Inbox')
        .doc(receiverUid)
        .snapshots();
  }

  Future<List<ChatUser>> getAllChatDialog(String myUid) async {
    List<ChatUser> result = [];
    await FirebaseFirestore.instance.collection('Inbox').doc(myUid).get().then(
        (value) async {
      // debugPrint(value.data().toString());
      for (Message i in Inbox.fromMap(value.data() ?? {}).messageBox) {
        // debugPrint('Message from ${i.senderUid}');
        var sender = await getChatUserByUid(i.senderUid);
        if (sender != null) {
          if (result
              .where((element) => element.uid == sender.uid)
              .toList()
              .isEmpty) {
            // logWarning('Chat with ${sender.displayName}');
            result.add(sender);
          } else {
            // logWarning('This chat user exist: ${sender.displayName}');
          }
        } else {
          logError(
              '----------Internal Error: Not exist user with id ${i.senderUid}.');
        }

        var receiver = await getChatUserByUid(i.receiverUid);
        if (receiver != null) {
          if (result
              .where((element) => element.uid == receiver.uid)
              .toList()
              .isEmpty) {
            logWarning('Chat with ${receiver.displayName}');
            result.add(receiver);
          } else {
            // logWarning('This chat user exist: ${receiver.displayName}');
          }
        } else {
          logError(
              '----------Internal Error: Not exist user with id ${i.senderUid}.');
        }
      }
    }, onError: (error) {
      logError('----------Internal Error: $error');
    });
    return result;
  }

  Future<bool> sendTextMessage(TextMessage txtMessage) async {
    try {
      //add message vào ib người gửi
      await FirebaseFirestore.instance
          .collection('Inbox')
          .doc(txtMessage.senderUid)
          .update({
        'messageBox': FieldValue.arrayUnion([txtMessage.toJson()])
      });

      //add message vào ib người nhận
      await FirebaseFirestore.instance
          .collection('Inbox')
          .doc(txtMessage.receiverUid)
          .update({
        'messageBox': FieldValue.arrayUnion([txtMessage.toJson()])
      });
    } catch (error) {
      return false;
    }
    return true;
  }
}
