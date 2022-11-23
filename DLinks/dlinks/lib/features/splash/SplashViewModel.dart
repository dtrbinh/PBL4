import 'package:dlinks/data/provider/UserProvider.dart';
import 'package:dlinks/utils/RouteManager.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashViewModel extends GetxController {
  void initAppData() async {
    await Permission.storage.status.then((value) async {
      value.isGranted ? {} : {await Permission.storage.request()};
    });
    await Permission.manageExternalStorage.status.then((value) async {
      value.isGranted ? {} : {await Permission.storage.request()};
    });
    quickLogin();
  }

  void quickLogin() {
    Get.find<UserProvider>()
        .authService
        .value
        .firebaseService
        .signInWithGoogle()
        .then((value) {
      if (value != null) {
        Get.find<UserProvider>().userRepository.value.currentUser = value;
        Get.offAllNamed(AppRoute.home);
      } else {
        Get.offAllNamed(AppRoute.signin);
      }
    });
  }
}
