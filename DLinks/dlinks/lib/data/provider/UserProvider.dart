import 'package:flutter/material.dart';

import '../repository/AccountRepository.dart';
import '../repository/UserRepository.dart';

class UserProvider extends ChangeNotifier{
  final UserRepository userRepository = UserRepository.instance;
  final AccountRepository accountRepository = AccountRepository.instance;

}