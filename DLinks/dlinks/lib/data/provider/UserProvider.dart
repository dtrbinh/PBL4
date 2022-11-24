
import 'package:firebase_auth/firebase_auth.dart';

class UserProvider{
  UserProvider._internal();
  static final UserProvider instance = UserProvider._internal();
// ---------------
  User? currentUser;
  void logoutCurrentUser() {
    currentUser = null;
  }
}