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

  Future<User?> handleSignIn() async {
    try {
      user = await firebaseService.signInWithGoogle();
      if (user != null) {
        return user;
      } else {
        return null;
      }
    } catch (error) {
      logError('----------Internal Error: $error');
      return null;
    }
  }

  Future<bool> handleSignOut() async {
    try {
      await firebaseService.signOutFromGoogle();
      return true;
    } catch (error) {
      logError('----------Internal Error: $error');
      return false;
    }
  }
}
