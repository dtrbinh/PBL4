import 'package:firebase_auth/firebase_auth.dart';

import '../services/FirebaseService.dart';
import '../services/error_manager/ErrorLogger.dart';

class AuthProvider {
  //singleton instance
  AuthProvider._internal();
  static final AuthProvider instance = AuthProvider._internal();
  // ------------------
  FirebaseService firebaseService = FirebaseService();
  Future<User?> handleSignIn() async {
    User? _user;
    try {
      await firebaseService.signInWithGoogle().then((user) {
        if (user != null) {
          _user = user;
        } else {
          _user = null;
        }
      });
    } catch (error) {
      logError('----------Internal Error: $error');
      _user = null;
    }
    return _user;
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
