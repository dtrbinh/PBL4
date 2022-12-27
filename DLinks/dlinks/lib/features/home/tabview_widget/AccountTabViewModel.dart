import 'package:dlinks/data/repository/UserRepository.dart';
import 'package:dlinks/utils/RouteManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

class AccountTabViewModel extends GetxController {
  UserRepository c = Get.find<UserRepository>();

  Future<void> logout() async {
    c.userProvider.value.logoutCurrentUser();
    c.authService.value.handleSignOut().then((value) {
      value
          ? Future.delayed(const Duration(milliseconds: 300), () {
              Get.back();
              Get.offAllNamed(AppRoute.signin);
            })
          : Get.showSnackbar(const GetSnackBar(
              message: 'Logout failed',
              duration: Duration(seconds: 1),
            ));
    });
  }
}
