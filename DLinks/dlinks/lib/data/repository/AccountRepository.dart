import 'package:firebase_auth/firebase_auth.dart';

import '../services/FirebaseService.dart';
import '../services/error_manager/ErrorLogger.dart';

class AccountRepository {
  //singleton instance
  AccountRepository._internal();
  static final AccountRepository instance = AccountRepository._internal();
  // ------------------

  User? user;
  FirebaseService firebaseService = FirebaseService();

  AccountRepository() {
    user = FirebaseAuth.instance.currentUser;
  }

  Future<bool> handleSignIn() async {
    try {
      user = await firebaseService.signInWithGoogle();
      if (user != null) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      logError('----------Internal Error: $error');
      return false;
    }
  }

  Future<bool> handleSignOut() async {
    try {
      // googleSignIn.disconnect();
      await firebaseService.signOutFromGoogle();
      return true;
    } catch (error) {
      logError('----------Internal Error: $error');
      return false;
    }
  }
}
