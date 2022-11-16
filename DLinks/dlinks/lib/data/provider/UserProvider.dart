import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'AuthProvider.dart';
import '../repository/UserRepository.dart';

class UserProvider extends GetxController{
  final Rx<UserRepository> userRepository = UserRepository.instance.obs;
  final Rx<AuthProvider> authProvider = AuthProvider.instance.obs;
}