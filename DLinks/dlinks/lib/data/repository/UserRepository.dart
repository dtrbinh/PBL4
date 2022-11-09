
import 'package:firebase_auth/firebase_auth.dart';

class UserRepository{
  UserRepository._internal();
  static final UserRepository instance = UserRepository._internal();

  User? currentUser;

  void reset() {
    currentUser = null;
  }

}