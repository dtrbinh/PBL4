import 'package:dlinks/features/home/HomeView.dart';
import 'package:dlinks/features/sign_in/SignInView.dart';
import 'package:dlinks/features/splash/SplashView.dart';
import 'package:flutter/material.dart';

import '../data/services/error_manager/RouteUndefined.dart';

class AppRoute {
  static const String splash = '/';
  static const String home = '/home';
  static const String signin = '/signin';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgotPassword';

  static Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(
          builder: (_) {
            return const SplashView();
          },
        );
      case home:
        return MaterialPageRoute(
          builder: (_) {
            return const HomeView();
          },
        );
      case signin:
        return MaterialPageRoute(
          builder: (_) {
            return const SignIn();
          },
        );
      case signup:
        return MaterialPageRoute(
          builder: (_) {
            return const SplashView();
          },
        );
      case forgotPassword:
        return MaterialPageRoute(
          builder: (_) {
            return const SplashView();
          },
        );
      default:
        return MaterialPageRoute(
          builder: (_) {
            return const RouteUndefined();
          },
        );
    }
  }
}
