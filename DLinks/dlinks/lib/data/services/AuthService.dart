import 'package:firebase_auth/firebase_auth.dart';

import 'FirebaseAuthService.dart';
import '../../utils/error_manager/ErrorLogger.dart';

class AuthService {
  //singleton instance
  AuthService._internal();
  static final AuthService instance = AuthService._internal();
  // ------------------
  FirebaseAuthService firebaseService = FirebaseAuthService();
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
