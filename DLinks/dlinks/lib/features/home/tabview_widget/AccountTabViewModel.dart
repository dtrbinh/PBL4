import 'package:dlinks/data/provider/UserProvider.dart';
import 'package:dlinks/utils/RouteManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

class AccountTabViewModel extends GetxController {
  UserProvider c = Get.find<UserProvider>();

  Future<void> logout() async {
    c.userRepository.value.logoutCurrentUser();
    c.authService.value.handleSignOut().then((value) {
      value
          ? SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              Get.offNamedUntil(AppRoute.signin, ModalRoute.withName('/signin'));
            })
          : Get.showSnackbar(const GetSnackBar(
              message: 'Logout failed',
              duration: Duration(seconds: 1),
            ));
    });
  }
}
