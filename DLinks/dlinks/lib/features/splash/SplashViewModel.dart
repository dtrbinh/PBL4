
import 'package:dlinks/architecture/BaseViewModel.dart';
import 'package:dlinks/utils/RouteManager.dart';
import 'package:flutter/material.dart';

class SplashViewModel extends BaseViewModel {
  void initAppData(BuildContext context) async {
    await Future<void>.delayed(const Duration(milliseconds: 3000)).then(
    (value) => Navigator.pushReplacementNamed(context, AppRoute.signin),
    );
  }
}
