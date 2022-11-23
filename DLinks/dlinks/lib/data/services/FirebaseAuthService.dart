import 'dart:async';
import 'package:dlinks/data/services/CloudFirestoreService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../utils/error_manager/ErrorLogger.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn =
      GoogleSignIn(signInOption: SignInOption.standard, scopes: [
    'email',
    'https://www.googleapis.com/auth/user.phonenumbers.read',
    'https://www.googleapis.com/auth/user.addresses.read'
  ]);

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
      if (user != null) CloudFirestoreService().createNewAccount(user);
      return user;
    } on FirebaseAuthException catch (e) {
      logError('----------Internal Error: $e');
    }
    return null;
  }

  // Future<String?> createUserWithEmail(String email, String password) async {
  //   try {
  //     await _auth.createUserWithEmailAndPassword(
  //         email: email, password: password);
  //   } catch (e) {
  //     logError('----------Internal Error: $e');
  //     return e.toString();
  //   }
  //   return null;
  // }

  Future<void> signOutFromGoogle() async {
    try {
      await _googleSignIn.disconnect();
      await _auth.signOut();
    } catch (error) {
      logError('----------Internal Error: $error');
    }
  }
}
