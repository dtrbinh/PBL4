import 'package:dlinks/architecture/BaseViewModel.dart';
import 'package:dlinks/data/provider/UserProvider.dart';
import 'package:dlinks/utils/RouteManager.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class SignInViewModel extends BaseViewModel {
  void loginGoogle(BuildContext context) {
    context.read<UserProvider>().accountRepository.handleSignIn().then((value) {
      if (value) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            duration: Duration(microseconds: 800),
            content: Text("Login successfully!")));
        Navigator.pushReplacementNamed(context, AppRoute.home);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Login failed, please try again.")));
      }
    });
  }

  void loginPhoneNum(BuildContext context) {
    //TODO
  }
}
