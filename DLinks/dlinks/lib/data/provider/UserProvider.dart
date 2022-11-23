import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/AuthService.dart';
import '../repository/UserRepository.dart';


class UserProvider extends GetxController{
  final Rx<UserRepository> userRepository = UserRepository.instance.obs;

  final Rx<AuthService> authService = AuthService.instance.obs;

}