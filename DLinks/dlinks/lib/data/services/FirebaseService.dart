import 'dart:async';
import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dlinks/data/model/ChatUser.dart';
import 'package:dlinks/data/model/Message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../model/Inbox.dart';
import 'error_manager/ErrorLogger.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      await _auth.signInWithCredential(credential);
      var user = FirebaseAuth.instance.currentUser;
      if (user != null) createNewAccount(user);
      return user;
    } on FirebaseAuthException catch (e) {
      logError('----------Internal Error: $e');
    }
    return null;
  }

  Future<String?> createUserWithEmail(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      logError('----------Internal Error: $e');
      return e.toString();
    }
    return null;
  }

  Future<void> signOutFromGoogle() async {
    try {
      await _googleSignIn.disconnect();
      await _auth.signOut();
    } catch (error) {
      logError('----------Internal Error: $error');
    }
  }

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
    await firebaseFirestore
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
        senderUid: '00000',
        receiverUid: user.uid,
        createAt: Timestamp.now(),
        isRecallBySender: false,
        isRecallByReceiver: false,
        isRemoveBySender: false,
        content: 'Hello my friend.');
    TextMessage devMessage2 = TextMessage(
        senderUid: '00000',
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
    await firebaseFirestore
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

  // -----MESSAGES REGION
  Future<Inbox?> getAllMessagesForUser(String receiverUid) async {
    Inbox? inbox;
    await FirebaseFirestore.instance
        .collection('Inbox')
        .doc(receiverUid)
        .get()
        .then((value) {
      inbox = Inbox.fromMap(value.data()!);
    });
    return (inbox != null) ? inbox : null; // select distinct
  }

  Future<List<ChatUser>> getAllUserChatWithMe(String receiverUid) async {
    List<ChatUser> result = [];
    await FirebaseFirestore.instance
        .collection('Inbox')
        .doc(receiverUid)
        .get()
        .then((value) async {
      // debugPrint(value.data().toString());
      for (Message i in Inbox.fromMap(value.data()!).messageBox) {
        var j = await getChatUserByUid(i.senderUid);
        if (j != null) {
          if (result
              .where((element) => element.uid == j.uid)
              .toList()
              .isEmpty) {
            result.add(j);
          }
        }
      }
    }, onError: (error) {
      logError('----------Internal Error: $error');
    });
    return result;
  }
}
