import 'package:dlinks/data/repository/UserRepository.dart';
import 'package:dlinks/data/services/LocalCacheService.dart';
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
    LocalCacheService.getBool('isLogin').then((value) {
      if (value == true) {
        Get.find<UserRepository>()
            .authService
            .value.handleSignIn()
            .then((value) {
          if (value != null) {
            Get.find<UserRepository>().userProvider.value.currentUser = value;
            Get.offAllNamed(AppRoute.home);
          } else {
            Get.offAllNamed(AppRoute.signin);
          }
        });
      } else {
        Get.offAllNamed(AppRoute.signin);
      }
    });

  }
}
