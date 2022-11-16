import 'package:dlinks/data/provider/UserProvider.dart';
import 'package:dlinks/utils/RouteManager.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class SignInViewModel extends GetxController {
  UserProvider c = Get.find<UserProvider>();

  void loginGoogle() {
    c.authProvider.value.handleSignIn().then((value) {
      if (value != null) {
        c.userRepository.value.currentUser = value;
        Get.offNamed(AppRoute.home);
      }
      Get.snackbar(
          'Notification',
          value != null
              ? "Login successfully!"
              : "Login failed, please try again.",
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
          snackPosition: SnackPosition.BOTTOM);
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
