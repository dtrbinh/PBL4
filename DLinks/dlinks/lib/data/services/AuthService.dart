import 'package:dlinks/data/services/CloudFirestoreService.dart';
import 'package:dlinks/data/services/LocalCacheService.dart';
import 'package:dlinks/utils/CallbackFunction.dart';
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
      if (_user != null) {
        // logWarning('----------AuthService: User is write to cache.');
        LocalCacheService.setBool('isLogin', true);
        LocalCacheService.setString('myUid', _user!.uid);
        // await setChatUserOnline();
      } else {
        // logWarning('----------AuthService: User is null');
        LocalCacheService.setBool('isLogin', false);
      }
    } catch (error) {
      logError('----------Internal Error: $error');
      _user = null;
    }
    return _user;
  }

  Future<bool> handleSignOut() async {
    bool isSignOut = false;
    try {
      await setChatUserOffline();
      await firebaseService.signOutFromGoogle();
      isSignOut = true;
    } catch (error) {
      logError('----------Internal Error: $error');
      isSignOut = false;
    }
    if (isSignOut) {
      LocalCacheService.setBool('isLogin', false);
      LocalCacheService.setBool('status', false);
      LocalCacheService.remove('myUid');
    }
    return isSignOut;
  }
}
