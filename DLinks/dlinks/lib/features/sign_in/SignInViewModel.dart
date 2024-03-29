import 'package:dlinks/data/repository/UserRepository.dart';
import 'package:dlinks/utils/RouteManager.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class SignInViewModel extends GetxController {
  UserRepository c = Get.find<UserRepository>();
  var isLoading = false.obs;
  void loginGoogle() {
    c.authService.value.handleSignIn().then((value) {
      if (value != null) {
        c.userProvider.value.currentUser = value;
        Get.offNamed(AppRoute.home);
      }
      isLoading.value = false;
      Get.snackbar(
          'Notification',
          value != null
              ? "Login successfully!"
              : "Login failed, please try again.",
          colorText: Colors.white,
          backgroundColor: Colors.black,
          duration: const Duration(seconds: 2),
          snackPosition: SnackPosition.TOP);
    });
  }

  void loginPhoneNum() {
    //TODO
  }

  void showComingSoonDialog() {
    Get.dialog(AlertDialog(
      title: const Text("Coming soon"),
      content: const Text("This feature is coming soon!"),
      actions: [
        TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text("OK"))
      ],
    ));
  }
}
