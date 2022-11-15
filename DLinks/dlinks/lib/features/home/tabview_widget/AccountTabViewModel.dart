import 'package:dlinks/data/provider/UserProvider.dart';
import 'package:dlinks/utils/RouteManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import '../../../architecture/BaseWidgetModel.dart';

class AccountTabViewModel extends BaseWidgetModel {
  Future<void> logout(BuildContext context) async {
    context.read<UserProvider>().userRepository.logoutCurrentUser();
    await context
        .read<UserProvider>()
        .authProvider
        .handleSignOut()
        .then((value) {
      value
          ? SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.pushReplacementNamed(
                context,
                AppRoute.signin,
              );
            })
          : ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Logout failed"),
              duration: Duration(seconds: 1),
            ));
    });
  }
}
