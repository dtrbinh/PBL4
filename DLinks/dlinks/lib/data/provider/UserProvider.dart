import 'package:flutter/material.dart';

import 'AuthProvider.dart';
import '../repository/UserRepository.dart';

class UserProvider extends ChangeNotifier{
  final UserRepository userRepository = UserRepository.instance;
  final AuthProvider authProvider = AuthProvider.instance;
}