import 'package:dlinks/architecture/BaseViewModel.dart';
import 'package:dlinks/data/provider/UserProvider.dart';
import 'package:dlinks/utils/RouteManager.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class SignInViewModel extends BaseViewModel {
  void loginGoogle(BuildContext context) {
    context.read<UserProvider>().accountRepository.handleSignIn().then((value) {
      if (value != null) {
        context.read<UserProvider>().userRepository.currentUser = value;
        Navigator.pushReplacementNamed(context, AppRoute.home);
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(value != null
              ? "Login successfully!"
              : "Login failed, please try again."),
          duration: const Duration(seconds: 1)));
    });
  }

  void loginPhoneNum(BuildContext context) {
    //TODO
  }

  void showComingSoonDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Coming soon"),
              content: const Text("This feature is coming soon!"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("OK"))
              ],
            ));
  }
}
