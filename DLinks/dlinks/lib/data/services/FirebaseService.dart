import 'dart:async';

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
    logWarning("---------Create new chat user.");
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
        content: 'This is a message. Thanks.');
    userInbox.messageBox
      ..add(firstMessage)
      ..add(secondMessage);
    await firebaseFirestore
        .collection('Inbox')
        .doc(user.uid)
        .set(userInbox.toJson())
        .catchError((error, stackTrace) async {
      logError('----------Internal Error: $error');
    });
    debugPrint('Created inbox');
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
    debugPrint(result.length.toString());
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
  Future<List<Message>> getAllMessagesForUser(
      String receiverUid, String senderUid) async {
    Inbox? inbox;
    await FirebaseFirestore.instance
        .collection('Inbox')
        .doc('uid')
        .get()
        .then((value) {
      inbox = Inbox.fromMap(value.data()!);
      print(value.data());
    });
    return inbox != null ? inbox!.messageBox : [];
  }

  Future<List<ChatUser>> getAllUserChatWithMe(String receiverUid) async {
    List<ChatUser> result = [];
    await FirebaseFirestore.instance
        .collection('Inbox')
        .doc(receiverUid)
        .get()
        .then((value) async {
      debugPrint(value.data().toString());
      for (var i in Inbox.fromMap(value.data()!).messageBox) {
        var j = await getChatUserByUid(i.senderUid);
        if (j != null) result.add(j);
      }
    }, onError: (error) {
      logError('----------Internal Error: $error');
    });
    return result;
  }
}
