import 'package:get/get.dart';

import '../provider/UserProvider.dart';
import '../services/AuthService.dart';

class UserRepository extends GetxController {
  final Rx<UserProvider> userProvider = UserProvider().obs;

  final Rx<AuthService> authService = AuthService.instance.obs;

  //reset all data
  void reset() {
    userProvider.value = UserProvider();
    authService.value = AuthService.instance;
  }
}
