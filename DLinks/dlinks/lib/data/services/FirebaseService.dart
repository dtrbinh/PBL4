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
      createChatUser(user!);
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

  Future<void> createNewAccount(User user) async {
    bool isExist = false;
    await FirebaseFirestore.instance
        .collection('ChatUsers')
        .where("uid", isEqualTo: user.uid)
        .get()
        .then((value) {
      if (value.docs.first.data().isEmpty) {
        isExist = false;
      } else {
        isExist = true;
      }
    });
    if (!isExist) {
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
  }

  Future<void> createInbox(User user) async {
    Inbox userInbox = Inbox(uid: user.uid, yourMessages: []);
    TextMessage firstMessage = TextMessage(
        '00000',
        '00000',
        DateTime.now(),
        false,
        false,
        false,
        'Welcome to DLinks. An application for send messages.');
    userInbox.yourMessages.add(firstMessage);
    await firebaseFirestore
        .collection('Inbox')
        .doc(user.uid)
        .set(userInbox.toJson())
        .catchError((error, stackTrace) async {
      logError('----------Internal Error: $error');
    });
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

  ChatUser? searchChatUserByUid(String uid) {
    return null;
  }
}
